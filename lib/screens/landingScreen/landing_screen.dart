import 'package:book_my_show_clone_web/services/providerService/location_provider.dart';
import 'package:book_my_show_clone_web/utils/asset_images_strings.dart';
import 'package:book_my_show_clone_web/utils/color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../../services/firebaseServices/push_notification_service.dart';
import '../../utils/responsive.dart';
import '../../widgets/customDialog/loginDialog/login_dialog.dart';
import '../../widgets/customDialog/registrationDialog/registration_dialog.dart';
import '../buzzScreen/buzz_screen.dart';
import '../homeScreen/home_screen.dart';
import '../profileScreen/profile_screen.dart';

class LandingScreen extends StatefulWidget {
  static const String id = "landing-screen";
  final User? user;
  final String status;
  const LandingScreen({Key? key, required this.user, required this.status})
      : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey =  GlobalKey<ScaffoldState>();
  late PersistentTabController controller;
  late bool hideNavBar;
  late FirebaseNotifcation firebase;
 late LocationProvider locationProvider;
  List<Widget> _buildScreen() {
    return const [
      HomeScreen(),
      BuzzScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const ImageIcon(
          AssetImage(
            AssetImageClass.appLogo,
          ),
          size: 30,
        ),
        title: "Home",
        activeColorPrimary: ColorPalette.primary,
        inactiveColorPrimary: ColorPalette.secondary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.dot_radiowaves_right),
        title: "Buzz",
        activeColorPrimary: ColorPalette.primary,
        inactiveColorPrimary: ColorPalette.secondary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_sharp),
        title: "Add",
        activeColorPrimary: ColorPalette.primary,
        inactiveColorPrimary: ColorPalette.secondary,
      ),
    ];
  }

  handleAsync() async {
    await firebase.initialize(context);
    // await firebase.subscribeToTopic('user');
    // ignore: use_build_context_synchronously
   // await firebase.getToken(context);
  }

  initDialog() {
    if (widget.status == "Registration") {
      RegistrationDialog.showCustomDialog(
          context: context,
          phoneNumber: widget.user!.phoneNumber!,
          uid: widget.user!.uid);
    } else if (widget.status == "Login") {
      LoginDialog.showCustomDialog(context);
    }
  }

  @override
  void initState() {
   
    locationProvider = Provider.of<LocationProvider>(context, listen: false);
    locationProvider.getCurrentPosition();
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
    hideNavBar = false;
    firebase = FirebaseNotifcation(context: context);
    handleAsync();
    WidgetsBinding.instance.addPostFrameCallback((_) => initDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: PersistentTabView(
          context,
          navBarHeight: Responsive.isMobile(context) ? 60 : 0,
          controller: controller,
          screens: _buildScreen(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          stateManagement: true,
          resizeToAvoidBottomInset: true,
          hideNavigationBarWhenKeyboardShows: true,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(0),
            colorBehindNavBar: ColorPalette.white,
            border: Border.all(color: Colors.black45),
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(microseconds: 200),
          ),
          navBarStyle: NavBarStyle.style12,
        ));
  }
}
