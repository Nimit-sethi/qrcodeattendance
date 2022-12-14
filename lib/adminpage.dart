import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'model/admin.dart';
import 'model/user.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  TextEditingController controller = TextEditingController();
  // double? screenwidth;
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xffeef444c);
  final CountdownController _controller = CountdownController(autoStart: false);
  String barcodeData = "12345";
  // String scanResult = " ";

  // Future<void> scanQR() async {
  //   String result = "";
  //
  //   try {
  //     result = await FlutterBarcodeScanner.scanBarcode(
  //       "#0000ff",
  //       "Cancel",
  //       false,
  //       ScanMode.BARCODE,
  //     );
  //   } catch (e) {
  //     print("ERROR");
  //   }
  //
  //   setState(() {
  //     scanResult = result;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    // screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 10, right: 10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 1, left: 15),
              child: Text(
                "Welcome,",
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: "NexaRegular",
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 15),
              child: Text(
                Admin.id.toUpperCase(),
                style: TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  hintText: 'Add text to convert to Qr Code',
                  // helperText: 'Helper Text',

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            BarcodeWidget(
              data: barcodeData,
              barcode: Barcode.qrCode(),
            ),
            SizedBox(
              height: 20,
            ),
            Countdown(
              controller: _controller,
              seconds: 15,
              build: (_, double time) => Container(
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.black, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        time.toString(),
                        style: const TextStyle(
                          fontSize: 65,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: Text(
                          "s",
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              interval: const Duration(milliseconds: 100),
              onFinished: () {
                FirebaseFirestore.instance
                    .collection("Attributes")
                    .doc("Office1")
                    .set({
                  'code': " ",
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Timer is done!'),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (controller.text.length >= 5) {
                          _controller.start();
                          if (_controller.isCompleted!) {
                            _controller.restart();
                          }
                          // Map<String,String> datatoAdd={
                          //   'code':controller.text,
                          // };
                          FirebaseFirestore.instance
                              .collection("Attributes")
                              .doc("Office1")
                              .set({
                            'code': controller.text,
                          });

                          setState(() {
                            barcodeData = controller.text;
                          });
                        }
                      },
                      child: Container(
                        // margin: EdgeInsets.only(top: 40),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                        height: 70,
                        width: double.infinity,
                        child: const Center(
                          child: Text(
                            "Update QR Data",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: GestureDetector(
                //       onTap: () async {
                //         if (controller.text.length >= 5) {
                //           // Map<String,String> datatoAdd={
                //           //   'code':controller.text,
                //           // };
                //           _controller.start();
                //         }
                //       },
                //       child: Container(
                //         // margin: EdgeInsets.only(top: 40),
                //         decoration: BoxDecoration(
                //           color: primary,
                //           borderRadius:
                //               const BorderRadius.all(Radius.circular(30)),
                //         ),
                //         height: 70,
                //         width: double.infinity,
                //         child: const Center(
                //           child: Text(
                //             "Start timer",
                //             textAlign: TextAlign.center,
                //             style: TextStyle(
                //               fontFamily: "NexaBold",
                //               color: Colors.white,
                //               fontSize: 20,
                //               letterSpacing: 2,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
