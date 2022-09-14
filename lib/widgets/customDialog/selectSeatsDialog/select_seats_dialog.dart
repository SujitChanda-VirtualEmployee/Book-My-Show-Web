import 'package:book_my_show_clone_web/widgets/customDialog/selectSeatsDialog/select_seats_dialog_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/hall_details_model.dart';
import '../../../models/movie_details_model.dart';

class SelectSeatsDialog {
  static showCustomDialog({
    required MovieDetailsModel movieDetailsData,
    required CinemaHallClass theatreDetailsData,
    required DateTime selectedDate,
    required String selectedTime,
    required int ticketCount,
  }) {
    Get.generalDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return SelectSeatsDialogContent(
          movieDetailsData: movieDetailsData,
          theatreDetailsData: theatreDetailsData,
          selectedDate: selectedDate,
          selectedTime: selectedTime,
          ticketCount: ticketCount,
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
