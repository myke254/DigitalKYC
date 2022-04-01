import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaziadigitalid/DigitalId/Screens/AuthScreens/authservice.dart';
import 'package:jaziadigitalid/DigitalId/Screens/AuthScreens/authserviceupdated.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isloading = false;
  }

  @override
  Widget build(BuildContext context) {
    //test feild state
    String email = "";
    String password = "";
    //for showing loading

    // this below line is used to make notification bar transparent
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            //TODO update this
            'assets/icon/logo.jpeg',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  Colors.black.withOpacity(.9),
                  Colors.black.withOpacity(.3),
                ])),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 60.0),
                  child: Image.asset(
                    'assets/icon/log.png',
                    fit: BoxFit.fitWidth,
                    height: 200,
                    width: 200,
                  ),
                ),
                const Text(
                  'Welcome To My Digital Identity',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  //TODO update this
                  'Register Now',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Center(
                    /*child: Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black),
                      )*/
                    child: isloading
                        ? CustomLoadingContainer()
                        : TextButton.icon(
                            onPressed: () async {
                              setState(() {
                                isloading = true;
                              });

                              try {
                                await AuthServiceUpdated()
                                    .signInWithGoogle()
                                    .then((value) =>
                                        AuthServiceUpdated().handleAuth());
                              } catch (e) {
                                setState(() {
                                  isloading = false;
                                });
                              }

                              //AuthService().handleAuth();
                            },
                            label: const Text(
                              'Google SignIn',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            icon: const Icon(Icons.arrow_forward_rounded),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: const Center(
                      child: Text(
                    "Click👆 to create an account",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AuthService().signInWithGoogle()),
                    );
                  },
                  child: Container(
                    height: 30,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: const Center(
                        child: Text(
                      "Copyright©",
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomLoadingContainer extends StatelessWidget {
  const CustomLoadingContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white54,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text("Please Wait ..."),
          CircularProgressIndicator(
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
}
