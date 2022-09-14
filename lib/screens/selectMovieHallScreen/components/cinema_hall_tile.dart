import 'dart:developer';
import 'package:book_my_show_clone_web/screens/selectMovieHallScreen/components/tile_info_sheet_content.dart';
import 'package:book_my_show_clone_web/utils/custom_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import '../../../models/hall_details_model.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/miUi_animBuilder.dart';
import '../../../utils/responsive.dart';

class CinemaHallTile extends StatefulWidget {
  final CinemaHallClass data;

  final Function(String selectedTime) onTimeSelect;
  const CinemaHallTile({
    Key? key,
    required this.data,
    required this.onTimeSelect,
  }) : super(key: key);

  @override
  State<CinemaHallTile> createState() => _CinemaHallTileState();
}

class _CinemaHallTileState extends State<CinemaHallTile> {

  tileInfoCountSheet(BuildContext context) {
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return TileInfoSheetContent(
            hallData: widget.data,
          );
        }).then((val) {
      log("=============================================================");
      if (val != null) {
        if (val == true) {
          // Navigator.pushNamed(context, NewBookingDetailsScreen.id);
        }
      }
    });
  }
  tileInfoCountDialog(BuildContext context){
    return showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return  TileInfoSheetContent(
            hallData: widget.data,
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
    ).whenComplete(() {
      // Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(widget.data.hallName,
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10 * 1.8))),
                SizedBox(
                  height: 20,
                  child: TextButton.icon(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0)),
                      onPressed: () {
                        Responsive.isMobile
                        (context)?
                        tileInfoCountSheet(context):tileInfoCountDialog(context);
                      },
                      icon: Icon(
                        widget.data.covidSecure
                            ? CupertinoIcons.checkmark_shield_fill
                            : Icons.info_outline,
                        size: 15,
                        color: widget.data.covidSecure
                            ? Colors.green
                            : ColorPalette.secondary,
                      ),
                      label: Text("INFO",
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  color: ColorPalette.secondary,
                                  fontSize: 10 * 1.5))),
                )
              ],
            ),
            Visibility(
              visible: widget.data.cancellationAvailable,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text("Cancellation Available",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary, fontSize: 10 * 1.5)),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            timeList()
          ],
        ),
      ),
    );
  }

  Widget timeList() {
    List<Widget> timeWidgetList = [];

    for (int i = 0; i < widget.data.timeSlot.length; i++) {
      timeWidgetList.add(InkWell(
        onTap: () {
          if (widget.data.timeSlot[i].soldOut) {
            _showToast( " All the Tickets for this show are Sold Out ",);
          } else {
            widget.onTimeSelect(widget.data.timeSlot[i].timeSlot);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 4.9,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: ColorPalette.dark),
          ),
          child: Center(
            child: Text(widget.data.timeSlot[i].timeSlot,
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    color: widget.data.timeSlot[i].soldOut
                        ? ColorPalette.dark
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 10 * 1.6)),
          ),
        ),
      ));
    }
    return SizedBox(
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 8,
        children: timeWidgetList,
      ),
    );
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
