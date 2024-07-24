import 'package:flutter/material.dart';
import 'package:new_flutter_mobile_app/constants.dart';
import 'package:new_flutter_mobile_app/Widgets/widget.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? text_box_name;
  final IconData icon;
  final TextEditingController my_controller;
  final bool istrue_or_false;

  const RoundedInputField(
      {Key? key,
      this.hintText,
      this.labelText,
      this.icon = Icons.person,
      required this.my_controller,
      required this.istrue_or_false,
      this.text_box_name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: (validate_msg) {
          if (text_box_name == "name") {
            RegExp nameregex = new RegExp(r'^.{3,}$');
            if (validate_msg!.isEmpty) {
              return ("*Name cannot be Empty");
            }
            if (!nameregex.hasMatch(validate_msg)) {
              return ("*Enter Valid name(Min. 3 Character)");
            } else {
              return null;
            }
          } else if (text_box_name == "email") {
            if (validate_msg!.isEmpty) {
              return ("*Please Enter Your Email, it can not be empty");
            }
            // reg expression for email validation
            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                .hasMatch(validate_msg)) {
              return ("*Please Enter a valid email");
            } else {
              return null;
            }
          } else if (text_box_name == "mobilenumber") {
            RegExp regex = new RegExp(r'^\d{10}$');
            if (validate_msg!.isEmpty) {
              return "*PhoneNo cannot be empty";
            }
            if (!regex.hasMatch(validate_msg)) {
              return ("*Please enter a valid phone number");
            } else {
              return null;
            }
          } else if (text_box_name == "role") {
            if (validate_msg!.isEmpty) {
              return "*Role cannot be empty";
            }
            if (validate_msg != "user" &&
                validate_msg != "driver" &&
                validate_msg != "worker") {
              return ("*Please enter a valid role either user or driver or worker");
            } else {
              return null;
            }
          } else if (text_box_name == "TosendReqest") {
            if (validate_msg!.isEmpty) {
              return "*TosendReqest cannot be empty";
            }
            if (validate_msg != "driver" && validate_msg != "worker") {
              return ("*Please enter a valid role either driver or worker");
            } else {
              return null;
            }
          } else if (text_box_name == "vec_type") {
            if (validate_msg!.isEmpty) {
              return "*Vechile Type cannot be empty";
            }
            if (validate_msg != "bike" &&
                validate_msg != "car" &&
                validate_msg != "truck" &&
                validate_msg != "auto") {
              return ("*Please enter a valid Vechile Type bike or car or truck or auto");
            } else {
              return null;
            }
          } else if (text_box_name == "CurLocation") {
            if (validate_msg!.isEmpty) {
              return "*CurrentLocation cannot be empty";
            } else {
              return null;
            }
          }
        },
        cursorColor: kPrimaryColor,
        controller: my_controller,
        obscureText: istrue_or_false,
        enableSuggestions: !istrue_or_false,
        autocorrect: !istrue_or_false,
        style: TextStyle(
            color: Colors.pink, fontSize: 15, fontFamily: 'IndieFlower'),
        decoration: InputDecoration(
            errorStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'IndieFlower'),
            icon: Icon(
              icon,
              color: kPrimaryColor,
            ),
            fillColor: Colors.white.withOpacity(0.3),
            labelText: labelText,
            labelStyle: const TextStyle(fontFamily: 'IndieFlower'),
            hintText: hintText,
            hintMaxLines: 2,
            hintStyle: const TextStyle(fontFamily: 'IndieFlower'),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: InputBorder.none),
        //if( text_box_name == "mobilenumber")
        //{ keyboardType: TextInputType.emailAddress}
        keyboardType: istrue_or_false
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        onChanged: (value) {},
      ),
    );
  }
}
