import 'package:book_my_show_clone_web/widgets/customDialog/selectSeatCountDialog/select_seat_count_dialog_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/hall_details_model.dart';
import '../../../models/movie_details_model.dart';

class SelectSeatCountDialog {
  static showCustomDialog({
    required CinemaHallClass theatreDetailsData,
    required MovieDetailsModel movieDetailsData,
    required DateTime date,
    required String time,
  }) {
    Get.generalDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return SelectSeatCountCountDialogComponent(
          movieDetailsData: movieDetailsData,
          theatreDetailsData: theatreDetailsData,
          selectedDate: date,
          selectedTime: time,
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
      // Navigator.of(context).pop();
    });
  }
}
