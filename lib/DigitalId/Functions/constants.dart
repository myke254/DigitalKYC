import 'dart:core';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../keys/keys.dart';

class DigitalId {
  static const String appName = "e_id";
  static SharedPreferences? preferences;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static String collectionUser = "users";
  static String collectionOrders = "orders";
  static String usercartList = "usercart";
  static String subcollectionAddress = "useraddress";
  static String userphone = "phone";
  static String isuser = "isuser";

  static const String userName = "name";
  static const String userEmail = "email";
  static const String userUID = "uid";
  static const String userPhotoUrl = "photourl";
  static const String userAvatarurl = "url";

  static const String addressId = "addressId";

  static String currentuserPhotUrl = "";

  static String twilioSID = twilioSIDD;
  static String twilioPhoneNumber = twilioPhoneNumberr;
  static String twilioauthtoken = twilioauthtokenn;
}

int randomNumber = 0;

late TwilioFlutter twilioFlutter;

///this function sends a twilio message
Future SendTwilioMessage(String phone, String body) async {
  //randomNumber = getRandomNumber();
  twilioFlutter = TwilioFlutter(
      accountSid: DigitalId.twilioSID,
      authToken: DigitalId.twilioauthtoken,
      twilioNumber: DigitalId.twilioPhoneNumber);
  try {
    await twilioFlutter.sendSMS(toNumber: phone, messageBody: body);
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
  }
}

///this function returns a random number
int getRandomNumber() {
  int random = 0;
  var rng = Random();
  var code = rng.nextInt(900000) + 100000;
  random = int.parse(code.toString());
  randomNumber = random;
  return randomNumber;
}

///validate the code
bool validatecode(String value) {
  bool isvalid = false;
  try {
    if (int.parse(value) == randomNumber) {
      isvalid = true;
    }
  } catch (e) {}
  return isvalid;
}

String? geterror(String? controller) {
  final text = controller!.toString();
  if (text.isEmpty) {
    return "Field cannot be empty";
  }

  return null;
}

class Utils {
  static void ShowSnackBar(BuildContext context, String message, Color color) =>
      showSimpleNotification(
          const Text(
            "Internet Connection Update",
            style: TextStyle(fontSize: 13),
          ),
          duration: const Duration(seconds: 10),
          subtitle: Text(
            message,
            style: const TextStyle(fontSize: 11),
          ),
          background: color);
}
