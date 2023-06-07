import 'package:advisor_ui/json/create_budget_json.dart';
import 'package:advisor_ui/pages/scanned_values_page.dart';
import 'package:advisor_ui/theme/colors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'addCategory.dart';

class CreatBudgetPage extends StatefulWidget {
  @override
  _BudgetAddPageState createState() => _BudgetAddPageState();
}

class _BudgetAddPageState extends State<CreatBudgetPage> {
  int activeCategory = 0;
  TextEditingController _budgetName = TextEditingController(text: "Grocery Budget");
  TextEditingController _budgetPrice = TextEditingController(text: "\$1500.00");
  List<CameraDescription>? cameras; // list out the cameras available
  CameraController? controller; // controller for camera
  XFile? image; // for captured image

  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  loadCamera() async {
  PermissionStatus cameraStatus = await Permission.camera.request();
  PermissionStatus storageStatus = await Permission.storage.request();

  if (cameraStatus.isGranted && storageStatus.isGranted) {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.max);
      // cameras[0] = first camera, change to 1 for another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("No camera found");
    }
  } else {
    print("Permission not granted");
  }
}


  _startScan() async {
    try {
      List<OcrText> list = await FlutterMobileVision.read(
        waitTap: true,
        fps: 5,
      );

      // Process the OCR results and extract the billing information
      String? billingInfo;
      for (OcrText text in list) {
        if (text.value.toLowerCase().contains('total') ||
            text.value.toLowerCase().contains('amount') ||
            text.value.toLowerCase().contains('balance')) {
          // Extract the billing information from the OCR text
          billingInfo = text.value;
          break;
        }
      }

      if (billingInfo != null) {
        // Do something with the billing information
        print('Billing Information: $billingInfo');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScannedValuesPage(scannedValues: list),
          ),
        );
      } else {
        print('Billing Information not found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
   void _addCategory() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddCategoryPage()),
  ).then((newCategory) {
    if (newCategory != null) {
      setState(() {
        categories.add(newCategory);
      });
    }
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: white, boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
              ),
            ]),
            child: Padding(
              padding: const EdgeInsets.only(top: 60, right: 20, left: 20, bottom: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Create budget",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: black),
                      ),
                      IconButton(
                        icon: const Icon(AntDesign.scan1),
                        onPressed: _startScan,
                    //     ()  async{
                    //     try {
                    //       if(controller != null){ //check if contrller is not null
                    //           if(controller!.value.isInitialized){ //check if controller is initialized
                    //               image = await controller!.takePicture(); //capture image
                    //               setState(() {
                    //                 //update UI
                    //               });
                    //           }
                    //       }
                    //     } catch (e) {
                    //         print(e); //show error
                    //     }
                    // },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Text(
                      "Choose category",
                      style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: black.withOpacity(0.5)),
                    ),
                    ElevatedButton(onPressed: _addCategory, child: Text('Add Category'))
                    // IconButton(
                    //   icon: Icon(Icons.add),
                    //   onPressed: _addCategory,
                    // ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(categories.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    activeCategory = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 150,
                    height: 170,
                    decoration: BoxDecoration(
                      color: white,
                      border: Border.all(
                        width: 2,
                        color: activeCategory == index ? primary : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: grey.withOpacity(0.01),
                          spreadRadius: 10,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: grey.withOpacity(0.15),
                            ),
                            child: Center(
                              child: Image.asset(
                                categories[index]['icon'],
                                width: 30,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Text(
                            categories[index]['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
             
          ),
        ),
  
        
        // Static button container
        // Container(
        //   margin: EdgeInsets.only(top: 20),
        //   width: size.width,
        //   height: 60,
        //   decoration: BoxDecoration(
        //     color: primary,
        //     borderRadius: BorderRadius.circular(15),
        //   ),
        //   child: TextButton(
        //     onPressed: () {
        //       // Navigate to another page
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => AddCategoryPage()),
        //       );
        //     },
        //     child: Text(
        //       'Go to Another Page',
        //       style: TextStyle(
        //         color: white,
        //         fontSize: 16,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),),
        //   SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: Row(
        //         children: List.generate(categories.length, (index) {
        //       return GestureDetector(
        //         onTap: () {
        //           setState(() {
        //             activeCategory = index;
        //           });
        //         },
        //         child: Padding(
        //           padding: const EdgeInsets.only(
        //             left: 10,
        //           ),
        //           child: Container(
        //             margin: EdgeInsets.only(
        //               left: 10,
        //             ),
        //             width: 150,
        //             height: 170,
        //             decoration: BoxDecoration(
        //                 color: white,
        //                 border: Border.all(
        //                     width: 2,
        //                     color: activeCategory == index
        //                         ? primary
        //                         : Colors.transparent),
        //                 borderRadius: BorderRadius.circular(12),
        //                 boxShadow: [
        //                   BoxShadow(
        //                     color: grey.withOpacity(0.01),
        //                     spreadRadius: 10,
        //                     blurRadius: 3,
        //                     // changes position of shadow
        //                   ),
        //                 ]),
        //             child: Padding(
        //               padding: const EdgeInsets.only(
        //                   left: 25, right: 25, top: 20, bottom: 20),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Container(
        //                       width: 40,
        //                       height: 40,
        //                       decoration: BoxDecoration(
        //                           shape: BoxShape.circle,
        //                           color: grey.withOpacity(0.15)),
        //                       child: Center(
        //                         child: Image.asset(
        //                           categories[index]['icon'],
        //                           width: 30,
        //                           height: 30,
        //                           fit: BoxFit.contain,
        //                         ),
        //                       )
        //                     ),
        //                   Text(
        //                     categories[index]['name'],
        //                     style: TextStyle(
        //                       fontWeight: FontWeight.bold,
        //                       fontSize: 20,
        //                     ),
        //                   ),
        //                 ],
                       
        //               ),
        //             ),
        //           ),
        //         ),
        //       );
              
        //     }
        //   )
        // ),
        // ),
          
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "budget name",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Color(0xff67727d)),
                ),
                TextField(
                  controller: _budgetName,
                  cursorColor: black,
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold, color: black),
                  decoration: InputDecoration(
                      hintText: "Enter Budget Name", border: InputBorder.none),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (size.width - 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enter budget",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d)),
                          ),
                          TextField(
                            controller: _budgetPrice,
                            cursorColor: black,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: black),
                            decoration: InputDecoration(
                                hintText: "Enter Budget",
                                border: InputBorder.none),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(15)),
                      child: Icon(
                        Icons.arrow_forward,
                        color: white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}

class category{
  final String name;
  final String icon;
  category({required this.name, required this.icon});
}




