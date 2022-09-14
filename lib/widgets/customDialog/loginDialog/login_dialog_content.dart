import 'package:book_my_show_clone_web/utils/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../utils/color_palette.dart';
import '../../../utils/custom_styles.dart';



class LoginDialogContent extends StatefulWidget {
  const LoginDialogContent({Key? key}) : super(key: key);

  @override
  State<LoginDialogContent> createState() => _LoginDialogContentState();
}

class _LoginDialogContentState extends State<LoginDialogContent> {
  final SmsAutoFill autoFill = SmsAutoFill();
  TextEditingController phoneNumberController = TextEditingController();
  late String completePhoneNumber;
  bool isValid2 = false;
  bool isValid = false;

  String? validateMobile(String value) {
    if (value.isEmpty) {
      return "*Mobile Number is Required";
    } else if (value.length < 10 || value.length > 10) {
      return "*Enter valid Number";
    } else {
      return null;
    }
  }

  Future<void> validatePhone() async {
    if (kDebugMode) {
      print("in validate : ${phoneNumberController.text.length}");
    }
    if (phoneNumberController.text.length > 9 &&
        phoneNumberController.text.length < 11) {
      setState(() {
        isValid = true;
      });
      if (kDebugMode) {
        print(isValid);
      }
    } else {
      setState(() {
        isValid = false;
      });
    }
  }

  @override   
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Responsive.isMobile(context) ? 400 : 400,
        decoration: BoxDecoration(
            color: ColorPalette.background,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: false).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  )),
            ),
            const SizedBox(height: 10),
            Text.rich(
                TextSpan(
                    text: 'Register or Login\n',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: ColorPalette.primary,
                          fontWeight: FontWeight.bold,
                        ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: '\nwith Mobile Number',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.secondary,
                            ),
                      ),
                    ]),
                textAlign: TextAlign.center),
            const SizedBox(height: 40.0),
            Text(
              "* You need to verify your Phone Number via OTP Verification process to Register / Login to your account.",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: ColorPalette.secondary, fontSize: 15),
            ),
            const SizedBox(height: 40.0),
            TextFormField(
              validator: (val) => validateMobile(val!),
              style:
                  Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                
                isDense: true,
                contentPadding: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 15, right: 15),
                prefix: Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("+91",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey,
                            fontSize: 20,
                          )),
                ),
                
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                      width: 0.2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    gapPadding: 1),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 0.5,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
                labelText: " Mobile Number",
                labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 20,
                    ),
                hintText: 'Mobile Number *',
                hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 20,
                    ),
              ),
              //maxLength: 10,

              keyboardType: TextInputType.phone,

              controller: phoneNumberController,
              autofocus: true,
              onChanged: (text) {
                validatePhone();
              },
              autovalidateMode: AutovalidateMode.always,
              autocorrect: false,
            ),
            const SizedBox(
              height: 50,
            ),
            AbsorbPointer(
              absorbing: !(phoneNumberController.text.length > 9 &&
                  phoneNumberController.text.length < 11),
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: (phoneNumberController.text.length > 9 &&
                              phoneNumberController.text.length < 11)
                          ? ColorPalette.primary
                          : ColorPalette.dark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (kDebugMode) {
                        print("IsValid : $isValid");
                        print("IsValid2 : $isValid2");
                      }

                     
                      Navigator.of(context, rootNavigator: true).pop(phoneNumberController.text);
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
