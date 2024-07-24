import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_flutter_mobile_app/Components/component.dart';
import 'package:new_flutter_mobile_app/Components/under_part.dart';
import 'package:new_flutter_mobile_app/Screens/Driver_home_Page.dart';
import 'package:new_flutter_mobile_app/Screens/user_home.dart';
import 'package:new_flutter_mobile_app/constants.dart';
import 'package:new_flutter_mobile_app/Screens/screen.dart';
import 'package:new_flutter_mobile_app/Screens/signup_screen.dart';
import 'package:new_flutter_mobile_app/Widgets/widget.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../UserModel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  //const LoginScreenState({Key? key}) : super(key: key);

  final _formkey = GlobalKey<FormState>();

  bool loading = false;

  // firebase
  final _auth = FirebaseAuth.instance;

  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

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
                  imgUrl: "assets/images/login.png",
                ),
                const PageTitleBar(title: 'Login'),
                Padding(
                  padding: const EdgeInsets.only(top: 320.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.blueGrey,
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
                          "or use your email account",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'IndieFlower',
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              RoundedInputField(
                                  labelText: "Email",
                                  hintText: "Email",
                                  icon: Icons.email,
                                  my_controller: _emailTextController,
                                  istrue_or_false: false,
                                  text_box_name: "email"),
                              RoundedPasswordField(
                                  newlabelText: "Password",
                                  newhintText: "Enter the Password",
                                  my_controller: _passwordTextController,
                                  istrue_or_false: true,
                                  text_box_name: "password"),
                              switchListTile(),
                              RoundedButton(
                                  text: 'LOGIN',
                                  press: () {
                                    setState(() {
                                      loading = true;
                                    });
                                    signIn(_emailTextController.text,
                                        _passwordTextController.text);
                                  }),
                              const SizedBox(
                                height: 10,
                              ),
                              UnderPart(
                                title: "Oops! you Don't have an account?",
                                navigatorText: "Register here",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpScreen()));
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Forgot password?',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontFamily: 'IndieFlower',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                              const SizedBox(
                                height: 20,
                              )
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

  // login function
  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      if (loading == true) {
        const CircularProgressIndicator();
      }
      User? user = FirebaseAuth.instance.currentUser;
      /*UserRole loggedInUser = UserRole();
      var user_role;
      var emaill;
      // ignore: prefer_typing_uninitialized_variables
      var id = "";
      @override
      void initState() {
        super.initState();
        FirebaseFirestore.instance
            .collection("register_user") //.where('uid', isEqualTo: user!.uid)
            .doc(user!.uid)
            .get()
            .then((value) {
          loggedInUser = UserRole.fromMap(value.data());
        }).whenComplete(() {
          const CircularProgressIndicator();
          setState(() {
            emaill = loggedInUser!.email!.toString();
            //print("$emaill");
            user_role = loggedInUser!.role!.toString();
            id = loggedInUser!.uid!.toString();
          });
        });
      }*/
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text,
        );

        String uid = userCredential.user?.uid ?? 'uid';

        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('register_user').doc(uid).get();
        QuickAlert.show(
            context: context,
            title: "information",
            text:
            "Login was Successfull",
            type: QuickAlertType.success,
            confirmBtnText: "Done");
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String user_role = userData['role'];
        String user_name = userData['name'];
        QuickAlert.show(
            context: context,
            title: "information",
            text:
            "Login was Successfull",
            type: QuickAlertType.success,
            confirmBtnText: "Done");
        Fluttertoast.showToast(msg: "Login Successful $user_name");

        if (user_role == "user") {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => User_Home_Page(id: uid)));
        } else if (user_role == "worker" || user_role == "driver") {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Driver_Home_Page(id: uid)));
        }
        /*await _auth
            .signInWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful $emaill"),
                  //if ( user_role == "user" ) {
                  Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => User_Home_Page(id: user!.uid))),
                 /*} else if ( user_role == "worker" || user_role == "driver" ) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignUpScreen())),
                  }*/
                });*/
      } on FirebaseAuthException catch (error) {
        var errorMessage;
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}

switchListTile() {
  return Padding(
    padding: const EdgeInsets.only(left: 50, right: 40),
    child: SwitchListTile(
      dense: true,
      title: const Text(
        'Remember Me',
        style: TextStyle(fontSize: 16, fontFamily: 'IndieFlower'),
      ),
      value: true,
      activeColor: kPrimaryColor,
      onChanged: (val) {},
    ),
  );
}

iconButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      RoundedIcon(imageUrl: "assets/images/google.png"),
      SizedBox(
        width: 20,
      ),
      RoundedIcon(imageUrl: "assets/images/insta.png"),
      SizedBox(
        width: 20,
      ),
      RoundedIcon(imageUrl: "assets/images/facebook.png"),
    ],
  );
}
