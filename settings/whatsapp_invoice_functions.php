<?php
// 420 Vallarta WhatsApp Invoice Generation Functions

require_once('db.php');
require_once('receipt_config.php');
require_once('inventory_functions.php');

/**
 * Generate WhatsApp-friendly text invoice
 * Plain text format that can be copy/pasted to WhatsApp
 */
function generateWhatsAppInvoice($order_id, $custom_settings = array()) {
    global $con;
    
    // Get order data
    $order_query = mysqli_query($con, "SELECT * FROM ordere WHERE id = '$order_id'");
    if (!$order_query || mysqli_num_rows($order_query) == 0) {
        return array('success' => false, 'error' => 'Order not found');
    }
    
    $order = mysqli_fetch_array($order_query);
    $config = getReceiptConfig();
    
    // Parse products from order
    $products = parseOrderProducts($order['total_products']);
    
    // Calculate totals
    $subtotal = 0;
    foreach ($products as $product) {
        $subtotal += $product['price'] * $product['quantity'];
    }
    
    // Get custom settings or defaults
    $delivery_fee = isset($custom_settings['delivery_fee']) ? $custom_settings['delivery_fee'] :
                    (!empty($order['delivery_fee']) ? $order['delivery_fee'] : $config['default_delivery_fee']);
    $discount = isset($custom_settings['discount']) ? $custom_settings['discount'] :
                (!empty($order['discount']) ? $order['discount'] : $config['default_discount']);
    $refund = isset($custom_settings['refund']) ? $custom_settings['refund'] :
              (!empty($order['refund']) ? $order['refund'] : $config['default_refund']);
    $eta = isset($custom_settings['eta']) ? $custom_settings['eta'] :
           (!empty($order['eta']) ? $order['eta'] : $config['default_eta']);
    
    // Handle complimentary items
    if (isset($custom_settings['complimentary_items'])) {
        $complimentary_items = $custom_settings['complimentary_items'];
    } elseif (!empty($order['complimentary_items'])) {
        $decoded = json_decode($order['complimentary_items'], true);
        $complimentary_items = is_array($decoded) ? $decoded : array();
    } else {
        $complimentary_items = array();
    }
    
    // Handle delivery address
    $delivery_address = isset($custom_settings['delivery_address']) ? $custom_settings['delivery_address'] :
                        (!empty($order['delivery_address_final']) ? $order['delivery_address_final'] : $order['adresse']);
    
    // Calculate final totals
    $final_total_mxn = $subtotal + $delivery_fee - $discount - $refund;
    $final_total_usd = convertMXNtoUSD($final_total_mxn);
    
    // Generate client ID
    $client_number = !empty($order['client_number']) ? $order['client_number'] : (100000 + $order_id);
    $client_id = 'CL-' . $client_number;
    
    // Generate receipt ID
    $receipt_id = generateReceiptID($order_id);
    
    // Build WhatsApp message
    $message = buildWhatsAppMessage(
        $order,
        $products,
        $subtotal,
        $delivery_fee,
        $discount,
        $refund,
        $final_total_mxn,
        $final_total_usd,
        $complimentary_items,
        $delivery_address,
        $eta,
        $client_id,
        $receipt_id
    );
    
    return array(
        'success' => true,
        'message' => $message,
        'receipt_id' => $receipt_id,
        'client_id' => $client_id
    );
}

/**
 * Build the WhatsApp message text
 */
function buildWhatsAppMessage($order, $products, $subtotal, $delivery_fee, $discount, $refund, 
                               $final_total_mxn, $final_total_usd, $complimentary_items, 
                               $delivery_address, $eta, $client_id, $receipt_id) {
    $config = getReceiptConfig();
    
    // Extract client number from client_id (remove "CL-" prefix if present)
    $client_number = str_replace('CL-', '', $client_id);
    
    // Start building message
    $msg = "Client ID; {$client_number}\n\n";
    
    // Your Order section
    $msg .= "Your Order:\n\n";
    
    foreach ($products as $product) {
        $total_price = $product['price'] * $product['quantity'];
        // Format price: remove decimals if whole number, otherwise show 2 decimals
        $formatted_price = ($total_price == floor($total_price)) ? number_format($total_price, 0) : number_format($total_price, 2);
        $msg .= "{$product['quantity']} - {$product['name']} \${$formatted_price}\n";
    }
    
    $msg .= "\n";
    
    // Delivery Fee
    $formatted_delivery = ($delivery_fee == floor($delivery_fee)) ? number_format($delivery_fee, 0) : number_format($delivery_fee, 2);
    $msg .= "Delivery Fee; \${$formatted_delivery}\n\n";
    
    // Discount (only show if there's a discount)
    if ($discount > 0) {
        $formatted_discount = ($discount == floor($discount)) ? number_format($discount, 0) : number_format($discount, 2);
        $msg .= "Discount; -\${$formatted_discount}\n\n";
    }
    
    // Total
    $formatted_total = ($final_total_mxn == floor($final_total_mxn)) ? number_format($final_total_mxn, 0) : number_format($final_total_mxn, 2);
    $msg .= "Total;  \${$formatted_total}mx\n\n";
    
    // Complimentary Items
    if (!empty($complimentary_items)) {
        $msg .= "Complimentary:\n\n";
        foreach ($complimentary_items as $item_name => $item_value) {
            // Just show the item name, not the value
            $msg .= "{$item_name}\n";
        }
        $msg .= "\n";
    }
    
    // Delivered to
    $msg .= "Delivered to;\n";
    // Split address by commas or newlines for multi-line display
    $address_lines = preg_split('/[,\n]/', $delivery_address);
    foreach ($address_lines as $line) {
        $line = trim($line);
        if (!empty($line)) {
            $msg .= "{$line}\n";
        }
    }
    $msg .= "\n";
    
    // ETA
    $eta_lower = strtolower($eta);
    $msg .= "ETA; {$eta_lower}\n\n";
    
    // Update message
    $msg .= "We will update you (Prior & During Your Delivery)\n\n";
    
    // Payment section
    $msg .= "PAYMENT\n";
    
    // Format payment method name (clean up common variations)
    $payment_method = $order['method'];
    // Map payment methods to clean names
    $payment_mapping = array(
        'Visa MasterCard Via Stripe' => 'Stripe',
        'Visa/MasterCard/American Express' => 'Stripe',
        'ApplePay/Google Pay' => 'Stripe',
        'Oxxo Transfer' => 'Oxxo',
        'Bank Transfer' => 'Bank Transfer',
        'PayPal' => 'PayPal',
        'Paypal' => 'PayPal',
        'Cash on Delivery' => 'Cash',
        'Cash' => 'Cash'
    );
    
    if (isset($payment_mapping[$payment_method])) {
        $payment_method = $payment_mapping[$payment_method];
    }
    
    $msg .= "{$payment_method}\n";
    $msg .= "{$order['email']}\n\n";
    
    // Social media - only X/Twitter
    $msg .= "Follow us on X\n";
    $msg .= "@420vallarta\n";
    
    return $msg;
}

/**
 * Get payment instructions based on method
 */
function getPaymentInstructions($method) {
    $instructions = array(
        'Cash on Delivery' => 'Please have exact cash ready upon delivery. Our driver will collect payment.',
        'Bank Transfer' => "Please transfer to:\nBank: BBVA\nAccount: [Contact us for details]\nSend proof of transfer via WhatsApp.",
        'Visa MasterCard Via Stripe' => 'Payment link will be sent separately. Click to complete payment securely.',
        'PayPal' => 'PayPal invoice will be sent to your email. Please complete payment through PayPal.',
        'Crypto' => 'Cryptocurrency wallet address will be provided. Send payment and share transaction ID.'
    );
    
    return $instructions[$method] ?? 'Payment method: ' . $method;
}
// Note: generateReceiptID() function is already defined in receipt_config.php
?>


