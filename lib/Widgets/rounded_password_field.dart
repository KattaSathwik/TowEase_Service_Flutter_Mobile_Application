import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_flutter_mobile_app/constants.dart';
import 'package:new_flutter_mobile_app/Widgets/widget.dart';
import 'package:flutter/src/material/input_decorator.dart';

class RoundedPasswordField extends StatelessWidget {
   const RoundedPasswordField(
      {Key? key,
      this.newhintText,
      this.newlabelText,
      required this.my_controller,
      required this.istrue_or_false,
      this.text_box_name})
      : super(key: key);
  final String? newhintText;
  final String? newlabelText;
  final String? text_box_name;
  final TextEditingController my_controller;
  final bool istrue_or_false;
  //bool new_istrue_or_false = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: (validate_msg) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (validate_msg!.isEmpty) {
            return ("*Password is required");
          }
          if (!regex.hasMatch(validate_msg)) {
            return ("*Enter Valid Password(Min. 6 Character)");
          } else {
            return null;
          }
        },
        cursorColor: kPrimaryColor,
        controller: my_controller,
        obscureText: istrue_or_false,
        enableSuggestions: !istrue_or_false,
        autocorrect: !istrue_or_false,
        style: TextStyle(
            color: Colors.pink,
            fontSize: 20,
            fontFamily: 'IndieFlower'),
        //obscureText: true,
        //cursorColor: kPrimaryColor,
        decoration: const InputDecoration(
            errorStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'IndieFlower'),
            icon: Icon(
              Icons.lock,
              color: kPrimaryColor,
            ),
            fillColor: Colors.white60,
            labelText: "Password",
            labelStyle: TextStyle(fontFamily: 'IndieFlower'),
            hintText: "Enter the Password",
            hintStyle: TextStyle(fontFamily: 'IndieFlower'),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            suffixIcon: Icon(
              Icons.visibility,
              color: kPrimaryColor,
            ),
            border: InputBorder.none),
        keyboardType: istrue_or_false
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        onChanged: (value) {
         /* InkWell(
            onTap: () {
              istrue_or_false = !istrue_or_false;
            },
          );*/
        },
      ),
    );
  }
}
