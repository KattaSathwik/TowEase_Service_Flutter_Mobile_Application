import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter_mobile_app/Components/component.dart';
import 'package:new_flutter_mobile_app/Components/under_part.dart';
import 'package:new_flutter_mobile_app/UserModel.dart';
import 'package:new_flutter_mobile_app/Widgets/conform_rounded_password_field.dart';
import 'package:new_flutter_mobile_app/constants.dart';
import 'package:new_flutter_mobile_app/Screens/screen.dart';
import 'package:new_flutter_mobile_app/Widgets/widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:location/location.dart';

//import 'package:cloud_firestore/src/collection_reference.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Servicer_Observation_Page extends StatefulWidget {
  final String id;

  Servicer_Observation_Page({super.key, required this.id});

  //const Farmer({super.key, required String id});

  @override
  // ignore: no_logic_in_create_state
  State<Servicer_Observation_Page> createState() =>
      Servicer_Observation_Page_State(id: id);
}

class Servicer_Observation_Page_State extends State<Servicer_Observation_Page> {
  String? id;
  var role;
  var email;
  var name;
  var phNo;
  var pass;
  UserRole loggedInUser = UserRole();

  Servicer_Observation_Page_State({required this.id});

  @override
  void initState() {
    super.initState();
    if (id != null && id!.isNotEmpty) {
      // check if id is not null or empty
      FirebaseFirestore.instance
          .collection("register_user") //.where('uid', isEqualTo: user!.uid)
          .doc(id)
          .get()
          .then((value) {
        this.loggedInUser = UserRole.fromMap(value.data());
      }).whenComplete(() {
        CircularProgressIndicator();
        setState(() {
          email = loggedInUser.email?.toString() ?? false;
          role = loggedInUser.role?.toString() ?? false;
          id = loggedInUser.uid?.toString();
          name = loggedInUser.name?.toString() ?? false;
          phNo = loggedInUser.phNo?.toString() ?? false;
          pass = loggedInUser.pass?.toString() ?? false;
        });
      });
    } else {
      print("USER NOT FOUND!!!!!!!!!!!!!!");
    }
  }

  //const LoginScreenState({Key? key}) : super(key: key);

  final _formkey = GlobalKey<FormState>();

  // firebase
  final _auth = FirebaseAuth.instance;

  //final TextEditingController _emailTextController = TextEditingController();
  //final TextEditingController _passwordTextController = TextEditingController();

  List options = [
    'Profile',
    //'Inventory',
    //'Irrigation',
    'Current Location',
    'Book Towing',
    'Accepted Requests'
  ];
  List<Color?> optinColors = [
    Colors.cyanAccent,
    Colors.greenAccent,
    Colors.amber,
    Colors.teal,

    // Colors.green,
    // Colors.green,
  ];
  List<Icon> optionIcons = [
    const Icon(Icons.account_circle_outlined, color: Colors.white, size: 45),
    const Icon(Icons.location_on_outlined, color: Colors.white, size: 45),
    const Icon(Icons.fire_truck_outlined, color: Colors.white, size: 45),
    const Icon(Icons.request_page_outlined, color: Colors.white, size: 45),
    //const Icon(Icons.cabin, color: Colors.white, size:25),
    //const Icon(Icons.cabin, color: Colors.white, size:25),
  ];

  void showAlert(QuickAlertType quickAlertType) {
    QuickAlert.show(
        context: context,
        title: "information",
        text: "These are the options for you\n\nLocation :\n\nAddress :",
        type: quickAlertType,
        confirmBtnText: "Done");
  }

  String location1 = "";
  String location2 = "";
  double distanceInMeters = 0.0;

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values
    int i = 1;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserRole userrole = UserRole();
    UserSendDetails userSendDetails = UserSendDetails();
    UsersAcceptedDetails usersAcceptedDetails = UsersAcceptedDetails();

    // writing all the values
    /* userrole.email = user!.email;
    userrole.uid = user?.uid;*/
    /*userrole.role = role;
    userrole.name = name;
    userrole.phNo = mobile;
    userrole.pass = password;*/
    /*userSendDetails.name = name;
    userSendDetails.location = location;
    userSendDetails.vecType = vecType;
    userSendDetails.sendReq = sendReq;

    String userDetailsId = firebaseFirestore
        .collection("register_user")
        .doc(id)
        .collection("userdetails")
        .doc()
        .id;
    userSendDetails.id = userDetailsId;
    await firebaseFirestore
        .collection("register_user")
        .doc(id)
        .collection("userdetails")
        .doc(userDetailsId)
        .set(userSendDetails.toMap());*/

    // Retrieve all documents from 'userdetails' subcollection
    QuerySnapshot userDetailsSnapshot = await firebaseFirestore
        .collection("register_user")
        .doc(id)
        .collection("accepteduserdetails")
        .get();
    List<Map<String, dynamic>>? acceptedUserDetailsList = userDetailsSnapshot
        .docs
        .map((doc) => doc.data())
        .cast<Map<String, dynamic>>()
        .toList();

    if (acceptedUserDetailsList == Null || acceptedUserDetailsList.isEmpty) {
      QuickAlert.show(
        context: context,
        title: "Warning",
        text: "There are no accepted requests till now",
        type: QuickAlertType.warning,
        confirmBtnText: "Done",
      );
    }

    // Access fields from each document
    for (var userDetails in acceptedUserDetailsList) {
      String username = userDetails['username'];
      if (username == name) {
        String accepteduserdetailsId = userDetails['id'];
        String servicername = userDetails['servicername'];
        //String username = userDetails['username'];
        String usernameid = userDetails['usernameid'];
        String servicernameid = userDetails['servicernameid'];
        String userlocation = userDetails['userlocation'];
        String sendReq = userDetails['sendReq'];
        String vecType = userDetails['vecType'];
        String bookingStatus = userDetails['bookingStatus'];
        String servicerlocation;

        // Retrieve the document data for the specified ID
        DocumentSnapshot userSnapshot = await firebaseFirestore
            .collection("register_user")
            .doc(servicernameid)
            .get();

        // Access the document fields
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;
        if (userData != null) {
          // Access the fields and perform further actions
          // Example: String userName = userData['name'];
          servicerlocation = userData['location'];
          location2 = servicerlocation;
        }

        location1 = userlocation;

        List<Location> placemarks1 = await locationFromAddress(location1);
        Location locationObj1 = placemarks1[0];

        List<Location> placemarks2 = await locationFromAddress(location2);
        Location locationObj2 = placemarks2[0];

        double distanceInMeters = await Geolocator.distanceBetween(
          locationObj1.latitude,
          locationObj1.longitude,
          locationObj2.latitude,
          locationObj2.longitude,
        );

        setState(() {
          this.distanceInMeters = distanceInMeters;
        });

        if (distanceInMeters != 0) {
          // Do something with the retrieved fields
          QuickAlert.show(
            context: context,
            title: "Servicer Information",
            text:
                "userName : $username\nservicername : $servicername\nservicertype : $sendReq\ncurrent userlocation : $location1\nncurrent servicerlocation : $location2\nThe distance between user and servicer : $distanceInMeters",
            type: QuickAlertType.info,
            confirmBtnText: "Done",
            confirmBtnTextStyle: TextStyle(
                color: Colors.pink,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'IndieFlower'),
            cancelBtnText: "Cancel",
            onCancelBtnTap: () async {
              // Handle cancel action
              try {
                await firebaseFirestore
                    .collection("register_user")
                    .doc(id)
                    .collection("accepteduserdetails")
                    .doc(accepteduserdetailsId)
                    .delete();

                QuickAlert.show(
                  context: context,
                  title: "Success",
                  text:
                      "The booking with id : $accepteduserdetailsId was deleted \nsuccessfully from the Accepted Document:)",
                  type: QuickAlertType.success,
                  confirmBtnText: "Done",
                );
              } catch (error) {
                print("Error deleting document: $error");
              }
            },
            cancelBtnTextStyle: TextStyle(
                color: Colors.pink,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'IndieFlower'),
          );
        } else {
          // Do something with the retrieved fields
          QuickAlert.show(
            context: context,
            title: "Servicer Information",
            text:
                "userName : $username\nservicername : $servicername\nservicertype : $sendReq\ncurrent userlocation : $location1\nncurrent servicerlocation : $location2\nThe $sendReq reached to your destination!!! :)",
            type: QuickAlertType.success,
            confirmBtnText: "Done",
            confirmBtnTextStyle: TextStyle(
                color: Colors.pink,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'IndieFlower'),
            onConfirmBtnTap: () async {
              // Handle cancel action
              try {
                await firebaseFirestore
                    .collection("register_user")
                    .doc(id)
                    .collection("accepteduserdetails")
                    .doc(accepteduserdetailsId)
                    .delete();

                QuickAlert.show(
                  context: context,
                  title: "Success",
                  text:
                      "The booking with id : $accepteduserdetailsId was deleted \nsuccessfully from the Accepted Document:) \nas the servicer reached to your destination",
                  type: QuickAlertType.success,
                  confirmBtnText: "Done",
                );
              } catch (error) {
                print("Error deleting document: $error");
              }
            },
          );
        }
      }
    }

    //Fluttertoast.showToast(msg: "Booking Request send Successfully :) ");

    /*Navigator.pushReplacement(context as BuildContext,
        MaterialPageRoute(builder: (context) => LoginScreen()));*/
    /*Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);*/
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                const Upside(
                  imgUrl: "assets/images/request.png",
                ),
                PageTitleBar(
                    title:
                        'Welcome $name\n here you will see servicer location details'),
                Padding(
                  padding: const EdgeInsets.only(top: 330.0, left: 15.0),
                  child: Container(
                    width: 380,
                    height: 500,
                    decoration: const BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          //iconButton(context),
                          const Text(
                            "press the button in order to see Servicer location",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'IndieFlower',
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                RoundedButton(
                                    text: 'Servicer Details',
                                    press: () async {
                                      postDetailsToFirestore();
                                    }),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
