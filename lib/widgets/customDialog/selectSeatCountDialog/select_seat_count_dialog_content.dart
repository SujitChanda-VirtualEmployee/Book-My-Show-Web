import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../models/hall_details_model.dart';
import '../../../models/movie_details_model.dart';
import '../../../screens/ticketBookingScreen/ticket_booking_screen.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/custom_styles.dart';
import '../selectSeatsDialog/select_seats_dialog.dart';

class SelectSeatCountCountDialogComponent extends StatefulWidget {
  final MovieDetailsModel movieDetailsData;
  final CinemaHallClass theatreDetailsData;
  final DateTime selectedDate;
  final String selectedTime;

  const SelectSeatCountCountDialogComponent({
    Key? key,
    required this.movieDetailsData,
    required this.theatreDetailsData,
    required this.selectedDate,
    required this.selectedTime,
  }) : super(key: key);

  @override
  State<SelectSeatCountCountDialogComponent> createState() =>
      _SelectSeatCountCountDialogComponentState();
}

class _SelectSeatCountCountDialogComponentState
    extends State<SelectSeatCountCountDialogComponent> {
  int imageSelected = 0;
  List countList = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List iconList = [
    "assets/icons/cycling.png",
    "assets/icons/scooter.png",
    "assets/icons/motorbike.png",
    "assets/icons/car.png",
    "assets/icons/car.png",
    "assets/icons/suv.png",
    "assets/icons/car-2.png",
    "assets/icons/car-2.png",
    "assets/icons/bus.png",
    "assets/icons/bus.png",
  ];
  @override
  void initState() {
    log("Selected Date : ${widget.selectedDate}");
    log("Selected Time : ${widget.selectedTime}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 2.5,
        width: 500,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: ColorPalette.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "How many Seats ? ",
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.secondary,
                        fontSize: 10 * 2,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SizedBox(
                    child: Image.asset(
                  iconList[imageSelected],
                  height: 40,
                )),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 32,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          imageSelected = index;
                          for (int i = 0; i < countList.length; i++) {
                            if (i == index) {
                              setState(() {
                                countList[i] = true;
                              });
                            } else {
                              setState(() {
                                countList[i] = false;
                              });
                            }
                          }
                          log(countList.toString());
                        },
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              color: countList[index] == true
                                  ? ColorPalette.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(500)),
                          child: Center(
                              child: Text(
                            "${index + 1}",
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                                    fontSize: 10 * 2,
                                    fontWeight: FontWeight.bold,
                                    color: countList[index] == true
                                        ? Colors.white
                                        : Colors.black),
                          )),
                        ),
                      );
                    },
                    itemCount: countList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 15,
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                height: 30,
                thickness: 1,
              ),
              // SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SILVER",
                        style:
                            CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: Colors.black,
                          fontSize: 10 * 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "₹ 100.00",
                        style:
                            CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10 * 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Available".toUpperCase(),
                        style:
                            CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: Colors.green,
                          fontSize: 10 * 1.4,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "GOLD",
                        style:
                            CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: Colors.black,
                          fontSize: 10 * 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "₹ 130.00",
                        style:
                            CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10 * 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Available".toUpperCase(),
                        style:
                            CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: Colors.green,
                          fontSize: 10 * 1.4,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BALCONY - US",
                        style:
                            CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: Colors.black,
                          fontSize: 10 * 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "₹ 110.00",
                        style:
                            CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10 * 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Available".toUpperCase(),
                        style:
                            CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: Colors.green,
                          fontSize: 10 * 1.4,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, -2),
                      color: ColorPalette.secondary.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 0),
                ]),
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: ColorPalette.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Navigator.pop(context);
                        // SelectSeatsDialog.showCustomDialog(
                        //   movieDetailsData: widget.movieDetailsData,
                        //   selectedDate: widget.selectedDate,
                        //   selectedTime: widget.selectedTime,
                        //   theatreDetailsData: widget.theatreDetailsData,
                        //   ticketCount: (imageSelected + 1),
                        // );
                         Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        TicketBookingScreen.id,
                        arguments: [
                          widget.movieDetailsData,
                          widget.theatreDetailsData,
                          widget.selectedDate,
                          widget.selectedTime,
                          (imageSelected + 1),
                        ],
                      );
                      },
                      child: Text(
                        "Select Seats",
                        style:
                            CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10 * 2,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
