        <?php
         
        require_once("simplifycommerce/lib/Simplify.php");
         
        Simplify::$publicKey = 'sbpb_ZDQ3ZjU3N2ItNWY5My00ZWU1LWI3NjUtMzNiMTQyMjc3NmVm';
        Simplify::$privateKey = 'cl5KEXyHM7tgQDBP6XiMjaVEgAAPsHxEnnGlNF1xdxt5YFFQL0ODSXAOkNtXTToq';
         
        $payment = Simplify_Payment::createPayment(array(
                'amount' => $_REQUEST[amount],
                'token' => $_REQUEST[token],
                'description' => 'payment description',
                'reference' => '7a6ef6be31',
                'currency' => 'USD'
        ));
         
        if ($payment->paymentStatus == 'APPROVED') {
            echo "Payment approved\n";
        }
         
        ?>