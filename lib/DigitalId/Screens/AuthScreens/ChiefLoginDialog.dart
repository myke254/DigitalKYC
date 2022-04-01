import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jaziadigitalid/DigitalId/Functions/firebasefunc.dart';
import 'package:jaziadigitalid/DigitalId/Screens/ChiefScreen/MainScreenChief.dart';

TextStyle _style = GoogleFonts.varelaRound();

class ChiefLoginDialog extends StatefulWidget {
  ChiefLoginDialog({
    Key? key,
  }) : super(key: key);

  @override
  _ChiefLoginDialogState createState() => _ChiefLoginDialogState();
}

class _ChiefLoginDialogState extends State<ChiefLoginDialog> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController controlleruserid = TextEditingController();
  TextEditingController controllerpassword = TextEditingController();

  int? dropdownvalue = 1;

  ///UPLOAD THE ITEM TO DB
  ///

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CupertinoAlertDialog(
      title: const Text('Login as Chief?'),
      content: Material(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  controller: controlleruserid,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Chief uid is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).brightness == Brightness.light
                        ? Colors.blue.withOpacity(.1)
                        : Colors.red.withOpacity(.1),
                    filled: true,
                    labelText: 'Enter Unique Chief ID',
                    labelStyle: _style.copyWith(fontSize: 12),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Enter Password'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: controllerpassword,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'User Password is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).brightness == Brightness.light
                        ? Colors.blue.withOpacity(.1)
                        : Colors.red.withOpacity(.1),
                    filled: true,
                    labelText: 'Enter Password Chief',
                    labelStyle: _style.copyWith(fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              //!this shoould validate the user
              await FirebaseFunc().validateChiefid(
                      controlleruserid.value.text.trim().toString())
                  ? await FirebaseFunc().validateChiefPassword(
                          controlleruserid.value.text.trim().toString(),
                          controllerpassword.value.text.trim().toString())
                      ? perfomValidation()
                      : Fluttertoast.showToast(
                          msg: "Please Enter Correct Password")
                  : Fluttertoast.showToast(msg: "Please Enter Correct User ID");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('Proceed'),
                Icon(CupertinoIcons.arrow_right),
              ],
            )),
      ],
    );
  }

  perfomValidation() async {
    Navigator.pop(context);
    MaterialPageRoute route =
        MaterialPageRoute(builder: ((context) => MainScreenChief()));
    Navigator.pushReplacement(context, route);
  }
}
