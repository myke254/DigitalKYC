import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jaziadigitalid/DigitalId/Screens/AuthScreens/authserviceupdated.dart';
import 'package:jaziadigitalid/DigitalId/Screens/AuthScreens/ChiefLoginDialog.dart';
import 'package:jaziadigitalid/DigitalId/Screens/AuthScreens/loginwithGoogle.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  FirebaseAuth? auth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width / 1.2,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Card(
                        elevation: 20,
                        color: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.network(
                                    auth!.currentUser!.photoURL!)),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, bottom: 8),
                            child: Wrap(
                              children: [
                                Text(
                                  auth!.currentUser!.email!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            "",
                            //  auth!.currentUser!.phoneNumber!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.wb_sunny),
                                  onPressed: () {})
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(auth!.currentUser!.displayName!),
                leading: const Icon(Icons.person),
                onTap: () {
                  // Navigator.pushNamed(context, '/sixth');
                },
                trailing: const Icon(Icons.edit),
              ),

              ListTile(
                title: const Text('Login as Chief  ?'),
                leading: const Icon(Icons.badge),
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ChiefLoginDialog();
                      });
                  //recordShelves();
                  //   await _resetShelvesDialog();
                },
              ),
              ListTile(
                title: const Text('Switch Account'),
                leading: const Icon(Icons.swap_horizontal_circle_outlined),
                onTap: () {
                  /* change to another cafeteria / verify access first*/
                },
              ),
              ListTile(
                title: const Text('Contact US'),
                leading: const Icon(Icons.headset_mic),
                onTap: () async {
                  Navigator.of(context).pop();
                  //  await launch('tel:0722494071');
                },
              ),
              //ListTile(title: Text('Edit Profile'),onTap: (){Navigator.pushNamed(context, '/sixth');},leading: Icon(Icons.edit),),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Card(
                      elevation: 0,
                      child: ListTile(
                        title: const Text('SignOut'),
                        onTap: () async {
                          await AuthServiceUpdated().signOut();
                          Route route =
                              MaterialPageRoute(builder: (context) => Login());
                          Navigator.pushReplacement(context, route);
                        },
                        leading: const Icon(Icons.link_off),
                        enableFeedback: true,
                      ))),
            ],
          ),
        ));
  }
}
