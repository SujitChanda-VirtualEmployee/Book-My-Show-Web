import 'package:book_my_show_clone_web/utils/color_palette.dart';
import 'package:flutter/material.dart';
import '../../utils/custom_styles.dart';

class BuzzScreen extends StatefulWidget {
  static const String id = "buzz-screen";
  const BuzzScreen({Key? key}) : super(key: key);

  @override
  State<BuzzScreen> createState() => _BuzzScreenState();
}

class _BuzzScreenState extends State<BuzzScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.secondary,
        centerTitle: false,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "BUZZ",
              style: CustomStyleClass.onboardingBodyTextStyle
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(
              "Discover what's trending in entertainment ",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: Colors.grey.withOpacity(0.6), fontSize: 10 * 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
