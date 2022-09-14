import 'package:book_my_show_clone_web/screens/homeScreen/components/banners.dart';
import 'package:book_my_show_clone_web/screens/homeScreen/components/media_list_slider.dart';
import 'package:book_my_show_clone_web/screens/mapScreen/map_screen.dart';
import 'package:book_my_show_clone_web/screens/searchScreen/search_screen.dart';
import 'package:book_my_show_clone_web/services/providerService/location_provider.dart';
import 'package:book_my_show_clone_web/utils/color_palette.dart';
import 'package:book_my_show_clone_web/utils/custom_styles.dart';
import 'package:book_my_show_clone_web/utils/enum_classes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../../utils/responsive.dart';
import '../../widgets/desktop_appbar.dart';
import '../../widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const MyDrawer(),
      backgroundColor: ColorPalette.background,
    
      appBar: Responsive.isMobile(context)
          ? AppBar(
              elevation: 0,
              backgroundColor: ColorPalette.secondary,
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: SizedBox(
                height: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "It All Started Here",
                      style: CustomStyleClass.onboardingBodyTextStyle
                          .copyWith(color: Colors.white, fontSize: 18),
                    ),
                    Expanded(
                      child: Consumer<LocationProvider>(
                          builder: (context, locProvider, child) {
                        return GestureDetector(
                          onTap: () {
                            pushNewScreenWithRouteSettings(context,
                                screen: const MapScreen(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                                settings:
                                    const RouteSettings(name: MapScreen.id));
                          },
                          child: Row(
                            children: [
                              Text(
                                locProvider.currentLocation.locality ??
                                    "Locating Address ...  ",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                        color: Colors.grey.withOpacity(0.6),
                                        letterSpacing: 0.6,
                                        fontSize: 10 * 1.5),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.grey.withOpacity(0.6),
                                size: 10,
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      pushNewScreenWithRouteSettings(context,
                          screen: const SearchScreen(),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                          settings: const RouteSettings(name: SearchScreen.id));
                    },
                    icon: const Icon(
                      CupertinoIcons.search,
                      color: ColorPalette.white,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.bell,
                      color: ColorPalette.white,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.qrcode_viewfinder,
                      color: ColorPalette.white,
                    ))
              ],
            )
          : AppBar(
              elevation: 0,
              backgroundColor: ColorPalette.secondary,
              automaticallyImplyLeading: false,
              centerTitle: false,
               toolbarHeight: kToolbarHeight -20,
              flexibleSpace: Container(color: ColorPalette.secondary),
              bottom: DesktopAppBarBottom(scaffoldKey: scaffoldKey),
              actions: const [SizedBox()],
            ),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: const [
          SizedBox(height: 10),
          Sliders(),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: MediaListSlider(
              title: 'Recommended Movies',
              mediaType: MediaType.movies,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: MediaListSlider(
              title: 'Popular Series',
              mediaType: MediaType.series,
            ),
          )
        ],
      ),
    );
  }
}
