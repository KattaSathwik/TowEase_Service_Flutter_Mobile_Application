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

class Driver_Worker_Location_Page extends StatefulWidget {
  final String id;

  Driver_Worker_Location_Page({super.key, required this.id});

  //const Farmer({super.key, required String id});

  @override
  // ignore: no_logic_in_create_state
  State<Driver_Worker_Location_Page> createState() => _Driver_Worker_Location_Page_State(id: id);
}

class _Driver_Worker_Location_Page_State extends State<Driver_Worker_Location_Page> {
  String? id;
  var role;
  var email;
  var name;
  var phNo;
  UserRole loggedInUser = UserRole();

  _Driver_Worker_Location_Page_State({required this.id});

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

  String location = '';
  String Address = '';

  void showAlert(QuickAlertType quickAlertType) {
    QuickAlert.show(
        context: context,
        title: "information",
        text:
        "These are the options for you\n\nLocation : ${location}\n\nAddress : ${Address}",
        type: QuickAlertType.info,
        confirmBtnText: "Done");
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    //Position position;
    // Location location = Location(latitude: position.latitude, longitude: longitude, timestamp: timestamp);
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    //location.changeSettings(interval: 1000, accuracy: LocationAccuracy.high);
    //return await location.getLocation();

    return await Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.high, intervalDuration: Duration(seconds: 10))
        .first;
    //return await Geolocator.getCurrentPosition(
    //    desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address =
    '\nName : ${place.name}\n   Street : ${place.street}\n   AdministrativeArea : ${place.administrativeArea}\n   SubLocality : ${place.subLocality}\n   Locality : ${place.locality}\n   PostalCode : ${place.postalCode}\n   Country : ${place.country}\n';
    setState(() {});
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
                            "In order to find the current location",
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
                                    text: 'Get Current location',
                                    press: () async {
                                      Position position =
                                      await _getGeoLocationPosition();
                                      location =
                                      '\n\n   Lattitude : ${position.latitude}\n   Longitude: ${position.longitude}';
                                      GetAddressFromLatLong(position);
                                      showAlert(QuickAlertType.info);
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