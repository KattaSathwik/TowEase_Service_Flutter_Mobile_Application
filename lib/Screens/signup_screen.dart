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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => NewSignUpScreen();
}

final _auth = FirebaseAuth.instance;
// our form key
final _formKey = GlobalKey<FormState>();
// editing Controller
final RoleEditingController = new TextEditingController();
final NameEditingController = new TextEditingController();
final MobileEditingController = new TextEditingController();
final emailEditingController = new TextEditingController();
final passwordEditingController = new TextEditingController();
final confirmPasswordEditingController = new TextEditingController();

class NewSignUpScreen extends State<SignUpScreen> {
  //const NewSignUpScreen({Key? key}) : super(key: key);
  //String? errorMessage;

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
                  imgUrl: "assets/images/register.png",
                ),
                const PageTitleBar(title: 'Create New Account'),
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
                          "or use your email account",
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
                                  labelText: "Email",
                                  hintText: "Enter Email id",
                                  icon: Icons.email,
                                  my_controller: emailEditingController,
                                  istrue_or_false: false,
                                  text_box_name: "email"),
                              RoundedInputField(
                                  labelText: "Name",
                                  hintText: "Enter your Name",
                                  icon: Icons.person,
                                  my_controller: NameEditingController,
                                  istrue_or_false: false,
                                  text_box_name: "name"),
                              RoundedInputField(
                                  labelText: "Role",
                                  hintText:
                                      "Enter your Role as user, driver or worker",
                                  icon: Icons.person_add_alt_1_sharp,
                                  my_controller: RoleEditingController,
                                  istrue_or_false: false,
                                  text_box_name: "role"),
                              RoundedInputField(
                                  labelText: "Mobile number",
                                  hintText: "Enter your mobile number",
                                  icon: Icons.phone_android_outlined,
                                  my_controller: MobileEditingController,
                                  istrue_or_false: false,
                                  text_box_name: "mobilenumber"),
                              RoundedPasswordField(
                                  newlabelText: "Password",
                                  newhintText: "Enter the Password",
                                  my_controller: passwordEditingController,
                                  istrue_or_false: true,
                                  text_box_name: "password"),
                              ConformRoundedPasswordField(
                                  newlabelText: "Conform Password",
                                  newhintText: "Enter the Conform Password",
                                  pre_pass_my_controller:
                                      passwordEditingController,
                                  my_controller:
                                      confirmPasswordEditingController,
                                  istrue_or_false: true,
                                  text_box_name: "conformpassword"),
                              RoundedButton(
                                  text: 'REGISTER',
                                  press: () {
                                    signUp(
                                        emailEditingController.text,
                                        passwordEditingController.text,
                                        RoleEditingController.text,
                                        NameEditingController.text,
                                        MobileEditingController.text);
                                  }),
                              const SizedBox(
                                height: 10,
                              ),
                              UnderPart(
                                title: "Already have an account?",
                                navigatorText: "Login here",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()));
                                },
                              ),
                              const SizedBox(
                                height: 20,
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

  void signUp(String email, String password, String role, String name,
      String mobile) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) =>
                {postDetailsToFirestore(email, password, role, name, mobile), QuickAlert.show(
        context: context,
        title: "information",
        text:
        "Account was Created Successfully",
        type: QuickAlertType.success,
        confirmBtnText: "Done")})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
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

  postDetailsToFirestore(String email, String password, String role,
      String name, String mobile) async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserRole userrole = UserRole();

    // writing all the values
    userrole.email = user!.email;
    userrole.uid = user.uid;
    userrole.role = role;
    userrole.name = name;
    userrole.phNo = mobile;
    userrole.pass = password;

    await firebaseFirestore
        .collection("register_user")
        .doc(user.uid)
        .set(userrole.toMap());
    QuickAlert.show(
        context: context,
        title: "information",
        text:
        "Account was Created Successfully",
        type: QuickAlertType.success,
        confirmBtnText: "Done");
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushReplacement(context as BuildContext,
        MaterialPageRoute(builder: (context) => LoginScreen()));
    /*Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);*/
  }
}
