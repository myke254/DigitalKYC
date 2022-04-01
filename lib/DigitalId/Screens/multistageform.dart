import 'dart:io';

import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jaziadigitalid/DigitalId/Functions/constants.dart';
import 'package:jaziadigitalid/DigitalId/Screens/AuthScreens/authservice.dart';
import 'package:jaziadigitalid/DigitalId/Screens/customDrawer.dart';
import 'package:jaziadigitalid/DigitalId/Screens/profilepages/profmainscreen.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../Functions/firebasefunc.dart';
import '../Widgets/InputField.dart';

class DIRegister extends StatefulWidget {
  bool isenabled;
  DIRegister({
    Key? key,
    required this.isenabled,
  }) : super(key: key);

  @override
  State<DIRegister> createState() => _DIRegisterState();
}

class _DIRegisterState extends State<DIRegister> with TickerProviderStateMixin {
  int _activeStepIndex = 0;
  bool isloading = false;

  bool progressloading = false;
  List<String> phoneNumbers = [];
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  @override
  void initState() {
    super.initState();
    getPhoneNumbers();
    checkState();
    checkdb();
    isloading = false;
    _lottieAnimationController = AnimationController(vsync: this);
  }

  Future<bool> checkState() async {
    bool waiting = false;
    preferences = await SharedPreferences.getInstance();
    try {
      waiting = preferences.getBool("waiting")!;
    } catch (e) {
      waiting = false;
    }
    if (waiting) {
      await populateControllers();
    }

    return waiting;
  }

  Future populateControllers() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //   preferences.getString("uid");
      firstname.text = preferences.getString("fname") ?? "";
      lastname.text = preferences.getString("lname") ?? "";
      work.text = preferences.getString("work") ?? "";
      dob = DateTime.parse(
          preferences.getString("dob") ?? DateTime.now().toString());
      fathername.text = preferences.getString("fathername") ?? "";
      mothername.text = preferences.getString("mothername") ?? "";
      grandfathername.text = preferences.getString("grandfathername") ?? "";
      grandmothername.text = preferences.getString("grandmothername") ?? "";
      location.text = preferences.getString("location") ?? "";
      sublocation.text = preferences.getString("sublocation") ?? "";
      village.text = preferences.getString("village") ?? "";
      selectedVouchertype = preferences.getString("vouchertype") ?? "";
      voucheruniqueid.text = preferences.getString("voucherid") ?? "";
      //   preferences.getString("DigitalIdentity??"""
      // prefegetces.setStringList( "personpics", );
      // );
    });
  }

  Future getPhoneNumbers() async {
    await firestore.collection('chief').doc("DID123456").get().then((value) {
      setState(() {
        // chiefname = value["name"];
        //phone = value["phoneNumbers"][0];
        phoneNumbers = List.from(value['phoneNumbers']);
        // value["phoneNumbers"];
      });
    });
    //  print("phhone numbers are::");
    //print(phoneNumbers.length);
  }

  bool exists = false;

  Future<bool> checkdb() async {
    var valuegiven = firestore
        .collection("DigitalIdentity")
        .doc("ChiefId")
        .collection("Vouched")
        .where("uid", isEqualTo: auth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        exists = value.docs.first.exists;
      });
    });
    return exists;
  }

//person's details
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController work = TextEditingController();
  DateTime dob = DateTime.now();
  TextEditingController age = TextEditingController();
  TextEditingController maritalStatus = TextEditingController();
//parents details
  TextEditingController fathername = TextEditingController();
  TextEditingController mothername = TextEditingController();
//grandparet details
  TextEditingController grandmothername = TextEditingController();
  TextEditingController grandfathername = TextEditingController();
//location details
  TextEditingController location = TextEditingController();
  TextEditingController sublocation = TextEditingController();
  TextEditingController village = TextEditingController();

//voucher details
  String selectedVouchertype = "";
  TextEditingController voucheruniqueid = TextEditingController();
  TextEditingController voucherpassword = TextEditingController();
  late AnimationController _lottieAnimationController;

  List<ImageObject> _imgObjs = [];

  String _selectedVoucher = "Voucher Type";

  final TextEditingController _textFieldController = TextEditingController();

  void ShowCustomAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: 50,
                  child: Lottie.asset('assets/icon/animate.json',
                      controller: _lottieAnimationController,
                      height: 36.0, onLoaded: (composition) {
                    _lottieAnimationController..duration = composition.duration;
                  }),
                ),
                const Text("Checking Details......")
              ],
            ),
          );
        });
  }

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (_formKeys[_activeStepIndex].currentState!.validate()) {
      setState(() {
        // isloading =true;
      });
      setState(() {
        if (args.value is PickerDateRange) {
        } else if (args.value is DateTime) {
          setState(() {
            dob = DateTime.parse(args.value.toString());
          });
        } else if (args.value is List<DateTime>) {
        } else {}
      });
    }
  }

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.indexed,
          isActive: _activeStepIndex >= 0,
          title: const Text('Personal Information'),
          content: Form(
            key: _formKeys[0],
            child: Column(
              children: [
                Center(
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _imgObjs.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              itemCount: _imgObjs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 2),
                              itemBuilder: (BuildContext context, int index) {
                                final image = _imgObjs[index];
                                return Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Image.file(File(image.modifiedPath),
                                      height: 80, fit: BoxFit.cover),
                                );
                              })
                          : const Text("Please Add Your Picture"),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          var status = await Permission.camera.status;
                          var storagestatus = await Permission.storage.status;
                          if ((status.isDenied) || (storagestatus.isDenied)) {
                            status.isDenied
                                ? await Permission.camera.request()
                                : await Permission.storage.request();
                            // We didn't ask for permission yet or the permission has been denied before but not permanently.
                          }
                          // Get max 5 images
                          else {
                            final List<ImageObject>? objects =
                                await Navigator.of(context).push(
                                    PageRouteBuilder(
                                        pageBuilder: (context, animation, __) {
                              return const ImagePicker(maxCount: 3);
                            }));

                            if ((objects?.length ?? 0) > 0) {
                              setState(() {
                                _imgObjs = objects!;
                              });
                            }
                          }
                        },
                        child: Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _imgObjs.isEmpty
                                  ? const Text(
                                      "Add Photo",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const Text("Update Photos"),
                              Icon(
                                _imgObjs.length < 2
                                    ? Icons.add
                                    : Icons.update_sharp,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                EditText(title: "First Name", textEditingController: firstname),
                const SizedBox(
                  height: 8,
                ),
                EditText(title: "Last Name", textEditingController: lastname),
                const SizedBox(
                  height: 8,
                ),
                EditText(title: "Work", textEditingController: work),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "Date of Birth",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange: PickerDateRange(
                      DateTime.now().subtract(const Duration(days: 4)),
                      DateTime.now().add(const Duration(days: 3))),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _activeStepIndex <= 1 ? StepState.editing : StepState.indexed,
          isActive: _activeStepIndex >= 0,
          title: const Text('Parental Details'),
          content: Form(
            key: _formKeys[1],
            child: Container(
              child: Column(
                children: [
                  EditText(
                      title: "Father's Name",
                      textEditingController: fathername),
                  const SizedBox(
                    height: 8,
                  ),
                  EditText(
                      title: "Mother's Name",
                      textEditingController: mothername),
                  const SizedBox(
                    height: 8,
                  ),
                  EditText(
                      title: "GrandFather Name",
                      textEditingController: grandfathername),
                  const SizedBox(
                    height: 8,
                  ),
                  EditText(
                      title: "GrandMother Name",
                      textEditingController: grandmothername),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
        Step(
            state:
                _activeStepIndex <= 2 ? StepState.editing : StepState.indexed,
            isActive: _activeStepIndex >= 1,
            title: const Text('Location'),
            content: Form(
              key: _formKeys[2],
              child: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    EditText(
                        title: "Location", textEditingController: location),
                    const SizedBox(
                      height: 8,
                    ),
                    EditText(
                        title: "Sub Location",
                        textEditingController: sublocation),
                    const SizedBox(
                      height: 8,
                    ),
                    EditText(
                        title: "Village Name", textEditingController: village),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            )),
        Step(
          state: _activeStepIndex <= 3 ? StepState.editing : StepState.indexed,
          isActive: _activeStepIndex >= 0,
          title: const Text('Voucher'),
          content: Form(
            key: _formKeys[3],
            child: Container(
              child: Column(
                children: [
                  DropdownButton<String>(
                    hint: Text(_selectedVoucher.toString()),
                    items: <String>['Chief', 'Official'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVoucher = value.toString();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  EditText(
                      title: "Voucher ID",
                      textEditingController: voucheruniqueid),
                  const SizedBox(
                    height: 8,
                  ),
                  EditText(
                      title: "Voucher Password",
                      isPassword: true,
                      textEditingController: voucherpassword),
                ],
              ),
            ),
          ),
        ),
        Step(
            state: StepState.complete,
            isActive: _activeStepIndex >= 2,
            title: const Text('Confirm'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Full Name : ${firstname.text}  ${lastname.text}'),
                Text('Father Name: ${fathername.text}'),
                //     const Text('Password: *****'),
                Text('Mother Name : ${mothername.text}'),

                Text('Voucher Id : ${voucheruniqueid.text}'),
              ],
            ))
      ];

  @override
  Widget build(BuildContext context) {
    return exists
        ? const ProfilePage()
        : Scaffold(
            appBar: widget.isenabled
                ? AppBar(
                    backgroundColor: Colors.black45,
                    title: const Text(
                      ' Digital Identity Registration Form',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : null,
            backgroundColor: Colors.white,
            drawer: widget.isenabled ? const CustomDrawer() : null,
            body: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Stepper(
                type: StepperType.vertical,
                currentStep: _activeStepIndex,
                steps: stepList(),
                onStepContinue: () async {
                  if (_activeStepIndex < (stepList().length - 1)) {
                    //else {
                    if (_imgObjs.isNotEmpty) {
                      if (_formKeys[_activeStepIndex]
                          .currentState!
                          .validate()) {
                        setState(() {
                          _activeStepIndex += 1;
                        });
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "Please Select an Image in Personal Information Tab");
                    }
                    // }
                  } else {
                    bool isvalid = _formKeys[0].currentState!.validate() &&
                        _formKeys[1].currentState!.validate() &&
                        _formKeys[2].currentState!.validate() &&
                        _formKeys[3].currentState!.validate();

                    if (isvalid) {
                      // setState(() {
                      //   isloading = true;
                      // });
                      //   final future = await performOperations().th;
                      //   await showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AsyncProgressDialog(
                      //         future,
                      //         onError: () {},
                      //         message: Text("Please Wait"),
                      //       );
                      //     },
                      //   );
                      //   isloading = false;
                      //   isloading = false;
                      bool result =
                          await InternetConnectionChecker().hasConnection;
                      if (result == true) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Container(
                                      height: 200,
                                      width: 200,
                                      decoration: const BoxDecoration(
                                          color: Colors.white60),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          CircularProgressIndicator(
                                            color: Colors.lightBlue,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 20, bottom: 8.0),
                                            child: Text(
                                              "Please Wait ...",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                        await performOperations();
                      } else {
                        Fluttertoast.showToast(
                            msg: "please check your internet connection");

                        await FirebaseFunc().cachePersonDetail(
                          firstname.text.toString(),
                          lastname.value.text.trim(),
                          work.value.text.trim(),
                          dob,
                          fathername.value.text.trim(),
                          mothername.value.text.trim(),
                          grandfathername.value.text.trim(),
                          grandmothername.value.text.trim(),
                          location.value.text.trim(),
                          sublocation.value.text.trim(),
                          village.value.text.trim(),
                          _selectedVoucher,
                          voucheruniqueid.value.text.trim(),
                        );
                      }
                      //await checkinternetconnectivity(context);

                      ///await _displayTextInputDialog(context);
                      // setState(() {
                      //   isloading = false;
                      // });
                    } else {
                      print("cannot do so");
                    }

                    setState(() {
                      isloading = false;
                    });
                  }
                },
                onStepCancel: () {
                  if (_activeStepIndex == 0) {
                    return;
                  }
                  setState(() {
                    _activeStepIndex -= 1;
                  });
                },
              ),
            ),
          );
  }

  Future getChiefId() async {
    var value = firestore.collection("Chief").doc().snapshots();
  }

  bool saving = false;
  Future saveDetails() async {
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  height: 200,
                  width: 300,
                  decoration: const BoxDecoration(color: Colors.white60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(
                        color: Colors.lightBlue,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 8.0),
                        child: Text(
                          "Generating Digital Id  Please Wait ...",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });

    List<String> allpics = await FirebaseFunc().uploadAllImages(_imgObjs);

    await FirebaseFunc()
        .savePersonDetails(
            firstname.text.toString(),
            lastname.value.text.trim(),
            work.value.text.trim(),
            dob,
            fathername.value.text.trim(),
            mothername.value.text.trim(),
            grandfathername.value.text.trim(),
            grandmothername.value.text.trim(),
            location.value.text.trim(),
            sublocation.value.text.trim(),
            village.value.text.trim(),
            _selectedVoucher,
            voucheruniqueid.value.text.trim(),
            allpics)
        .then((value) {
      Navigator.of(context).pop();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: ((context) => const ProfilePage())));
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Verify the Input Code'),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  Wrap(children: [
                    Text(
                        "Sms Code has been sent to Voucher with ID: ${voucheruniqueid.value.text.toString()}")
                  ]),
                  SizedBox(height: 30),
                  TextField(
                    controller: _textFieldController,
                    decoration: const InputDecoration(hintText: "verify code"),
                  ),
                ],
              ),
            ),
            actions: saving
                ? [
                    const Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 10,
                    ))
                  ]
                : [
                    TextButton(
                        onPressed: () async {
                          if (validatecode(_textFieldController.value.text
                              .trim()
                              .toString())) {
                            await saveDetails();

                            //  Navigator.of(context).pop();

                          } else {
                            Fluttertoast.showToast(
                                msg: "Incorrect Code Inputed");
                          }
                        },
                        child: const Text("Validate ")),
                  ],
          );
        });
  }

  ///Load the ima
  performOperations() async {
    ///get all number of the person using twilio
    randomNumber = getRandomNumber();

    for (int i = 0; i < phoneNumbers.length; i++) {
      print(phoneNumbers[i]);
      await SendTwilioMessage(phoneNumbers[i].toString(),
          "Please Confirm that you're the one registering this person named ${firstname.value.text.trim()}  ${lastname.value.text.trim()}   \n Fathers Name : ${fathername.value.text.trim()} \n Mother name ${mothername.value.text.trim()} \n GrandFather Name : ${grandfathername.value.text.trim()} \n GrandMother name : ${grandmothername.value.text.trim()} \n Location : ${location.value.text.trim()} \n Sublocation : ${sublocation.value.text.trim()} \nVillage Name : ${village.value.text.trim()} \n Validation Code ${randomNumber.toString()}");
    }

    Navigator.of(context).pop();
    _displayTextInputDialog(context);
  }
}
