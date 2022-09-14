import 'package:book_my_show_clone_web/screens/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dialog_content.dart';

class ConfirmDialog {
  static showCustomDialog(String paymentId) {
    Get.generalDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return DialogContent(
          paymentId: paymentId,
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 0.8), end: const Offset(0, 0))
              .animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    ).whenComplete(() {
      //Get.offNamedUntil(LandingScreen.id, (route) => false);
      Get.offAllNamed(
        SplashScreen.id,
      );
    });
  }
}
