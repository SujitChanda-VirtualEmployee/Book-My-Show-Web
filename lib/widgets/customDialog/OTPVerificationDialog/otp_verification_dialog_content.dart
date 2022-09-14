import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../../utils/color_palette.dart';
import '../../../../utils/custom_styles.dart';
import '../../../utils/responsive.dart';

class OTPVerifyDialogContent extends StatefulWidget {
  final String number;
  const OTPVerifyDialogContent({Key? key, required this.number})
      : super(key: key);

  @override
  State<OTPVerifyDialogContent> createState() => _OTPVerifyDialogContentState();
}

class _OTPVerifyDialogContentState extends State<OTPVerifyDialogContent> {
  final TextEditingController _pinEditingController = TextEditingController();
  GlobalKey<ScaffoldState>? globalKey;

  String error = '';
  bool otpSubmit = false;
  final pinputFocusNode = FocusNode();

  final defaultPinTheme = PinTheme(
    width: 60,
    height: 60,
    margin: const EdgeInsets.only(left: 5, right: 5),
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(
        color: ColorPalette.secondary,
      ),
      borderRadius: BorderRadius.circular(50),
    ),
  );

  // ignore: prefer_typing_uninitialized_variables
  var focusedPinTheme;
  // ignore: prefer_typing_uninitialized_variables
  var submittedPinTheme;

  @override
  void initState() {
    super.initState();
    focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(),
    );
    submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    pinputFocusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    pinputFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Responsive.isMobile(context) ? 300 : 400,
        decoration: BoxDecoration(
            color: const Color(0xfffbfbfb),
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 10,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'OTP Verification',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: ColorPalette.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'OTP Sent to ${widget.number}',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 10.0),
            Text(
              "Enter 6 digit OTP received as SMS",
             style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: ColorPalette.secondary, fontSize: 15),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: Pinput(
                length: 6,
                focusNode: pinputFocusNode,
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsRetrieverApi,
                controller: _pinEditingController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.disabled,
                showCursor: true,
                closeKeyboardWhenCompleted: true,
                onCompleted: (pin) {
                  Navigator.of(context).pop(pin);
                },
              ),
            ),

            const SizedBox(
              height: 40,
            ),
            // _submitButton()
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Center(
      child: SizedBox(
        height: 65,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                // side: BorderSide(color: bgColor, width: 0.0),
                borderRadius: BorderRadius.circular(50)),
            elevation: 3,
            primary: ColorPalette.secondary,
          ),
          child: Text("VERIFY",
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 20, color: Colors.white, letterSpacing: 1.5)),
          onPressed: () {},
        ),
      ),
    );
  }

  void _submit(smsOtp) {
    if (smsOtp.length < 4) {
      showAlertDialog(
          context: context,
          closeButtonOnly: true,
          title: "Alert!",
          body: '\n\u2022 Please enter 4 digit OTP');
    } else if (smsOtp != "0000") {
      showAlertDialog(
          context: context,
          closeButtonOnly: false,
          title: 'Error!',
          body: '\n\u2022 Wrong OTP!  Please try again.');
    } else {
      // EasyLoading.show(status: "Verifying OTP ...");
      // Future.delayed(const Duration(milliseconds: 2000), () {
      //   EasyLoading.showSuccess(
      //     "OTP Verified!",
      //   );

      // });
      Navigator.of(context).pop(smsOtp);
    }
  }

  showAlertDialog({
    required BuildContext context,
    required String title,
    required String body,
    required bool closeButtonOnly,
  }) {
    Widget okButton = CupertinoDialogAction(
        child: Text(
          "CLOSE",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.black),
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        });
    Widget optionalButton = CupertinoDialogAction(
        child: Text(
          "OK",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.black),
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        });
    // set up the AlertDialog
    List<Widget> actionList = [];
    if (closeButtonOnly) {
      actionList.add(okButton);
    } else {
      actionList.add(okButton);
      actionList.add(optionalButton);
    }
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(title,
          style: CustomStyleClass.onboardingHeadingStyle
              .copyWith(color: ColorPalette.error)),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(body, style: Theme.of(context).textTheme.bodyText1),
        ],
      ),
      actions: actionList,
    );

    // show the dialog
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context1) {
        return alert;
      },
    );
  }
}
