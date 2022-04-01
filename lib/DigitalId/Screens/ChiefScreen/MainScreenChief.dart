import 'package:flutter/material.dart';
import 'package:jaziadigitalid/DigitalId/Screens/ChiefScreen/GridViewList.dart';
import 'package:jaziadigitalid/DigitalId/Screens/ChiefScreen/chiefDrawer.dart';

class MainScreenChief extends StatefulWidget {
  MainScreenChief({Key? key}) : super(key: key);

  @override
  State<MainScreenChief> createState() => _MainScreenChiefState();
}

class _MainScreenChiefState extends State<MainScreenChief> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text("Chief Main Page"),
      ),
      drawer: const ChiefDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: GridWidget(tap: () {}),
      ),
    );
  }
}
