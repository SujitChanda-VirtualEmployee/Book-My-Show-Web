import 'package:book_my_show_clone_web/utils/color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pinput/pinput.dart';
import '../../widgets/customSheets/OTPVerificationSheet/otp_verification_sheet.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String smsOtp = "";
  String? verificationId;
  String error = '';
  bool otpSubmit = false;
  //bool loading = false;
  User? user;
  String? authStatus;
  bool paymentSuccess = false;
  String? screen;
  double? latitude;
  double? longitude;
  String? address;
  String? location;
  String? userName;
  String? phoneNumber;
  String? email;
  String? uid;
  String? profilePicURL;
  String? token;
  String? userDoB;
  bool? identity;
  bool? married;

  final pinputFocusNode = FocusNode();
  final defaultPinTheme = PinTheme(
    width: 60,
    height: 60,
    margin: const EdgeInsets.only(left: 5, right: 5),
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: ColorPalette.secondary),
      borderRadius: BorderRadius.circular(50),
    ),
  );

  saveUserDetails({
    required String uid,
    required String userName,
    required String phoneNumber,
    required String email,
    required String profilePicURL,
    required String token,
    String ? userDoB,
    bool ? identity,
    bool? married,
  }) {
    this.uid = uid;
    this.userName = userName;
    this.phoneNumber = phoneNumber;
    this.email = email;
    this.profilePicURL = profilePicURL;
    this.token = token;
    this.identity = identity;
    this.userDoB = userDoB; 
    this.married = married;

    notifyListeners();
  }

  setFcmToken(String token) {
    this.token = token;
    notifyListeners();
  }

  resetAuth() {
    uid = null;
    userName = null;
    phoneNumber = null;
    email = null;
    profilePicURL = null;
    token = null;
    notifyListeners();
  }

  setAuthStatus({required User? user, required String authStatus}) {
    this.user = user;
    this.authStatus = authStatus;
    notifyListeners();
  }

  Future<void> verifyPhone(
      {required BuildContext context, required String number}) async {
    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) {};

    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (kDebugMode) {
        print(e.code);
      }
      EasyLoading.showError("Phone Number\nverification Failed");
      error = e.toString();
      notifyListeners();
    };

    // ignore: prefer_function_declarations_over_variables
    final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
      verificationId = verId;
      if (kDebugMode) {
        print(number);
      }
      EasyLoading.showSuccess("Sending OTP Successfully");
      notifyListeners();
      OTPVerificationSheet.smsOtpDialog(
          context: context, number: number, verificationId: verificationId);
    };

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );
    } catch (e) {
      error = e.toString();

      notifyListeners();
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
