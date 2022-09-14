import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:book_my_show_clone_web/screens/paymentScreen/payment_screen.dart';
import 'package:book_my_show_clone_web/services/providerService/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import '../../../models/hall_details_model.dart';
import '../../../models/movie_details_model.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/custom_styles.dart';
import '../../../utils/miUi_animBuilder.dart';
import '../../utils/responsive.dart';
import '../../widgets/customDialog/loginDialog/login_dialog.dart';
import '../../widgets/customDialog/paymentConfirmDialog/payment_confirm_dialog.dart';
import '../../widgets/customDialog/registrationDialog/registration_dialog.dart';

class TicketBookingScreen extends StatefulWidget {
  static const String id = "ticketBooking-screen";

  final MovieDetailsModel movieDetailsData;
  final CinemaHallClass theatreDetailsData;
  final DateTime selectedDate;
  final String selectedTime;
  final int ticketCount;

  const TicketBookingScreen(
      {Key? key,
      required this.movieDetailsData,
      required this.ticketCount,
      required this.theatreDetailsData,
      required this.selectedDate,
      required this.selectedTime})
      : super(key: key);

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  final ScrollController horizontalScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();
  List<ChairList> selectedSeats = [];
  double amountNeedTopay = 0;
  List<TopLeftChairList> topLeftChairList = [];
  List<TopRightChairList> topRightChairList = [];
  List<TopCenterChairList> topCenterChairList = [];
  List<MidRightChairList> midRightChairList = [];
  List<MidLeftChairList> midLeftChairList = [];
  List<MidCenterChairList> midCenterChairList = [];
  List<BottomLeftChairList> bottomLeftChairList = [];
  List<BottomRightChairList> bottomRightChairList = [];
  List<BottomCenterChairList> bottomCenterChairList = [];

  @override
  void initState() {
    setTopLeftChairList();
    setTopRightChairList();
    setTopCenterChairList();

    setMidLeftChairList();
    setMidRightChairList();
    setMidCenterChairList();

    setBottomLeftChairList();
    setBottomRightChairList();
    setBottomCenterChairList();

    super.initState();
  }

  setTopLeftChairList() {
    for (int i = 0; i < 80; i++) {
      if (i == 24 ||
          i == 25 ||
          i == 26 ||
          i == 27 ||
          i == 0 ||
          i == 1 ||
          i == 6 ||
          i == 7) {
        topLeftChairList.add(TopLeftChairList(
            id: "TLS ${i + 1}", price: 110, selected: false, occupied: true));
      } else {
        topLeftChairList.add(TopLeftChairList(
            id: "TLS ${i + 1}", price: 110, selected: false, occupied: false));
      }
    }
  }

  setTopRightChairList() {
    for (int i = 0; i < 80; i++) {
      if (i == 24 ||
          i == 25 ||
          i == 26 ||
          i == 27 ||
          i == 12 ||
          i == 19 ||
          i == 20 ||
          i == 7) {
        topRightChairList.add(TopRightChairList(
            id: "TRS ${i + 1}", price: 110, selected: false, occupied: true));
      } else {
        topRightChairList.add(TopRightChairList(
            id: "TRS ${i + 1}", price: 110, selected: false, occupied: false));
      }
    }
  }

  setTopCenterChairList() {
    for (int i = 0; i < 98; i++) {
      if (i == 6 ||
          i == 13 ||
          i == 14 ||
          i == 15 ||
          i == 16 ||
          i == 17 ||
          i == 12 ||
          i == 11 ||
          i == 10 ||
          i == 9 ||
          i == 8 ||
          i == 7) {
        topCenterChairList.add(TopCenterChairList(
            id: "TCS ${i + 1}", price: 110, selected: false, occupied: true));
      } else {
        topCenterChairList.add(TopCenterChairList(
            id: "TCS ${i + 1}", price: 110, selected: false, occupied: false));
      }
    }
  }

  setMidRightChairList() {
    for (int i = 0; i < 80; i++) {
      midRightChairList.add(MidRightChairList(
          id: "MRS ${i + 1}", price: 130, selected: false, occupied: false));
    }
  }

  setMidLeftChairList() {
    for (int i = 0; i < 80; i++) {
      if (i == 23 ||
          i == 22 ||
          i == 21 ||
          i == 20 ||
          i == 19 ||
          i == 18 ||
          i == 0 ||
          i == 5 ||
          i == 4 ||
          i == 3 ||
          i == 2 ||
          i == 1) {
        midLeftChairList.add(MidLeftChairList(
            id: "MLS ${i + 1}", price: 130, selected: false, occupied: true));
      } else {
        midLeftChairList.add(MidLeftChairList(
            id: "MLS ${i + 1}", price: 130, selected: false, occupied: false));
      }
    }
  }

  setMidCenterChairList() {
    for (int i = 0; i < 98; i++) {
      if (i == 23 ||
          i == 22 ||
          i == 21 ||
          i == 20 ||
          i == 19 ||
          i == 18 ||
          i == 0 ||
          i == 5 ||
          i == 4 ||
          i == 3 ||
          i == 2 ||
          i == 1) {
        midCenterChairList.add(MidCenterChairList(
            id: "MCS ${i + 1}", price: 130, selected: false, occupied: true));
      } else {
        midCenterChairList.add(MidCenterChairList(
            id: "MCS ${i + 1}", price: 130, selected: false, occupied: false));
      }
    }
  }

  setBottomLeftChairList() {
    for (int i = 0; i < 60; i++) {
      bottomLeftChairList.add(BottomLeftChairList(
          id: "BLS ${i + 1}", price: 100, selected: false, occupied: false));
    }
  }

  setBottomRightChairList() {
    for (int i = 0; i < 60; i++) {
      if (i == 13 ||
          i == 12 ||
          i == 11 ||
          i == 10 ||
          i == 19 ||
          i == 18 ||
          i == 0 ||
          i == 5 ||
          i == 4 ||
          i == 3 ||
          i == 2 ||
          i == 1) {
        bottomRightChairList.add(BottomRightChairList(
            id: "BRS ${i + 1}", price: 100, selected: false, occupied: true));
      } else {
        bottomRightChairList.add(BottomRightChairList(
            id: "BRS ${i + 1}", price: 100, selected: false, occupied: false));
      }
    }
  }

  setBottomCenterChairList() {
    for (int i = 0; i < 70; i++) {
      if (i == 14 || i == 15) {
        bottomCenterChairList.add(BottomCenterChairList(
            id: "BCS ${i + 1}", price: 100, selected: false, occupied: true));
      } else {
        bottomCenterChairList.add(BottomCenterChairList(
            id: "BCS ${i + 1}", price: 100, selected: false, occupied: false));
      }
    }
  }

  static _showToast() {
    // Fluttertoast.cancel();
    return showToast(
      " Sorry, this seat is not available ",
      position: ToastPosition.bottom,
      backgroundColor: Colors.black.withOpacity(0.8),
      radius: 13.0,
      textStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
      animationBuilder: const Miui10AnimBuilder(),
    );
  }

  _sheatOnTap({required int index, required List<ChairList> chairList}) {
    if (chairList[index].occupied == true) {
      _showToast();
    } else {
      if (chairList[index].selected == false &&
          selectedSeats.length < widget.ticketCount) {
        setState(() {
          chairList[index].selected = true;
          selectedSeats.add(chairList[index]);
          amountNeedTopay = amountNeedTopay + chairList[index].price;
        });
      } else if (chairList[index].selected == true) {
        setState(() {
          chairList[index].selected = false;
          selectedSeats.remove(chairList[index]);
          amountNeedTopay = amountNeedTopay - chairList[index].price;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return Scaffold(
        bottomSheet: Visibility(
          visible: Responsive.isMobile(context) &&
              widget.ticketCount == selectedSeats.length,
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    offset: const Offset(0, -2),
                    color: ColorPalette.secondary.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 0),
              ]),
              height: 60,
              width: 1000,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: ColorPalette.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (authProvider.uid != null) {
                        Get.back();
                        Get.toNamed(PaymentScreen.id, arguments: [
                          widget.movieDetailsData,
                          widget.theatreDetailsData,
                          widget.selectedDate,
                          widget.selectedTime,
                          selectedSeats,
                        ]);
                      } else {
                        if (authProvider.authStatus == "Registration") {
                          RegistrationDialog.showCustomDialog(
                              context: context,
                              phoneNumber: authProvider.user!.phoneNumber!,
                              uid: authProvider.user!.uid);
                        } else if (authProvider.authStatus == "Login") {
                          LoginDialog.showCustomDialog(context);
                        }
                      }
                    },
                    child: Text(
                      "Pay ₹ ${amountNeedTopay.toStringAsFixed(2)}",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10 * 2,
                      ),
                    )),
              ),
            ),
          ),
        ),
        backgroundColor: ColorPalette.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorPalette.secondary,
          automaticallyImplyLeading: false,
          leading: Responsive.isMobile(context)
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    shadows: [
                      BoxShadow(
                          offset: Offset(1, 1),
                          color: ColorPalette.secondary,
                          spreadRadius: 10,
                          blurRadius: 10),
                    ],
                  ))
              : null,
          actions: !Responsive.isMobile(context) &&
                  widget.ticketCount == selectedSeats.length
              ? [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: ColorPalette.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (authProvider.uid != null) {
                            Get.back();
                            // Get.toNamed(PaymentScreen.id, arguments: [
                            //   widget.movieDetailsData,
                            //   widget.theatreDetailsData,
                            //   widget.selectedDate,
                            //   widget.selectedTime,
                            //   selectedSeats,
                            // ]);
                            PaymentConfirmDialog.showCustomDialog(
                                chairList: selectedSeats,
                                movieDetailsData: widget.movieDetailsData,
                                selectedDate: widget.selectedDate,
                                selectedTime: widget.selectedTime,
                                theatreDetailsData: widget.theatreDetailsData);
                          } else {
                            if (authProvider.authStatus == "Registration") {
                              RegistrationDialog.showCustomDialog(
                                  context: context,
                                  phoneNumber: authProvider.user!.phoneNumber!,
                                  uid: authProvider.user!.uid);
                            } else if (authProvider.authStatus == "Login") {
                              LoginDialog.showCustomDialog(context);
                            }
                          }
                        },
                        child: Text(
                          "Pay ₹ ${amountNeedTopay.toStringAsFixed(2)}",
                          style:
                              CustomStyleClass.onboardingBodyTextStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10 * 2,
                          ),
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ]
              : null,
          centerTitle: true,
          title: Text(
            widget.movieDetailsData.title!,
            style: CustomStyleClass.onboardingBodyTextStyle
                .copyWith(color: Colors.white, fontSize: 10 * 2),
          ),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            width: 1200,
            child: AdaptiveScrollbar(
                controller: verticalScroll,
                width: 20,
                scrollToClickDelta: 75,
                scrollToClickFirstDelay: 200,
                scrollToClickOtherDelay: 50,
                sliderDecoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                sliderActiveDecoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                underColor: Colors.transparent,
                child: AdaptiveScrollbar(
                    // underSpacing: const EdgeInsets.only(bottom: 20),
                    controller: horizontalScroll,
                    width: 20,
                    scrollToClickDelta: 75,
                    scrollToClickFirstDelay: 200,
                    scrollToClickOtherDelay: 50,
                    position: ScrollbarPosition.bottom,
                    sliderDecoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    sliderActiveDecoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    underColor: Colors.transparent,
                    child: SingleChildScrollView(
                        controller: horizontalScroll,
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 1390,
                          child: body(),
                        )))),
          ),
        ),
      );
    });
  }

  Widget body() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                "   ₹ 110.00 - BALCONY - US".toUpperCase(),
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    fontSize: 10 * 1.6,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.secondary),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    width: 40 * 10,
                    color: Colors.white,
                    child: Center(
                      child: GridView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                          childAspectRatio: 1,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                        itemCount: topLeftChairList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChairWidget(
                            title: (index + 1).toString(),
                            selected: topLeftChairList[index].selected,
                            onTap: () {
                              _sheatOnTap(
                                  chairList: topLeftChairList, index: index);
                            },
                            occupied: topLeftChairList[index].occupied,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 40 * 14,
                    color: Colors.white,
                    child: Center(
                      child: GridView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 14,
                          childAspectRatio: 1,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                        itemCount: topCenterChairList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChairWidget(
                            title: (index + 1).toString(),
                            selected: topCenterChairList[index].selected,
                            onTap: () {
                              _sheatOnTap(
                                  chairList: topCenterChairList, index: index);
                            },
                            occupied: topCenterChairList[index].occupied,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 40 * 10,
                    color: Colors.white,
                    child: Center(
                      child: GridView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                          childAspectRatio: 1,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                        itemCount: topRightChairList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChairWidget(
                            title: (index + 1).toString(),
                            selected: topRightChairList[index].selected,
                            onTap: () {
                              _sheatOnTap(
                                  chairList: topRightChairList, index: index);
                            },
                            occupied: topRightChairList[index].occupied,
                          );
                        },
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 1 * 5,
                  // ),
                ],
              ),
            ],
          ),
          const Divider(
            height: 15,
            thickness: 1,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                "   ₹ 130.00 - Gold ",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    fontSize: 10 * 1.6,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.secondary),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    width: 40 * 10,
                    color: Colors.white,
                    child: Center(
                      child: GridView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                          childAspectRatio: 1,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                        itemCount: midLeftChairList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChairWidget(
                            title: (index + 1).toString(),
                            selected: midLeftChairList[index].selected,
                            onTap: () {
                              _sheatOnTap(
                                  chairList: midLeftChairList, index: index);
                            },
                            occupied: midLeftChairList[index].occupied,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 40 * 14,
                    color: Colors.white,
                    child: Center(
                      child: GridView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 14,
                          childAspectRatio: 1,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                        itemCount: midCenterChairList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChairWidget(
                            title: (index + 1).toString(),
                            selected: midCenterChairList[index].selected,
                            onTap: () {
                              _sheatOnTap(
                                  chairList: midCenterChairList, index: index);
                            },
                            occupied: midCenterChairList[index].occupied,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 40 * 10,
                    color: Colors.white,
                    child: Center(
                      child: GridView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                          childAspectRatio: 1,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                        itemCount: midRightChairList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChairWidget(
                            title: (index + 1).toString(),
                            selected: midRightChairList[index].selected,
                            onTap: () {
                              _sheatOnTap(
                                  chairList: midRightChairList, index: index);
                            },
                            occupied: midRightChairList[index].occupied,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(
            height: 15,
            thickness: 1,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                "   ₹ 100.00 - Silver",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    fontSize: 10 * 1.6,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.secondary),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    width: 40 * 10,
                    color: Colors.white,
                    child: Center(
                      child: GridView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                          childAspectRatio: 1,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                        itemCount: bottomLeftChairList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChairWidget(
                            title: (index + 1).toString(),
                            selected: bottomLeftChairList[index].selected,
                            onTap: () {
                              _sheatOnTap(
                                  chairList: bottomLeftChairList, index: index);
                            },
                            occupied: bottomLeftChairList[index].occupied,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 40 * 14,
                    color: Colors.white,
                    child: Center(
                      child: GridView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 14,
                          childAspectRatio: 1,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                        itemCount: bottomCenterChairList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChairWidget(
                            title: (index + 1).toString(),
                            selected: bottomCenterChairList[index].selected,
                            onTap: () {
                              _sheatOnTap(
                                  chairList: bottomCenterChairList,
                                  index: index);
                            },
                            occupied: bottomCenterChairList[index].occupied,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 40 * 10,
                    color: Colors.white,
                    child: Center(
                      child: GridView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                          childAspectRatio: 1,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                        itemCount: bottomRightChairList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChairWidget(
                            title: (index + 1).toString(),
                            selected: bottomRightChairList[index].selected,
                            onTap: () {
                              _sheatOnTap(
                                  chairList: bottomRightChairList,
                                  index: index);
                            },
                            occupied: bottomRightChairList[index].occupied,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 35,
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              // color: ColorPalette.primary,
              height: 45,
              child: Stack(
                children: [
                  Positioned(
                    right: 30,
                    left: 30,
                    bottom: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, -2),
                              color: ColorPalette.primary.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 1,
                            )
                          ],
                          color: ColorPalette.secondary.withOpacity(0.9),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.elliptical(80, 10),
                              bottomRight: Radius.elliptical(80, 10))),
                      height: 10,
                      width: 1000,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ]),
      ),
    );
  }
}

class ChairWidget extends StatefulWidget {
  final String title;
  final bool occupied;
  final bool selected;

  final Function() onTap;
  const ChairWidget({
    Key? key,
    required this.title,
    required this.selected,
    required this.onTap,
    required this.occupied,
  }) : super(key: key);

  @override
  State<ChairWidget> createState() => _ChairWidgetState();
}

class _ChairWidgetState extends State<ChairWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 5,
        width: 5,
        //padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            border: Border.all(
                color: widget.occupied ? ColorPalette.primary : Colors.green,
                width: 1),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0.7, 0.7),
                color: ColorPalette.dark.withOpacity(0.5),
              ),
            ],
            color: widget.occupied
                ? ColorPalette.primary.withOpacity(0.8)
                : widget.selected
                    ? Colors.green
                    : Colors.white,
            borderRadius: BorderRadius.circular(5)),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            widget.title,
            style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                fontSize: 10 * 1.2,
                fontWeight: FontWeight.bold,
                color: widget.occupied
                    ? ColorPalette.white
                    : widget.selected
                        ? Colors.white
                        : Colors.black),
          ),
        )),
      ),
    );
  }
}

class ChairList {
  final String id;
  final double price;
  bool selected;
  bool occupied;

  ChairList(
      {required this.id,
      required this.price,
      required this.selected,
      required this.occupied});
}

class TopLeftChairList extends ChairList {
  TopLeftChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class TopRightChairList extends ChairList {
  TopRightChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class TopCenterChairList extends ChairList {
  TopCenterChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class MidRightChairList extends ChairList {
  MidRightChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class MidLeftChairList extends ChairList {
  MidLeftChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class MidCenterChairList extends ChairList {
  MidCenterChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class BottomRightChairList extends ChairList {
  BottomRightChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class BottomLeftChairList extends ChairList {
  BottomLeftChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class BottomCenterChairList extends ChairList {
  BottomCenterChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}
