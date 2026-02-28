<?php
require_once('settings/db.php');
require_once('settings/inventory_functions.php');
session_start();

if (!isset($_SESSION['user_id'])) {
    header('location:LogReg/login.php');
    exit;
}

$user_id = (int) $_SESSION['user_id'];
if ($user_id <= 0) {
    header('location:LogReg/login.php?pesan=staff_only');
    exit;
}

$user_res = mysqli_query($con, "SELECT * FROM user_info WHERE id=$user_id LIMIT 1");
if (!$user_res || mysqli_num_rows($user_res) == 0) {
    session_destroy();
    header('location:LogReg/login.php?pesan=invalid_staff');
    exit;
}

// Check if ordere has source column (for Source report)
$source_column_exists = false;
$cols = mysqli_query($con, "SHOW COLUMNS FROM ordere LIKE 'source'");
if ($cols && mysqli_num_rows($cols) > 0) {
    $source_column_exists = true;
}

// Check if ordere has delivery_cost column (for Delivery Cost reports)
$delivery_cost_column_exists = false;
$dcols = mysqli_query($con, "SHOW COLUMNS FROM ordere LIKE 'delivery_cost'");
if ($dcols && mysqli_num_rows($dcols) > 0) {
    $delivery_cost_column_exists = true;
}

// Sales amount: use final_total when set, else total_price. Exclude cancelled.
$cancel_cond = " AND (valid IS NULL OR valid != 'Cancled') ";
$amount_sql = "COALESCE(NULLIF(final_total, 0), total_price)";

// Date filter from request
$period = isset($_GET['period']) ? $_GET['period'] : 'ytd';
$from_date = isset($_GET['from_date']) ? $_GET['from_date'] : '';
$to_date   = isset($_GET['to_date'])   ? $_GET['to_date']   : '';

// Build date condition (custom range overrides period preset)
$date_condition = "1=1";
if (!empty($from_date) && !empty($to_date)) {
    $from_esc = mysqli_real_escape_string($con, $from_date);
    $to_esc   = mysqli_real_escape_string($con, $to_date);
    $date_condition = "DATE(dat) BETWEEN '$from_esc' AND '$to_esc'";
} else {
    switch ($period) {
        case 'day':
            $date_condition = "DATE(dat) = CURDATE()";
            break;
        case 'week':
            $date_condition = "YEAR(dat) = YEAR(CURDATE()) AND WEEK(dat) = WEEK(CURDATE())";
            break;
        case 'month':
            $date_condition = "YEAR(dat) = YEAR(CURDATE()) AND MONTH(dat) = MONTH(CURDATE())";
            break;
        case 'year':
            $date_condition = "YEAR(dat) = YEAR(CURDATE())";
            break;
        case 'ytd':
        default:
            $date_condition = "YEAR(dat) = YEAR(CURDATE())";
            break;
    }
}

$where_base = "WHERE $date_condition $cancel_cond";

// Today's total and Week total (always for current day/week)
$where_today = "WHERE DATE(dat) = CURDATE() $cancel_cond";
$where_week  = "WHERE YEAR(dat) = YEAR(CURDATE()) AND WEEK(dat) = WEEK(CURDATE()) $cancel_cond";
$q_today = mysqli_query($con, "SELECT SUM($amount_sql) AS total FROM ordere $where_today");
$today_total = (float) (mysqli_fetch_assoc($q_today)['total'] ?? 0);
$q_week = mysqli_query($con, "SELECT SUM($amount_sql) AS total FROM ordere $where_week");
$week_total = (float) (mysqli_fetch_assoc($q_week)['total'] ?? 0);

// Days in selected period (for daily average)
$days_in_period = 1;
if (!empty($from_date) && !empty($to_date)) {
    $d1 = new DateTime($from_date);
    $d2 = new DateTime($to_date);
    $days_in_period = max(1, (int) $d2->diff($d1)->days + 1);
} else {
    switch ($period) {
        case 'day':
            $days_in_period = 1;
            break;
        case 'week':
            $days_in_period = 7;
            break;
        case 'month':
            $days_in_period = (int) date('t'); // days in current month
            break;
        case 'year':
        case 'ytd':
        default:
            $days_in_period = (int) date('z') + 1; // day of year (YTD so far)
            if ($period === 'year') {
                $days_in_period = date('L') ? 366 : 365;
            }
            break;
    }
}

// 1) Total sales (by period)
$q_total = mysqli_query($con, "SELECT SUM($amount_sql) AS total_sales, COUNT(*) AS order_count FROM ordere $where_base");
$row_total = mysqli_fetch_assoc($q_total);
$total_sales = (float) ($row_total['total_sales'] ?? 0);
$order_count = (int) ($row_total['order_count'] ?? 0);

// Additional stats: daily average (total sales / days in period), average sale per order
$daily_average = $days_in_period > 0 ? ($total_sales / $days_in_period) : 0;
$average_sale = $order_count > 0 ? ($total_sales / $order_count) : 0;

// 2) Sales by payment type
$q_by_method = mysqli_query($con, "SELECT method, SUM($amount_sql) AS total, COUNT(*) AS cnt FROM ordere $where_base GROUP BY method ORDER BY total DESC");
$by_method = [];
while ($r = mysqli_fetch_assoc($q_by_method)) {
    $by_method[] = $r;
}

// 3) Sales by source (if column exists)
$by_source = [];
if ($source_column_exists) {
    $q_by_source = mysqli_query($con, "SELECT COALESCE(NULLIF(TRIM(source), ''), 'Direct') AS source, SUM($amount_sql) AS total, COUNT(*) AS cnt FROM ordere $where_base GROUP BY COALESCE(NULLIF(TRIM(source), ''), 'Direct') ORDER BY total DESC");
    while ($r = mysqli_fetch_assoc($q_by_source)) {
        $by_source[] = $r;
    }
}

// 4) Delivery fee collected vs Delivery Cost (same period)
$q_delivery = mysqli_query($con, "SELECT SUM(COALESCE(delivery_fee, 0)) AS total_fee_collected, COUNT(*) AS delivery_count FROM ordere $where_base");
$row_delivery = mysqli_fetch_assoc($q_delivery);
$delivery_fee_collected = (float) ($row_delivery['total_fee_collected'] ?? 0);
$delivery_count = (int) ($row_delivery['delivery_count'] ?? 0);

$total_delivery_cost = null;
if ($delivery_cost_column_exists) {
    $q_cost = mysqli_query($con, "SELECT SUM(COALESCE(delivery_cost, 0)) AS total_cost FROM ordere $where_base");
    $row_cost = mysqli_fetch_assoc($q_cost);
    $total_delivery_cost = (float) ($row_cost['total_cost'] ?? 0);
}

// 5) Average per delivery
$avg_fee_per_delivery = $delivery_count > 0 ? ($delivery_fee_collected / $delivery_count) : 0;
$avg_cost_per_delivery = ($delivery_cost_column_exists && $delivery_count > 0 && $total_delivery_cost !== null) ? ($total_delivery_cost / $delivery_count) : null;

// 6) Delivery cost as % of sales
$delivery_cost_pct = null;
$delivery_fee_pct = 0;
if ($total_sales > 0) {
    $delivery_fee_pct = ($delivery_fee_collected / $total_sales) * 100;
    if ($delivery_cost_column_exists && $total_delivery_cost !== null) {
        $delivery_cost_pct = ($total_delivery_cost / $total_sales) * 100;
    }
}

// 7–9) Sales by product type (category), by brand, and all products (from parsed order lines)
$sales_by_cat = [];
$sales_by_brand = [];
$sales_by_product = [];
$brand_column_exists = false;
$bcols = mysqli_query($con, "SHOW COLUMNS FROM movies LIKE 'brand_id'");
if ($bcols && mysqli_num_rows($bcols) > 0) {
    $brand_column_exists = true;
}

$orders_result = mysqli_query($con, "SELECT id, total_products FROM ordere $where_base");
if ($orders_result) {
    $movie_ids = [];
    while ($ord = mysqli_fetch_assoc($orders_result)) {
        $items = parseOrderProducts($ord['total_products']);
        foreach ($items as $item) {
            $mid = (int) $item['id'];
            $line_total = (float) $item['quantity'] * (float) $item['price'];
            $movie_ids[$mid] = true;
            if (!isset($sales_by_product[$mid])) {
                $sales_by_product[$mid] = ['name' => $item['name'], 'total' => 0];
            }
            $sales_by_product[$mid]['total'] += $line_total;
        }
    }
    if (!empty($movie_ids)) {
        $ids_list = implode(',', array_map('intval', array_keys($movie_ids)));
        $movie_cols = $brand_column_exists ? "movie_id, cat_id, brand_id" : "movie_id, cat_id";
        $q_m = mysqli_query($con, "SELECT $movie_cols FROM movies WHERE movie_id IN ($ids_list)");
        $movie_meta = [];
        while ($m = mysqli_fetch_assoc($q_m)) {
            $bid = 0;
            if ($brand_column_exists && isset($m['brand_id']) && $m['brand_id'] !== null && $m['brand_id'] !== '') {
                $bid = (int) $m['brand_id'];
            }
            $movie_meta[$m['movie_id']] = [
                'cat_id' => (int) $m['cat_id'],
                'brand_id' => $bid
            ];
        }
        $orders_result2 = mysqli_query($con, "SELECT total_products FROM ordere $where_base");
        if ($orders_result2) {
            while ($ord = mysqli_fetch_assoc($orders_result2)) {
                $items = parseOrderProducts($ord['total_products']);
                foreach ($items as $item) {
                    $mid = (int) $item['id'];
                    $line_total = (float) $item['quantity'] * (float) $item['price'];
                    if (isset($movie_meta[$mid])) {
                        $cid = $movie_meta[$mid]['cat_id'];
                        $bid = $movie_meta[$mid]['brand_id'];
                        $sales_by_cat[$cid] = ($sales_by_cat[$cid] ?? 0) + $line_total;
                        $sales_by_brand[$bid] = ($sales_by_brand[$bid] ?? 0) + $line_total;
                    }
                }
            }
        }
    }
}

// Resolve category and brand names
$cat_names = [];
$q_cat = mysqli_query($con, "SELECT id, cat_name FROM cat");
if ($q_cat) {
    while ($c = mysqli_fetch_assoc($q_cat)) {
        $cat_names[(int) $c['id']] = $c['cat_name'];
    }
}
$brand_names = [];
if ($brand_column_exists) {
    $q_brand = mysqli_query($con, "SELECT id, brand_name FROM brand");
    if ($q_brand) {
        while ($b = mysqli_fetch_assoc($q_brand)) {
            $brand_names[(int) $b['id']] = $b['brand_name'];
        }
    }
    $brand_names[0] = 'No brand';
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Accounting - 420 Vallarta</title>
    <link rel="shortcut icon" href="Favi/favicon.ico">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous">
    <style>
        .report-card { border: 1px solid #dee2e6; border-radius: 8px; padding: 1rem 1.25rem; margin-bottom: 1rem; }
        .report-card h5 { margin-bottom: 0.5rem; color: #04AA6D; }
        #customers { width: 100%; border-collapse: collapse; }
        #customers td, #customers th { border: 1px solid #ddd; padding: 8px; }
        #customers th { background-color: #04AA6D; color: white; text-align: left; }
        #customers tr:nth-child(even) { background-color: #f2f2f2; }
        .total-big { font-size: 1.5rem; font-weight: bold; color: #04AA6D; }
    </style>
</head>
<body>
<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">Accounting</h2>
        <a href="admin.php" class="btn btn-outline-secondary">← Back to Orders</a>
    </div>

    <!-- Filters -->
    <div class="report-card mb-4">
        <h5>Date range</h5>
        <form method="get" action="" class="row g-3 align-items-end">
            <div class="col-auto">
                <label class="form-label">Period</label>
                <select name="period" class="form-select">
                    <option value="day"   <?= $period === 'day'   ? 'selected' : '' ?>>Today</option>
                    <option value="week"  <?= $period === 'week'  ? 'selected' : '' ?>>This week</option>
                    <option value="month" <?= $period === 'month' ? 'selected' : '' ?>>This month</option>
                    <option value="year"  <?= $period === 'year'  ? 'selected' : '' ?>>This year</option>
                    <option value="ytd"   <?= $period === 'ytd'   ? 'selected' : '' ?>>YTD</option>
                </select>
            </div>
            <div class="col-auto">
                <label class="form-label">From date</label>
                <input type="date" name="from_date" class="form-control" value="<?= htmlspecialchars($from_date) ?>">
            </div>
            <div class="col-auto">
                <label class="form-label">To date</label>
                <input type="date" name="to_date" class="form-control" value="<?= htmlspecialchars($to_date) ?>">
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary">Apply</button>
            </div>
        </form>
        <p class="text-muted small mb-0 mt-2">Use period preset or set From/To for a custom range. Cancelled orders are excluded from totals.</p>
    </div>

    <!-- Additional statistics: Today, Week, Daily average, Average sale -->
    <div class="report-card mb-4">
        <h5>Additional statistics</h5>
        <div class="row g-3">
            <div class="col-md-6 col-lg-3">
                <div class="border rounded p-3 bg-light">
                    <div class="small text-muted">Today's total</div>
                    <div class="total-big">$<?= number_format($today_total, 2) ?> MXN</div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="border rounded p-3 bg-light">
                    <div class="small text-muted">Week total</div>
                    <div class="total-big">$<?= number_format($week_total, 2) ?> MXN</div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="border rounded p-3 bg-light">
                    <div class="small text-muted">Daily average <span class="fw-normal">(selected period)</span></div>
                    <div class="total-big">$<?= number_format($daily_average, 2) ?> MXN</div>
                    <div class="small text-muted">over <?= $days_in_period ?> day<?= $days_in_period !== 1 ? 's' : '' ?></div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="border rounded p-3 bg-light">
                    <div class="small text-muted">Average sale <span class="fw-normal">(per order)</span></div>
                    <div class="total-big">$<?= number_format($average_sale, 2) ?> MXN</div>
                    <div class="small text-muted"><?= $order_count ?> order<?= $order_count !== 1 ? 's' : '' ?> in period</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 1. Total sales by period -->
    <div class="report-card">
        <h5>1. Total sales (by period)</h5>
        <p class="mb-1">Total sales: <span class="total-big">$<?= number_format($total_sales, 2) ?> MXN</span></p>
        <p class="text-muted small mb-0">Orders in range: <?= (int) $order_count ?></p>
    </div>

    <!-- 2. Sales by payment type -->
    <div class="report-card">
        <h5>2. Total sales by payment type</h5>
        <table id="customers" class="table table-sm">
            <thead>
                <tr>
                    <th>Payment method</th>
                    <th>Orders</th>
                    <th>Total (MXN)</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($by_method as $r): ?>
                <tr>
                    <td><?= htmlspecialchars($r['method']) ?></td>
                    <td><?= (int) $r['cnt'] ?></td>
                    <td>$<?= number_format((float) $r['total'], 2) ?></td>
                </tr>
                <?php endforeach; ?>
                <?php if (empty($by_method)): ?>
                <tr><td colspan="3" class="text-muted">No orders in this range.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>

    <!-- 3. Sales by source -->
    <div class="report-card">
        <h5>3. Total sales by source (Google, FB, X, IG, etc.)</h5>
        <?php if ($source_column_exists): ?>
        <?php if (!empty($by_source)): ?>
        <div class="mb-4" style="max-width: 400px;">
            <canvas id="salesSourcePieChart" height="280"></canvas>
            <p class="text-muted small mb-0 mt-2">Sales source percentage (selected period)</p>
        </div>
        <?php endif; ?>
        <table id="customers" class="table table-sm">
            <thead>
                <tr>
                    <th>Source</th>
                    <th>Orders</th>
                    <th>Total (MXN)</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($by_source as $r): ?>
                <tr>
                    <td><?= htmlspecialchars($r['source']) ?></td>
                    <td><?= (int) $r['cnt'] ?></td>
                    <td>$<?= number_format((float) $r['total'], 2) ?></td>
                </tr>
                <?php endforeach; ?>
                <?php if (empty($by_source)): ?>
                <tr><td colspan="3" class="text-muted">No orders in this range.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
        <p class="text-muted small mb-0">Capture <code>utm_source</code> at checkout to populate source. Existing orders show as &quot;Direct&quot;.</p>
        <?php else: ?>
        <p class="text-muted">Source tracking is not enabled. Run the SQL below once to add the <code>source</code> column to orders, then capture <code>utm_source</code> (or referrer) on checkout to see sales by Google, FB, X, IG, etc.</p>
        <pre class="bg-light p-3 small">ALTER TABLE `ordere` ADD COLUMN `source` VARCHAR(100) DEFAULT NULL AFTER `method`;</pre>
        <p class="small"><a href="admin_accounting.php">Refresh</a> after running the SQL.</p>
        <?php endif; ?>
    </div>

    <!-- 4. Delivery fee collected vs Delivery Cost -->
    <div class="report-card">
        <h5>4. Delivery fee collected vs. Delivery cost (by period)</h5>
        <table class="table table-sm mb-0">
            <tr>
                <td><strong>Delivery fee collected</strong> (what customers paid)</td>
                <td class="total-big">$<?= number_format($delivery_fee_collected, 2) ?> MXN</td>
            </tr>
            <?php if ($delivery_cost_column_exists): ?>
            <tr>
                <td><strong>Delivery cost</strong> (what you paid — driver, fuel, etc.)</td>
                <td class="total-big">$<?= number_format($total_delivery_cost ?? 0, 2) ?> MXN</td>
            </tr>
            <tr>
                <td>Deliveries in range</td>
                <td><?= $delivery_count ?></td>
            </tr>
            <?php else: ?>
            <tr>
                <td colspan="2" class="text-muted">Delivery cost not tracked. Add the <code>delivery_cost</code> column (see SQL below) and set it per order in Edit/Finalize to compare.</td>
            </tr>
            <?php endif; ?>
        </table>
        <?php if (!$delivery_cost_column_exists): ?>
        <pre class="bg-light p-3 small mt-2 mb-0">ALTER TABLE `ordere` ADD COLUMN `delivery_cost` DECIMAL(10,2) DEFAULT NULL AFTER `delivery_fee`;</pre>
        <?php endif; ?>
    </div>

    <!-- 5. Average per delivery -->
    <div class="report-card">
        <h5>5. Delivery cost average per delivery</h5>
        <p class="mb-1"><strong>Average delivery fee collected</strong> per order: <span class="total-big">$<?= number_format($avg_fee_per_delivery, 2) ?> MXN</span></p>
        <?php if ($delivery_cost_column_exists && $avg_cost_per_delivery !== null): ?>
        <p class="mb-0"><strong>Average delivery cost</strong> per order: <span class="total-big">$<?= number_format($avg_cost_per_delivery, 2) ?> MXN</span></p>
        <?php else: ?>
        <p class="text-muted small mb-0">Add <code>delivery_cost</code> column and set per order to see average delivery cost.</p>
        <?php endif; ?>
    </div>

    <!-- 6. Delivery cost as % of sales -->
    <div class="report-card">
        <h5>6. Delivery cost as percentage of sales</h5>
        <p class="mb-1"><strong>Delivery fee collected</strong> as % of total sales: <span class="total-big"><?= number_format($delivery_fee_pct ?? 0, 2) ?>%</span></p>
        <?php if (isset($delivery_cost_pct) && $delivery_cost_pct !== null): ?>
        <p class="mb-0"><strong>Delivery cost</strong> as % of total sales: <span class="total-big"><?= number_format($delivery_cost_pct, 2) ?>%</span></p>
        <?php else: ?>
        <p class="text-muted small mb-0">Add <code>delivery_cost</code> column and set per order to see delivery cost as % of sales.</p>
        <?php endif; ?>
    </div>

    <!-- 7. Total sales by product type (category) -->
    <div class="report-card">
        <h5>7. Total sales by product type (category) — day/week/month/year</h5>
        <table id="customers" class="table table-sm">
            <thead>
                <tr>
                    <th>Category</th>
                    <th>Total sales (MXN)</th>
                </tr>
            </thead>
            <tbody>
                <?php
                arsort($sales_by_cat);
                foreach ($sales_by_cat as $cid => $total):
                    $label = isset($cat_names[$cid]) ? $cat_names[$cid] : "Category #$cid";
                ?>
                <tr>
                    <td><?= htmlspecialchars($label) ?></td>
                    <td>$<?= number_format($total, 2) ?></td>
                </tr>
                <?php endforeach; ?>
                <?php if (empty($sales_by_cat)): ?>
                <tr><td colspan="2" class="text-muted">No product data in this period or orders could not be parsed.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>

    <!-- 8. Total sales by brand -->
    <div class="report-card">
        <h5>8. Total sales by brand — day/week/month/year</h5>
        <?php if ($brand_column_exists): ?>
        <table id="customers" class="table table-sm">
            <thead>
                <tr>
                    <th>Brand</th>
                    <th>Total sales (MXN)</th>
                </tr>
            </thead>
            <tbody>
                <?php
                arsort($sales_by_brand);
                foreach ($sales_by_brand as $bid => $total):
                    $label = isset($brand_names[$bid]) ? $brand_names[$bid] : "Brand #$bid";
                ?>
                <tr>
                    <td><?= htmlspecialchars($label) ?></td>
                    <td>$<?= number_format($total, 2) ?></td>
                </tr>
                <?php endforeach; ?>
                <?php if (empty($sales_by_brand)): ?>
                <tr><td colspan="2" class="text-muted">No brand data in this period.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
        <?php else: ?>
        <p class="text-muted mb-0">Brand tracking requires a <code>brand_id</code> column on the products (movies) table. Run the brand feature migration if you use brands.</p>
        <?php endif; ?>
    </div>

    <!-- 9. Total sales of all products -->
    <div class="report-card">
        <h5>9. Total sales of all products — day/week/month/year</h5>
        <table id="customers" class="table table-sm">
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Total sales (MXN)</th>
                </tr>
            </thead>
            <tbody>
                <?php
                uasort($sales_by_product, function ($a, $b) { return $b['total'] <=> $a['total']; });
                foreach ($sales_by_product as $pid => $data):
                ?>
                <tr>
                    <td><?= htmlspecialchars($data['name']) ?></td>
                    <td>$<?= number_format($data['total'], 2) ?></td>
                </tr>
                <?php endforeach; ?>
                <?php if (empty($sales_by_product)): ?>
                <tr><td colspan="2" class="text-muted">No product data in this period or orders could not be parsed.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
        <p class="text-muted small mb-0">Product totals are from parsed order lines (quantity × price). Same period filter as above.</p>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/js/bootstrap.bundle.min.js"></script>
<?php if ($source_column_exists && !empty($by_source)): ?>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
(function() {
    var data = <?= json_encode(array_values($by_source)) ?>;
    var labels = data.map(function(r) { return r.source; });
    var values = data.map(function(r) { return parseFloat(r.total); });
    var total = values.reduce(function(a, b) { return a + b; }, 0);
    var colors = ['#04AA6D', '#2196F3', '#FF9800', '#9C27B0', '#E91E63', '#00BCD4', '#8BC34A', '#FF5722', '#607D8B', '#795548'];
    var bg = labels.map(function(_, i) { return colors[i % colors.length]; });
    var ctx = document.getElementById('salesSourcePieChart');
    if (ctx && typeof Chart !== 'undefined') {
        new Chart(ctx.getContext('2d'), {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    data: values,
                    backgroundColor: bg,
                    borderColor: '#fff',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: { position: 'right' },
                    tooltip: {
                        callbacks: {
                            label: function(t) {
                                var pct = total > 0 ? ((t.raw / total) * 100).toFixed(1) : 0;
                                return t.label + ': $' + t.raw.toFixed(2) + ' MXN (' + pct + '%)';
                            }
                        }
                    }
                }
            }
        });
    }
})();
</script>
<?php endif; ?>
</body>
</html>
