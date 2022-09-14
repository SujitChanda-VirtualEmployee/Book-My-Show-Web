import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../OTPVerificationDialog/otp_verification_dialog.dart';
import 'login_dialog_content.dart';

class LoginDialog {
  static showCustomDialog(BuildContext context) {
    Get.generalDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const LoginDialogContent();
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, -0.3), end: const Offset(0, 0))
              .animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    ).then((phoneNumber) {
      if (phoneNumber != null) {
        if (phoneNumber.toString().length == 10) {
          EasyLoading.show(status: "Sending OTP to\n${phoneNumber.toString()}");
          String number = '+91$phoneNumber';

          verifyPhone(context: context, number: number);
        } else {}
      }

      // Navigator.of(context).pop();
    });
  }

  static Future<void> verifyPhone(
      {required BuildContext context, required String number}) async {
    String verificationId = "";
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
    };

    // ignore: prefer_function_declarations_over_variables
    final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
      verificationId = verId;
      if (kDebugMode) {
        print(number);
      }
      EasyLoading.showSuccess("Sending OTP Successfully");

      OTPVerificationDialog.showCustomDialog(
          context: context, number: number, verificationId: verificationId);
    };

    try {
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
