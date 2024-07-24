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
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'To_find_location.dart';

class UserReqDetailsScreen extends StatefulWidget {
  final String id;

  const UserReqDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<UserReqDetailsScreen> createState() => NewUserReqDetailsScreen(id: id);
}

final _auth = FirebaseAuth.instance;
// our form key
final _formKey = GlobalKey<FormState>();
// editing Controller

class NewUserReqDetailsScreen extends State<UserReqDetailsScreen> {
  String? id;
  var role;
  var email;
  var name;
  var phNo;
  var pass;
  var cur_loc;
  UserRole loggedInUser = UserRole();
  var locationEditingController;
  var NameEditingController;

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
          cur_loc = loggedInUser.location?.toString() ?? false;
          Fluttertoast.showToast(msg: "$cur_loc");
          print(cur_loc);
          locationEditingController = TextEditingController(text: '$cur_loc');
          NameEditingController = TextEditingController(text: '$name');
        });
      });
    } else {
      print("USER NOT FOUND!!!!!!!!!!!!!!");
    }
  }

  //const NewSignUpScreen({Key? key}) : super(key: key);
  //String? errorMessage;

  NewUserReqDetailsScreen({required this.id});

  User_Location_Page_State? user_loc;

  /*@override
  void initState() {
    super.initState();
    user_loc = User_Location_Page_State(id: id!);
    cur_loc = user_loc?.loc_name;
    Fluttertoast.showToast(msg: "$cur_loc");
    print(cur_loc);
    locationEditingController = TextEditingController(text: '$cur_loc');
  }*/

  final tosendReqRoleEditingController = new TextEditingController();
  final vecTypeEditingController = new TextEditingController();

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
                const PageTitleBar(title: 'Make Booking'),
                Padding(
                  padding: const EdgeInsets.only(top: 320.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        iconButton(context),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Fill the details below",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'IndieFlower',
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              RoundedInputField(
                                  labelText: "TosendReqest",
                                  hintText:
                                      "Enter the name as either driver or worker",
                                  icon: Icons.person_add_alt_outlined,
                                  my_controller: tosendReqRoleEditingController,
                                  istrue_or_false: false,
                                  text_box_name: "TosendReqest"),
                              RoundedInputField(
                                  labelText: "Name",
                                  hintText: "Enter your Name",
                                  icon: Icons.person,
                                  my_controller: NameEditingController,
                                  istrue_or_false: false,
                                  text_box_name: "name"),
                              RoundedInputField(
                                  labelText: "VechileType",
                                  hintText:
                                      "Enter your Vechile Type either bike or car or truck or auto",
                                  icon: Icons.car_repair_sharp,
                                  my_controller: vecTypeEditingController,
                                  istrue_or_false: false,
                                  text_box_name: "vec_type"),
                              RoundedInputField(
                                  labelText: "CurrentLocation",
                                  hintText: "Enter your current location",
                                  icon: Icons.location_on_outlined,
                                  my_controller: locationEditingController,
                                  istrue_or_false: false,
                                  text_box_name: "CurLocation"),
                              const SizedBox(
                                height: 10,
                              ),
                              RoundedButton(
                                  text: 'Book',
                                  press: () {
                                    if (_formKey.currentState!.validate()) {
                                      postDetailsToFirestore(
                                          NameEditingController.text,
                                          tosendReqRoleEditingController.text,
                                          locationEditingController.text,
                                          vecTypeEditingController.text);
                                    }
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  postDetailsToFirestore(
      String name, String sendReq, String location, String vecType) async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserRole userrole = UserRole();
    UserSendDetails userSendDetails = UserSendDetails();
    UserSendDetailsAccDriWork userSendDetailsAccDriWork = UserSendDetailsAccDriWork();

    // writing all the values
    /* userrole.email = user!.email;
    userrole.uid = user?.uid;*/
    /*userrole.role = role;
    userrole.name = name;
    userrole.phNo = mobile;
    userrole.pass = password;*/
    userSendDetails.name = name;
    userSendDetails.location = location;
    userSendDetails.vecType = vecType;
    userSendDetails.sendReq = sendReq;
    userSendDetails.bookingStatus = "false";

    userSendDetailsAccDriWork.name = name;
    userSendDetailsAccDriWork.location = location;
    userSendDetailsAccDriWork.vecType = vecType;
    userSendDetailsAccDriWork.sendReq = sendReq;
    userSendDetailsAccDriWork.bookingStatus = "false";

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
        .set(userSendDetails.toMap());
    QuickAlert.show(
        context: context,
        title: "Success",
        text: "Booking Request send Successfully :)",
        type: QuickAlertType.success,
        confirmBtnText: "Done");
    Fluttertoast.showToast(msg: "Booking Request send Successfully :) ");

    String userSendDetailsAccDriWorkId = firebaseFirestore
        .collection("register_user")
        .doc(id)
        .collection("userSendDetailsAccDriWork")
        .doc()
        .id;
    userSendDetailsAccDriWork.id = userSendDetailsAccDriWorkId;
    await firebaseFirestore
        .collection("register_user")
        .doc(id)
        .collection("userSendDetailsAccDriWork")
        .doc(userSendDetailsAccDriWorkId)
        .set(userSendDetails.toMap());
    QuickAlert.show(
        context: context,
        title: "Success",
        text: "Booking Request send Successfully to the another colloection :)",
        type: QuickAlertType.success,
        confirmBtnText: "Done");
    Fluttertoast.showToast(msg: "Booking Request send Successfully to the another colloection :)");

    /*Navigator.pushReplacement(context as BuildContext,
        MaterialPageRoute(builder: (context) => LoginScreen()));*/
    /*Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);*/
  }
}
