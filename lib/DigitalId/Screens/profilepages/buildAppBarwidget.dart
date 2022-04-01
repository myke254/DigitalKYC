import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context,String title) {
  final icon = CupertinoIcons.moon_stars;

  return AppBar(
    backgroundColor: Colors.black26,
    elevation: 0,
    title: Text(title),
  );
}
