import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import '../../../services/firebaseServices/firebase_services.dart';
import '../../../services/providerService/auth_provider.dart';
import '../../../utils/miUi_animBuilder.dart';
import '../registrationDialog/registration_dialog.dart';
import 'otp_verification_dialog_content.dart';

class OTPVerificationDialog {
  static showCustomDialog(
      {required BuildContext context,
      required String number,
      required String? verificationId}) {
    Get.generalDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return OTPVerifyDialogContent(
          number: number,
        );
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
    ).then((smsOtp) async {
      FirebaseServices services = FirebaseServices();
      if (smsOtp != null) {
        EasyLoading.show(status: "Verifing ...");
        try {
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId!, smsCode: smsOtp.toString());
          final User? user = (await FirebaseAuth.instance
                  .signInWithCredential(phoneAuthCredential))
              .user;
          if (user != null) {
            EasyLoading.showSuccess("Phone Number verified");
            if (kDebugMode) {
              print("Login Successful");
            }
            if (FirebaseAuth.instance.currentUser != null) {
              try {
                services.getUserById(user.uid).then((snapShot) {
                  if (snapShot != null && snapShot.exists) {
                    Provider.of<AuthProvider>(context, listen: false)
                        .saveUserDetails(
                      uid: '${snapShot['id']}',
                      email: '${snapShot['email']}',
                      token: '${snapShot['token']}',
                      userName: '${snapShot['name']}',
                      userDoB: '${snapShot['user_dob']}',
                      identity: snapShot['identity'],
                      married: snapShot['married'],
                      phoneNumber: '${snapShot['number']}',
                      profilePicURL: '${snapShot['profile_Pic_URL']}',
                    );
                  } else {
                    RegistrationDialog.showCustomDialog(
                        context: context,
                        phoneNumber: number,
                        uid: FirebaseAuth.instance.currentUser!.uid);
                  }
                });
              } catch (e) {
                debugPrint('Login failed');
                EasyLoading.showError("Phone Number\nverification Failed");
              }
            }
          } else {
            debugPrint('Login failed');
            EasyLoading.showError("Phone Number\nverification Failed");
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == "invalid-verification-code") {
            _showToast(
                " You have entered Invalid Verification Code. Please try again ");
            EasyLoading.dismiss();
          } else {
            _showToast(e.message.toString());
            EasyLoading.dismiss();
          }
        }
      } else {
        showToast("  Please Enter the PIN Correctly!  ");
        EasyLoading.dismiss();
      }
    });
  }

  static _showToast(String message) {
    // Fluttertoast.cancel();
    return showToast(
      message,
      position: ToastPosition.bottom,
      backgroundColor: Colors.black.withOpacity(0.8),
      radius: 13.0,
      textStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
      animationBuilder: const Miui10AnimBuilder(),
    );
  }
}
