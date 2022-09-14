import 'package:book_my_show_clone_web/screens/splashScreen/splash_screen.dart';
import 'package:book_my_show_clone_web/services/providerService/api_data_provider.dart';
import 'package:book_my_show_clone_web/services/providerService/auth_provider.dart';
import 'package:book_my_show_clone_web/services/providerService/connectivity_provider.dart';
import 'package:book_my_show_clone_web/services/providerService/location_provider.dart';
import 'package:book_my_show_clone_web/utils/app_theme.dart';
import 'package:book_my_show_clone_web/utils/color_palette.dart';
import 'package:book_my_show_clone_web/utils/miUi_animBuilder.dart';
import 'package:book_my_show_clone_web/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configLoading();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBrl6QNHq1vdgvS9V353HliV9r3LJMJfxA",
        appId: "1:957120408982:web:0e690dea8674c2c2b9c1b7",
        messagingSenderId: "957120408982",
        projectId: "bookmyshowclone-db2ce",
        storageBucket: "gs://bookmyshowclone-db2ce.appspot.com"
      ),
    );
  }

  // Stripe.publishableKey =
  //     "pk_test_51BTUDGJAJfZb9HEBwDg86TN1KNprHjkfipXmEDMb0gSCassK5T3ZfxsAbcgKVmAIXF7oZ6ItlZZbXO6idTHE67IM007EwQ4uN3";
  // Stripe.merchantIdentifier = "Book My Show";
  // await Stripe.instance.applySettings();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ApiDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..indicatorWidget = Container(
      padding: const EdgeInsets.all(5),
      child: const CupertinoActivityIndicator(
        color: Colors.white,
        radius: 20,
      ),
    )
    ..radius = 8.0
    ..boxShadow = [
      const BoxShadow(
          offset: Offset(0.7, 0.7),
          color: ColorPalette.secondary,
          blurRadius: 2,
          spreadRadius: 2)
    ]
    ..maskColor = ColorPalette.secondary.withOpacity(0.3)
    ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: ColorPalette.secondary,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return OKToast(
       textStyle: const TextStyle(fontSize: 19.0, color: Colors.white),
      backgroundColor: Colors.grey,
      radius: 10.0,
      animationCurve: Curves.easeIn,
      animationBuilder: const Miui10AnimBuilder(),
      animationDuration: const Duration(milliseconds: 200),
      duration: const Duration(seconds: 3),
      child: GetMaterialApp(
        title: 'Book My Show',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
         scrollBehavior: MyCustomScrollBehavior(),
        builder: EasyLoading.init(),
    
        home: const SplashScreen(),
        onGenerateRoute: RouteGenerator.generateRoutes,
      ),
    );
  }
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}