import 'package:book_my_show_clone_web/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/color_palette.dart';
import '../../../../utils/custom_styles.dart';

// ignore: must_be_immutable
class DobPickerSheetContent extends StatefulWidget {
  const DobPickerSheetContent({
    Key? key,
  }) : super(key: key);

  @override
  State<DobPickerSheetContent> createState() => _DobPickerSheetContentState();
}

class _DobPickerSheetContentState extends State<DobPickerSheetContent> {
  DateTime? chosenDateTime;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: Responsive.isMobile(context) ? null : 500,
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(chosenDateTime);
                      },
                      child: Text(
                        "Cancel",
                        style:
                            CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10 * 2,
                        ),
                      )),
                  Visibility(
                      visible: chosenDateTime != null,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(chosenDateTime);
                          },
                          child: Text(
                            "Done",
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                              color: ColorPalette.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10 * 2,
                            ),
                          )))
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: ColorPalette.background,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  dateOrder: DatePickerDateOrder.dmy,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (val) {
                    setState(() {
                      chosenDateTime = val;
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
