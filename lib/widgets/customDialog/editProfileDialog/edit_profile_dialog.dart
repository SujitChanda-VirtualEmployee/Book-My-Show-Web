import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../screens/profileScreen/editProfileScreen/edit_profile_screen.dart';


class EditProfileDialog {
  static showCustomDialog() {
    Get.generalDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return   const EditProfileScreen();
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
      
    });
  }
}
