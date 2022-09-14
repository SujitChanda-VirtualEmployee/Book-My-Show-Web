import 'package:flutter/material.dart';

import '../../../utils/asset_images_strings.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/custom_styles.dart';

class DialogContent extends StatefulWidget {
  final String paymentId;
  const DialogContent({Key? key, required this.paymentId}) : super(key: key);

  @override
  State<DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  AssetImage? image;
  @override
  void initState() {
    image = const AssetImage(
      AssetImageClass.success,
    );

    super.initState();
  }

  @override
  void dispose() {
    image?.evict();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            color: const Color(0xfffbfbfb),
            borderRadius: BorderRadius.circular(10)),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: image!,
                    fit: BoxFit.contain,
                    alignment: Alignment.center),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Booking Successful",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    color: ColorPalette.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10 * 2.5),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Your booking has been confirmed.\nPlease reach 30 mins earlier for smooth Processing",
                textAlign: TextAlign.center,
                style: CustomStyleClass.onboardingBodyTextStyle
                    .copyWith(fontSize: 10 * 1.9),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Payment ID : ${widget.paymentId}",
                textAlign: TextAlign.center,
                style: CustomStyleClass.onboardingBodyTextStyle
                    .copyWith(fontSize: 10 * 1.9),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: ColorPalette.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Continue".toUpperCase(),
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      fontSize: 10 * 2,
                    ),
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
