import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jaziadigitalid/DigitalId/Functions/firebasefunc.dart';
import 'package:jaziadigitalid/DigitalId/Widgets/bodyWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridWidget extends StatefulWidget {
  const GridWidget({Key? key, required this.tap}) : super(key: key);

  final Function tap;
  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  SharedPreferences? pref;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('DigitalIdentity')
            .doc("ChiefId")
            .collection("Vouched")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) =>
            snapshot.hasData
                ? ListView(
                    children: snapshot.data!.docs
                        .map((doc) => BodyWidget(
                              pName: doc['fname'],
                              pfather: doc['fathername'],
                              pmother: doc['mothername'],
                              pgrandfather: doc['grandfathername'],
                              pgrandmother: doc['grandmothername'],
                              plastname: doc['lname'],
                              pUrl: doc['personpics'][0],
                              pVillage: doc['village'],
                            ))
                        .toList())
                : const CupertinoActivityIndicator());
  }
}
