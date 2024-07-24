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

class All_Driver_Req_Details_Page extends StatefulWidget {
  final String id;

  All_Driver_Req_Details_Page({super.key, required this.id});

  //const Farmer({super.key, required String id});

  @override
  // ignore: no_logic_in_create_state
  State<All_Driver_Req_Details_Page> createState() =>
      All_Driver_Req_Details_Page_State(id: id);
}

class All_Driver_Req_Details_Page_State extends State<All_Driver_Req_Details_Page> {
  String? id;
  var role;
  var email;
  var name;
  var phNo;
  var pass;
  UserRole loggedInUser = UserRole();

  All_Driver_Req_Details_Page_State({required this.id});

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
                    title: 'Welcome $name\nAll requested details by user!'),
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
                            "Here you can accept or reject the requests",
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
                                    text: 'Get all users request details',
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
    /*QuerySnapshot userDetailsSnapshot = await firebaseFirestore
        .collection("register_user")
        .doc(id)
        .collection("userdetails")
        .get();
    List<Map<String, dynamic>>? userDetailsList = userDetailsSnapshot.docs
        .map((doc) => doc.data())
        .cast<Map<String, dynamic>>()
        .toList();*/

    // Retrieve all documents from 'register_user' subcollection
    QuerySnapshot registerUserSnapshot =
        await firebaseFirestore.collection("register_user").get();
    List<Map<String, dynamic>>? registerUserList = registerUserSnapshot.docs
        .map((doc) => doc.data())
        .cast<Map<String, dynamic>>()
        .toList();

    if (registerUserList == Null || registerUserList.isEmpty) {
      QuickAlert.show(
        context: context,
        title: "Warning",
        text: "There are no Registered users till now",
        type: QuickAlertType.warning,
        confirmBtnText: "Done",
      );
    }

    // Access 'userdetails' subcollection from each document
    for (var registerUser in registerUserList) {
      String documentId = registerUser['uid'];
      String Role = registerUser['role'];
      String username = registerUser['name'];
      String userloc = registerUser['location'];

      if (Role == "user") {
        QuerySnapshot subCollectionSnapshot = await firebaseFirestore
            .collection("register_user")
            .doc(documentId)
            .collection("userSendDetailsAccDriWork")
            .get();
        List<Map<String, dynamic>>? subCollectionList = subCollectionSnapshot
            .docs
            .map((doc) => doc.data())
            .cast<Map<String, dynamic>>()
            .toList();

        if (subCollectionList == Null || subCollectionList.isEmpty) {
          QuickAlert.show(
            context: context,
            title: "Warning",
            text: "There are no bookings till now for the user $username\nwith id : $documentId",
            type: QuickAlertType.warning,
            confirmBtnText: "Done",
          );
        }

        // Access fields from each document
        for (var userDetails in subCollectionList) {
          String sendReq = userDetails['sendReq'];
          if (sendReq == "driver") {
            String userDetailsId = userDetails['id'];
            String bookusername = userDetails['name'];
            String userlocation = userDetails['location'];
            //String sendReq = userDetails['sendReq'];
            String vecType = userDetails['vecType'];
            String bookingStatus = userDetails['bookingStatus'];

            // Do something with the retrieved fields
            QuickAlert.show(
              context: context,
              title: "Booking ${i++}",
              text:
                  "Booking Id : $userDetailsId\nBookingStatus : $bookingStatus\nName : $bookusername\ntosendReq : $sendReq\nvechicleType : $vecType\nCurrent_location : $userlocation",
              type: QuickAlertType.confirm,
              confirmBtnText: "Accept",
              confirmBtnTextStyle: TextStyle(
                  color: Colors.pink,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'IndieFlower'),
              onConfirmBtnTap: () async {
                usersAcceptedDetails.servicername = name;
                usersAcceptedDetails.username = username;
                usersAcceptedDetails.usernameid = documentId;
                usersAcceptedDetails.servicernameid = id;
                usersAcceptedDetails.userlocation = userloc;
                usersAcceptedDetails.vecType = vecType;
                usersAcceptedDetails.sendReq = sendReq;
                usersAcceptedDetails.bookingStatus = "true";

                String userDetailsId = firebaseFirestore
                    .collection("register_user")
                    .doc(id)
                    .collection("accepteduserdetails")
                    .doc()
                    .id;
                usersAcceptedDetails.id = userDetailsId;
                await firebaseFirestore
                    .collection("register_user")
                    .doc(id)
                    .collection("accepteduserdetails")
                    .doc(userDetailsId)
                    .set(usersAcceptedDetails.toMap());
                QuickAlert.show(
                    context: context,
                    title: "Success",
                    text:
                        "Booking with id : $userDetailsId \nAccepted and added to database Successfully :)",
                    type: QuickAlertType.success,
                    confirmBtnText: "Done");
                Fluttertoast.showToast(
                    msg:
                        "Booking id : $userDetailsId \nAccepted and added to database Successfully :)");
                try {
                  await firebaseFirestore
                      .collection("register_user")
                      .doc(id)
                      .collection("userSendDetailsAccDriWork")
                      .doc(userDetailsId)
                      .delete();

                  QuickAlert.show(
                    context: context,
                    title: "Success",
                    text:
                    "The booking with id : $userDetailsId was deleted successfully from the userSendDetailsAccDriWork collection :)",
                    type: QuickAlertType.success,
                    confirmBtnText: "Done",
                  );
                } catch (error) {
                  print("Error deleting document: $error");
                }
              },
              cancelBtnText: "Reject",
              onCancelBtnTap: () async {
                // Handle cancel action
                try {
                  QuickAlert.show(
                    context: context,
                    title: "Success",
                    text:
                        "The booking with id : $userDetailsId was Rejected by $name successfully :)",
                    type: QuickAlertType.warning,
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
          }
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
}
