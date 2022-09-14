import 'package:book_my_show_clone_web/services/providerService/auth_provider.dart';
import 'package:book_my_show_clone_web/utils/asset_images_strings.dart';
import 'package:book_my_show_clone_web/utils/color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firebaseServices/firebase_services.dart';
import '../../services/providerService/connectivity_provider.dart';
import '../landingScreen/landing_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  AuthProvider authProvider = AuthProvider();
  FirebaseServices services = FirebaseServices();
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (FirebaseAuth.instance.currentUser != null) {
        services.getUserById(user!.uid).then((snapShot) {
          if (snapShot!= null && snapShot.exists) {
            authProvider.saveUserDetails(
              uid: '${snapShot['id']}',
              email: '${snapShot['email']}',
              token: '${snapShot['token']}',
              userName: '${snapShot['name']}',
              userDoB: '${snapShot['user_dob']}',
              identity: snapShot['identity'],
              married: snapShot['married'],
              phoneNumber: '${snapShot['number']}',
              profilePicURL: '${snapShot['profile_Pic_URL']}',
            );
            authProvider.setAuthStatus(user: user, authStatus: "allSet");
            Navigator.pushReplacementNamed(context, LandingScreen.id,
                arguments: [user, "allSet"]);
          } else {
            if (kDebugMode) {
              print("Registration needed");
            }
            authProvider.setAuthStatus(user: user, authStatus: "Registration");
            Navigator.pushReplacementNamed(context, LandingScreen.id,
                arguments: [user, "Registration"]);

            // RegistrationDialog.showCustomDialog(
            //         context: context,
            //         phoneNumber: user!.phoneNumber!,
            //         uid: user!.uid);
          }
        });
      } else {
        authProvider.setAuthStatus(user: user, authStatus: "Login");
        Navigator.pushReplacementNamed(context, LandingScreen.id,
            arguments: [user, "Login"]);
        if (kDebugMode) {
          print("WELCOME SCREEN");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Image.asset(
            AssetImageClass.splashAppLogo,
            width: MediaQuery.of(context).size.width / 1,
          ),
        ),
      ),
    );
  }
}
