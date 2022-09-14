import 'package:book_my_show_clone_web/widgets/customDialog/mapDialog/map_dialog_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MapDialog {
  static showCustomDialog({required BuildContext context}) {
    Get.generalDialog(
   
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return   const MapDialogContent();
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
      // Navigator.of(context).pop();
    });
  }
}
