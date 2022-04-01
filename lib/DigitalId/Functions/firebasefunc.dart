import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

String chiefUserId = "ChiefId";
late SharedPreferences preferences;

class FirebaseFunc {
  List<String> downloadedUrls = [];
  FirebaseAuth _auth = FirebaseAuth.instance;

  String uniqueid = DateTime.now().millisecondsSinceEpoch.toString();
  Future<void> savePersonDetails(
      String fname,
      String lname,
      String work,
      DateTime dob,
      String fathername,
      String mothername,
      String grandfathername,
      String grandmothername,
      String location,
      String sublocation,
      String village,
      String vouchertype,
      String voucherid,
      List<String> personpicsurls) async {
    try {
      FirebaseFirestore.instance
          .collection("DigitalIdentity")
          .doc(chiefUserId)
          .collection("Vouched")
          .doc(_auth.currentUser!.uid)
          .set({
        "uid": _auth.currentUser!.uid,
        "fname": fname,
        "lname": lname,
        "work": work,
        "dob": dob,
        "fathername": fathername,
        "mothername": mothername,
        "grandfathername": grandfathername,
        "grandmothername": grandmothername,
        "location": location,
        "sublocation": sublocation,
        "village": village,
        "vouchertype": vouchertype,
        "voucherid": voucherid,
        "DigitalIdentity": uniqueid,
        "personpics": FieldValue.arrayUnion(personpicsurls),
      });
    } catch (ex) {
      // setState(() {
      //   isloading = false;
      // });
    }
  }

  Future<void> cachePersonDetail(
    String fname,
    String lname,
    String work,
    DateTime dob,
    String fathername,
    String mothername,
    String grandfathername,
    String grandmothername,
    String location,
    String sublocation,
    String village,
    String vouchertype,
    String voucherid,
    //List<String> personpicsurls
  ) async {
    try {
      preferences = await SharedPreferences.getInstance();
      preferences.setBool("waiting", true);
      //   preferences.setString(jsonEncode("object"));

      preferences.setString("uid", _auth.currentUser!.uid);
      preferences.setString("fname", fname);
      preferences.setString("lname", lname);
      preferences.setString("work", work);
      preferences.setString("dob", dob.toString());
      preferences.setString("fathername", fathername);
      preferences.setString("mothername", mothername);
      preferences.setString("grandfathername", grandfathername);
      preferences.setString("grandmothername", grandmothername);
      preferences.setString("location", location);
      preferences.setString("sublocation", sublocation);
      preferences.setString("village", village);
      preferences.setString("vouchertype", vouchertype);
      preferences.setString("voucherid", voucherid);
      preferences.setString("DigitalIdentity", uniqueid
          // preferences.setStringList( "personpics", );
          );
    } catch (ex) {
      // setState(() {
      //   isloading = false;
      // });
    }
  }

//saving the profiles
  Future uploadAllImages(images) async {
    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        downloadedUrls.add(await _uploadandSaveimage(images[i]));
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please select atleast one image to continue");
    }
    return downloadedUrls;
  }

  Future<String> _uploadandSaveimage(mFileImage) async {
    // requestpermissions();
    String downloadurlvalue = "";
    if (mFileImage != null) {
      String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

      final Reference storagereference =
          FirebaseStorage.instance.ref().child("profiles");
      // print(mFileImage['originalPath'].toString());

      UploadTask uploadTask = storagereference
          .child("image_$imageFileName.jpg")
          .putFile(File(mFileImage.modifiedPath.toString()));

      downloadurlvalue = await (await uploadTask).ref.getDownloadURL();
    }
    return downloadurlvalue;
  }

  Future<bool> validateChiefPassword(String chiefid, String password) async {
    bool isvalid = false;
    try {
      await FirebaseFirestore.instance
          .collection('chief')
          .doc(chiefid)
          .get()
          .then((value) {
        var pass = value['passw'];

        if (password == pass) {
          isvalid = true;
        }
      });
    } catch (e) {}
    return isvalid;
  }

  Future<bool> validateChiefid(String chiefid) async {
    bool documentexists = false;

    try {
      var collinfo = await FirebaseFirestore.instance
          .collection('chief')
          .doc(chiefid)
          .get();
      if (collinfo != null) {
        documentexists = true;
      }
    } catch (e) {
      print("Document Doesn't exist");
    }

    return documentexists;
  }

  Future readData(String uid) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((datasnapshot) async {
      // await DigitalIdentity.preferences!.setString(DigitalIdentity.userphone,
      //     datasnapshot.data()![DigitalIdentity.userphone]);
      // await DigitalIdentity.preferences!.setString(DigitalIdentity.userUID,
      //     datasnapshot.data()![DigitalIdentity.userUID]);
      // await DigitalIdentity.preferences!.setString(DigitalIdentity.userEmail,
      //     datasnapshot.data()![DigitalIdentity.userEmail]);
      // await DigitalIdentity.preferences!.setString(DigitalIdentity.userName,
      //     datasnapshot.data()![DigitalIdentity.userName]);

      // List<String> images = await datasnapshot
      //     .data()![DigitalIdentity.usercartList]
      //     .cast<String>();
      // await datasnapshot.data()![DigitalIdentity.usercartList] != null
      //     ? await DigitalIdentity.preferences!
      //         .setStringList(DigitalIdentity.usercartList, cartList)
      //     : await DigitalIdentity.preferences!
      //         .setStringList(DigitalIdentity.usercartList, []);
    });
  }
}
