import 'package:book_my_show_clone_web/screens/mapScreen/map_screen.dart';
import 'package:book_my_show_clone_web/screens/splashScreen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/providerService/auth_provider.dart';
import '../../../services/providerService/location_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/custom_styles.dart';

class AccountSettingScreen extends StatefulWidget {
  static const String id = "account_setting_screen";
  const AccountSettingScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  String onlineStatus = "You won't get notifications from Book My Show";

  @override
  void initState() {
    // if (preferences!.getBool('_userNotificationStatus')!) {
    //   onlineStatus = "You will get notifications from Book My Show";
    // } else {
    //   onlineStatus = "You won't get notifications from Book My Show";
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorPalette.secondary,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorPalette.white,
            )),
        centerTitle: true,
        title: Text(
          "Account & Settings",
          style: CustomStyleClass.onboardingBodyTextStyle
              .copyWith(color: ColorPalette.white, fontSize: 10 * 2),
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Column(
      children: [
        const SizedBox(
          height: 18,
        ),
        ListTile(
          leading: const Icon(
            Icons.my_location_rounded,
            color: Colors.black,
            size: 35,
          ),
          tileColor: ColorPalette.white,
          dense: true,
          onTap: () {
            Navigator.pushNamed(context, MapScreen.id);
          },
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
            size: 25,
          ),
          title: Text('My Location',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10 * 2)),
          subtitle: Consumer<LocationProvider>(
              builder: (context, locProvider, child) {
            return Text(
               locProvider.currentLocation.locality?? "Locating Address...",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    color: ColorPalette.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10 * 1.5));
          }),
        ),
        
        const Divider(
          thickness: 1,
          height: 0,
        ),
        ListTile(
          leading: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.black,
            size: 35,
          ),
          tileColor: ColorPalette.white,
          dense: true,
          onTap: () {
            Navigator.pushNamed(context, MapScreen.id);
          },
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
            size: 25,
          ),
          title: Text('Delete My Account',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10 * 2)),
          subtitle: Text("Your Account will be deleted Permanently",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10 * 1.5)),
        ),
        const Divider(
          thickness: 1,
          height: 0,
        ),
        ListTile(
          leading: const Icon(
            Icons.power_settings_new_rounded,
            color: Colors.black,
            size: 35,
          ),
          tileColor: ColorPalette.white,
          dense: true,
          onTap: () {
            showDialog();
          },
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
            size: 25,
          ),
          title: Text('Sign Out',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10 * 2)),
          subtitle: Text("Sign out from Current Account",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10 * 1.5)),
        ),
      ],
    );
  }

  showDialog() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Confirm Logout?',
                style: TextStyle(
                    color: ColorPalette.primary,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.bold)),
            content: const Text('\nAre you sure you want to Logout?\n',
                style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 0.6,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
            actions: [
              CupertinoDialogAction(
                  child: Text(
                    "NO",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(false);
                  }),
              CupertinoDialogAction(
                  child: Text(
                    "YES",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(true);
                  })
            ],
          );
        }).then((value) {
      if (value != null && value == true) {
        FirebaseAuth.instance.signOut().then((value) {
          Provider.of<AuthProvider>(context, listen: false).resetAuth();
        Navigator.pushNamedAndRemoveUntil(
            context, SplashScreen.id, (route) => false);

        });
     
         
      }
    });
  }
}
