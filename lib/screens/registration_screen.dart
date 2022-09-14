import 'dart:io';
import 'package:book_my_show_clone_web/utils/color_palette.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebaseServices/firebase_services.dart';
import '../services/providerService/auth_provider.dart';
import '../utils/asset_images_strings.dart';
import 'init_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "register-screen";
  final String uid;
  final String phoneNumber;

  const RegistrationScreen({
    Key? key,
    required this.phoneNumber,
    required this.uid,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? _userName,
      _email,
      // ignore: prefer_final_fields
      _myPic =
          "https://firebasestorage.googleapis.com/v0/b/demologinapp-8cf00.appspot.com/o/user1-2.jpg?alt=media&token=cfe5c023-e6c3-480f-98bc-17c46b95865a";
  double? height;
  double? width;
  File? driverImage;
  File? blueBook;
  File? drivingLicence;
  File? cropped;
  String? token;

  String? data1;

  final _formKey = GlobalKey<FormState>();

  GlobalKey<ScaffoldState>? globalKey;

  bool? checkBoxSubmit;

  final FirebaseServices _userServices = FirebaseServices();

  AuthProvider? authProvider;
  @override
  void initState() {
    //getToken();
    super.initState();
    globalKey = GlobalKey<ScaffoldState>();

    checkBoxSubmit = false;
  }

  // getToken() async {
  //   token = await firebaseMessaging.getToken();
  // }

  void showErrorSnack(String errorMsg) {
    final snackbar = SnackBar(
      //  behavior: SnackBarBehavior.floating,
      //  padding:EdgeInsets.only(bottom: 45),

      backgroundColor: ColorPalette.secondary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5))),
      duration: const Duration(days: 365),
      content: Text("Error :  $errorMsg",
          style: const TextStyle(
              fontFamily: "poppins",
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.normal)),
      action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          // ignore: deprecated_member_use
          onPressed: globalKey!.currentState!.hideCurrentSnackBar),
    );
    // ignore: deprecated_member_use
    globalKey!.currentState!.showSnackBar(snackbar);

    //throw Exception('Error registering: $errorMsg');
  }

  void showSuccessSnack(String successMsg) {
    final snackbar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      duration: const Duration(days: 365),
      content: Text(
        "Success :  $successMsg",
        style: const TextStyle(
            fontFamily: "poppins",
            fontSize: 14.0,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      ),
      action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          // ignore: deprecated_member_use
          onPressed: globalKey!.currentState!.hideCurrentSnackBar),
    );
    // ignore: deprecated_member_use
    globalKey!.currentState!.showSnackBar(snackbar);

    //throw Exception('Error registering: $errorMsg');
  }

  mHeight() {
    return height = MediaQuery.of(context).size.height;
  }

  mWidth() {
    return width = MediaQuery.of(context).size.width;
  }

  String? _emailValidator(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value!)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  void createUser({String? id, String? number, String? name, String? emailId}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'name': name,
      'email': emailId,
      'profile_Pic_URL': _myPic,
      'token': token,
    });
    // SharedServices.addUserDataToSF(
    //   userName: name!,
    //   userPhone: number!,
    //   userEmail: emailId!,
    //   userPhoto: _myPic!,
    // );
  }

  void _registerUser({String? name, String? emailId}) async {
    try {
      createUser(
        id: widget.uid,
        number: widget.phoneNumber,
        name: name,
        emailId: emailId,
      );
      
      Navigator.pushReplacementNamed(context, InitScreen.id);
    } catch (e) {
      // errorSnack(context, e.message);
    }
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      if (checkBoxSubmit == true) {
        if (kDebugMode) {
          print("Username: $_userName \n Email: $_email");
        }

        _registerUser(name: _userName, emailId: _email);
      } else {
        showAlertDialogForError(
            context, '\n\u2022 CheckBox is Not selected \n');
      }
    } else {
      if (kDebugMode) {
        print("CheckBox Submit ");
      }
      //  errorSnack(context, "Please Select the CheckBox");

    }
  }

  Widget _checkBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: checkBoxSubmit,
            onChanged: (value) {
              setState(() {
                checkBoxSubmit = !checkBoxSubmit!;
              });
            },
            activeColor: ColorPalette.primary,
            checkColor: Colors.white,
            tristate: false,
          ),
          Text.rich(TextSpan(
              text: 'I agree with   ',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.white),
              children: <InlineSpan>[
                TextSpan(
                  text: 'Terms & Conditions',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: ColorPalette.primary,
                        decoration: TextDecoration.underline,
                      ),
                  recognizer: TapGestureRecognizer()..onTap = () => Container(),
                )
              ])),
        ],
      ),
    );
  }

  Widget _showUserNameInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 05 * 1),
      child: TextFormField(
          onSaved: (val) => _userName = val!.trim(),
          keyboardType: TextInputType.name,
          autofillHints: const [
         
            AutofillHints.name,
           
          ],
          textCapitalization: TextCapitalization.words,
          validator: (value) => value!.length < 3 ? "UserName too Short" : null,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 18,
              color: ColorPalette.white, fontWeight: FontWeight.normal),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.only(
                top: 15, bottom: 15, left: 15, right: 15),
            prefixIcon: const Icon(
              EvaIcons.personOutline,
              size: 20,
              color: ColorPalette.primary,
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(width: 0.7, color: ColorPalette.white),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            focusedBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(width: 0.7, color: ColorPalette.white),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            errorBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(width: 0.7, color: ColorPalette.white),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            errorMaxLines: 1,
            focusedErrorBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(width: 0.7, color: ColorPalette.white),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            labelText: 'Full Name',
            labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 18,
                color: ColorPalette.white, fontWeight: FontWeight.normal),
            hintText: "Enter Full Name* ",
            hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 18,
                color: ColorPalette.white, fontWeight: FontWeight.normal),
            errorStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 14,
                color: ColorPalette.error,
                fontWeight: FontWeight.normal),
          )),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 15 * 1),
      child: TextFormField(
          onSaved: (val) => _email = val!.trim().toLowerCase(),
          validator: _emailValidator,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [
            AutofillHints.email,
          ],
         style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 18,
              color: ColorPalette.white, fontWeight: FontWeight.normal),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.only(
                top: 15, bottom: 15, left: 15, right: 15),
            prefixIcon: const Icon(
              EvaIcons.emailOutline,
              size: 20,
              color: ColorPalette.primary,
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(width: 0.7, color: ColorPalette.white),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            focusedBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(width: 0.7, color: ColorPalette.white),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            errorBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(width: 0.7, color: ColorPalette.white),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            errorMaxLines: 1,
            focusedErrorBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(width: 0.7, color: ColorPalette.white),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            labelText: 'Email ID',
            labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 18,
                color: ColorPalette.white, fontWeight: FontWeight.normal),
            hintText: "Enter Email ID* ",
            hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
               fontSize: 18,
                color: ColorPalette.white, fontWeight: FontWeight.normal),
            errorStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 14,
                color: ColorPalette.error,
                fontWeight: FontWeight.normal),
          )),
    );
  }

  Widget _showPhoneNumber() {
    return Padding(
        padding: const EdgeInsets.only(top: 15 * 1),
        child: SizedBox(
          width: double.infinity,
          // height:55,
          child: Card(
              margin: EdgeInsets.zero,
              color: ColorPalette.primary,
              elevation: 0,
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                side:
                    const BorderSide(color: ColorPalette.secondary, width: 0.7),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            EvaIcons.phoneOutline,
                            size: 20,
                            color: ColorPalette.secondary,
                          ),
                          const SizedBox(width: 10),
                          Text(widget.phoneNumber,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                     fontSize: 18,
                                      color: ColorPalette.secondary,
                                      fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Icon(EvaIcons.checkmarkCircle,
                          size: 22, color: ColorPalette.secondary),
                    ],
                  ))),
        ));
  }

  Widget _signUpButton() {
    return Center(
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                // side: BorderSide(color: bgColor, width: 0.0),
                borderRadius: BorderRadius.circular(50)),
            elevation: 3,
            primary: ColorPalette.primary,
          ),
          child: Text("CONTINUE",
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 20, color: Colors.white, letterSpacing: 1.5)),
          onPressed: () {
            _submit();
          },
        ),
      ),
    );
  }

  Widget _inputForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // _header(),
                    _showUserNameInput(),
                    const SizedBox(height: 10),
                    _showEmailInput(),
                    const SizedBox(height: 10),
                    _showPhoneNumber(),
                    const SizedBox(height: 20),
                    _checkBox(),
                    const SizedBox(height: 40),
                    _signUpButton()
                  ]),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // SizedBox(height: 1 * 1),
      ],
    );
  }

  Widget brandLogo() {
    return Center(
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.transparent,
        child: SizedBox(
            width: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                AssetImageClass.fullAppLogo,
                fit: BoxFit.cover,
              ),
            )),
      ),
    );
  }

  Widget _body() {
    return Center(
      child: SizedBox(
       
        width: 500,
        child: SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(
                  color: ColorPalette.secondary,
                  borderRadius: BorderRadius.circular(10)),
             
              width: 500,
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 20),
                        brandLogo(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 10,
                              ),
                              child: Text("Let's Get Started!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10 * 1,
                                left: 10 * 1,
                                right: 10 * 1,
                              ),
                              child: Text(
                                  "Please Sign up to continue using our app.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: ColorPalette.secondary,
                                          letterSpacing: 0.5)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10 * 1,
                            right: 10 * 1,
                            top: 10 * 1,
                          ),
                          child: _inputForm(),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return _body();

    // Scaffold(
    //     backgroundColor: ColorPalette.background,
    //     key: globalKey,
    //     //  resizeToAvoidBottomInset: false,
    //     body: _body());
  }

  showAlertDialogForError(BuildContext context, String title) {
    // set up the button
    Widget okButton = TextButton(
        style: TextButton.styleFrom(
            // elevation: 4,
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.all(Radius.circular(8))),
            primary: Theme.of(context).colorScheme.secondary),
        child: Text(
          "CLOSE",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.black),
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        });

    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Error !",
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: ColorPalette.primary)),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyText1),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     Text("\n\u2022 Check Box",
          //         style: Theme.of(context).textTheme.bodyText1),

          //   ],
          // ),
        ],
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context1) {
        return alert;
      },
    );
  }
}
