import 'package:book_my_show_clone_web/utils/asset_images_strings.dart';
import 'package:book_my_show_clone_web/utils/custom_styles.dart';
import 'package:flutter/material.dart';

class EmptyScreen extends StatefulWidget {
  const EmptyScreen({Key? key}) : super(key: key);

  @override
  State<EmptyScreen> createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AssetImageClass.empty),
            const SizedBox(
              height: 30,
            ),
            Text("No History Available!",
                style: CustomStyleClass.onboardingBodyTextStyle),
          ],
        ),
      )),
    );
  }
}
