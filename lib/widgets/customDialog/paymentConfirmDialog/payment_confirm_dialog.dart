import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/hall_details_model.dart';
import '../../../models/movie_details_model.dart';
import '../../../screens/paymentScreen/payment_screen.dart';
import '../../../screens/ticketBookingScreen/ticket_booking_screen.dart';

class PaymentConfirmDialog {
  static showCustomDialog({
    required List<ChairList> chairList,
    required MovieDetailsModel movieDetailsData,
    required DateTime selectedDate,
    required String selectedTime,
    required CinemaHallClass theatreDetailsData,
  }) {
    Get.generalDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return  PaymentScreen(
          chairList: chairList,
          movieDetailsData: movieDetailsData,
          selectedDate: selectedDate,
          selectedTime: selectedTime,
          theatreDetailsData: theatreDetailsData,
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
