import 'package:flutter/material.dart';

void main() {
  runApp(CheckOut());
}

class CheckOut extends StatelessWidget {
  const CheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CheckoutPage());
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // This is the variable that holds the selected payment method
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),

        centerTitle: true,
        title: Text('Checkout'),
        leading: IconButton(
          // Custom back button on the left
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back when pressed
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location and Time Information
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(
                          6.0,
                        ), // adjust for circle size
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/loc.png',
                          width: 30,
                          height: 30,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(width: 17.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '325 15th Eighth Avenue, New York',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Saepe eaque fugiat ea voluptatum veniam.'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/clock.png',
                          width: 30,
                          height: 30,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(width: 6.0),
                      Text('6:00 pm, Wednesday 20'),
                    ],
                  ),
                ],
              ),
            ),
            // Order Summary
            Container(
              color: Colors.grey[100], // Light gray background
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text('Items'), Text('3')],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text('Subtotal'), Text('\$423')],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text('Discount'), Text('\$4')],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text('Delivery Charges'), Text('\$2')],
                    ),
                    const SizedBox(height: 12.0),
                    const Divider(),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$423',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Choose Payment Method
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose payment method',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedPaymentMethod == 'paypal') {
                          _selectedPaymentMethod =
                              null; // Deselect to hide the check
                        } else {
                          _selectedPaymentMethod =
                              'paypal'; // Select to show the check
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color:
                                      Colors
                                          .grey
                                          .shade200, // Permanent light gray circle
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/paypal.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Paypal'),
                            ],
                          ),
                          // Checkmark visibility depends on selection
                          Visibility(
                            visible: _selectedPaymentMethod == 'paypal',
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: const Color.fromARGB(255, 114, 38, 149),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // GestureDetector for Credit Card option
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = 'credit_card';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              _selectedPaymentMethod == 'credit_card'
                                  ? const Color.fromARGB(
                                    255,
                                    164,
                                    185,
                                    201,
                                  ) // Border color for the selected item
                                  : const Color.fromARGB(0, 130, 51, 158),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color:
                                      Colors
                                          .grey
                                          .shade200, // light gray background
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/creditcard.png', // Your Credit Card image asset
                                  width: 15,
                                  height: 15,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Credit Card'),
                            ],
                          ),
                          // Display checkmark on the right when selected
                          if (_selectedPaymentMethod == 'credit_card')
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    Colors
                                        .grey
                                        .shade300, // Grey background when selected
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: const Color.fromARGB(255, 114, 38, 149),
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // GestureDetector for Cash option
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = 'cash';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              _selectedPaymentMethod == 'cash'
                                  ? Colors
                                      .blue // Border color for the selected item
                                  : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color:
                                      Colors
                                          .grey
                                          .shade200, // light gray background
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/coin.png', // Your Cash image asset
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Cash'),
                            ],
                          ),
                          // Display checkmark on the right when selected
                          if (_selectedPaymentMethod == 'cash')
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    Colors
                                        .grey
                                        .shade300, // Grey background when selected
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: const Color.fromARGB(255, 114, 38, 149),
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // "Add new payment method" option
                  InkWell(
                    onTap: () {
                      // Handle adding a new payment method
                      print("Add new payment method tapped");
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.add),
                        SizedBox(width: 8.0),
                        Text('Add new payment method'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // "Check Out" Button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle checkout logic
                          print(
                            "Checkout tapped with payment method: $_selectedPaymentMethod",
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.deepPurple, // Purple background
                          foregroundColor: Colors.white, // White text
                        ),
                        child: const Text('Check Out'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
