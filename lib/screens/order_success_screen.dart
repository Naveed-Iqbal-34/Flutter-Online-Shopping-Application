import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final int itemCount;
  final double totalAmount;
  final String estimatedDelivery;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.itemCount,
    required this.totalAmount,
    required this.estimatedDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FFE8),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          child: Column(
            children: [

              const SizedBox(height: 85),

              // =====================================
              // SUCCESS ICON
              // =====================================

              Container(
                width: 115,
                height: 115,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 78,
                ),
              ),

              const SizedBox(height: 27),

              // =====================================
              // TITLE
              // =====================================

              const Text(
                'Order Placed\nSuccessfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 17),

              // =====================================
              // DESCRIPTION
              // =====================================

              const Text(
                'Thank you fro shopping with us.\n'
                    'Your order his been confirmed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 17),

              // =====================================
              // ORDER INFORMATION CARD
              // =====================================

              Container(
                width: double.infinity,
                height: 157,

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(35),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                child: Row(
                  children: [

                    // =================================
                    // DELIVERY ICON
                    // =================================

                    SizedBox(
                      width: 90,
                      child: Image.asset(
                        'assets/images/delivery.png',
                        fit: BoxFit.contain,

                        errorBuilder:
                            (context, error, stackTrace) {
                          return const Icon(
                            Icons.local_shipping,
                            size: 65,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 15),

                    // =================================
                    // ORDER DETAILS
                    // =================================

                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          _orderText(
                            'Order ID:',
                            orderId,
                          ),

                          const SizedBox(height: 8),

                          _orderText(
                            'Item Count:',
                            itemCount.toString(),
                          ),

                          const SizedBox(height: 8),

                          _orderText(
                            'Total amount:',
                            'Rs. ${totalAmount.toStringAsFixed(0)}',
                          ),

                          const SizedBox(height: 8),

                          _orderText(
                            'Estimated Delivery:',
                            estimatedDelivery,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // =====================================
              // CONTINUE SHOPPING BUTTON
              // =====================================

              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF477DFF),

                    foregroundColor: Colors.white,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),

                  child: const Text(
                    'Continue Shopping',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 17),

              // =====================================
              // VIEW ORDER DETAIL BUTTON
              // =====================================

              SizedBox(
                width: double.infinity,
                height: 52,

                child: OutlinedButton(
                  onPressed: () {
                    // Open order detail screen
                  },

                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,

                    foregroundColor:
                    const Color(0xFF477DFF),

                    side: const BorderSide(
                      color: Color(0xFF477DFF),
                      width: 1,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),

                  child: const Text(
                    'View Order Detail',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================
  // ORDER TEXT
  // ===========================================

  static Widget _orderText(
      String title,
      String value,
      ) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: '$title ',
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}