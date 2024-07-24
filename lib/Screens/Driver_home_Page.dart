import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter_mobile_app/Components/component.dart';
import 'package:new_flutter_mobile_app/Components/under_part.dart';
import 'package:new_flutter_mobile_app/Screens/To_find_location.dart';
import 'package:new_flutter_mobile_app/UserModel.dart';
import 'package:new_flutter_mobile_app/Widgets/conform_rounded_password_field.dart';
import 'package:new_flutter_mobile_app/constants.dart';
import 'package:new_flutter_mobile_app/Screens/screen.dart';
import 'package:new_flutter_mobile_app/Widgets/widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
//import 'package:cloud_firestore/src/collection_reference.dart';

class Driver_Home_Page extends StatefulWidget {
  final String id;

  Driver_Home_Page({super.key, required this.id});

  //const Farmer({super.key, required String id});

  @override
  // ignore: no_logic_in_create_state
  State<Driver_Home_Page> createState() => Driver_Home_Page_State(id: id);
}

class Driver_Home_Page_State extends State<Driver_Home_Page> {
  String? id;
  var role;
  var email;
  var name;
  var phNo;
  UserRole loggedInUser = UserRole();

  Driver_Home_Page_State({required this.id});

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
        });
        QuickAlert.show(
            context: context,
            title: "Success",
            text: "$name Logged in Successfully",
            type: QuickAlertType.success,
            confirmBtnText: "Done");
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
    'All Requests',
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
    const Icon(Icons.request_quote_sharp, color: Colors.white, size: 45),
    const Icon(Icons.request_page_outlined, color: Colors.white, size: 45),
    //const Icon(Icons.cabin, color: Colors.white, size:25),
    //const Icon(Icons.cabin, color: Colors.white, size:25),
  ];

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
                  imgUrl: "assets/images/user.png",
                ),
                PageTitleBar(title: 'Welcome $name!'),
                Padding(
                  padding: const EdgeInsets.only(top: 320.0, left: 15.0),
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
                            "These are the options for you",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'IndieFlower',
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          GridView.builder(
                            itemCount: optionIcons.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.4,
                              mainAxisSpacing: 2,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (index == 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Driver_Home_Page(id: widget.id),
                                      ),
                                    );
                                  } else if (index == 1) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            User_Location_Page(id: widget.id),
                                      ),
                                    );
                                  } else if (index == 2) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            All_Driver_Req_Details_Page(id: widget.id),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            All_Driver_Acc_Req_Details_Page(id: widget.id),
                                      ),
                                    );
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: optinColors[index],
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Center(child: optionIcons[index]),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      options[index],
                                      style: const TextStyle(
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          fontFamily: 'IndieFlower'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                RoundedButton(
                                    text: 'LogOut',
                                    press: () {
                                      logout(context);
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

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
}
