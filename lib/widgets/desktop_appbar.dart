import 'package:book_my_show_clone_web/services/providerService/auth_provider.dart';
import 'package:book_my_show_clone_web/services/providerService/location_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../screens/searchScreen/search_screen.dart';
import '../utils/asset_images_strings.dart';
import '../utils/color_palette.dart';
import '../utils/custom_styles.dart';
import 'customDialog/loginDialog/login_dialog.dart';
import 'customDialog/mapDialog/map_dialog.dart';
import 'customDialog/registrationDialog/registration_dialog.dart';

class DesktopAppBarBottom extends StatelessWidget
    implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const DesktopAppBarBottom({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Consumer2<AuthProvider, LocationProvider>(
          builder: (context, authProvider, locationProvider, child) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                    height: kToolbarHeight,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Image.asset(AssetImageClass.fullAppLogo),
                    )),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      onTap: () {
                        pushNewScreenWithRouteSettings(context,
                            screen: const SearchScreen(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                            settings:
                                const RouteSettings(name: SearchScreen.id));
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.search, color: ColorPalette.dark),
                        hintText: "Search Movies, Series...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none),
                        fillColor: ColorPalette.background,
                        filled: true,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    MapDialog.showCustomDialog(context: context);
                  },
                  icon: Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey.withOpacity(0.6),
                    size: 20,
                  ),
                  label: Text(
                    locationProvider.currentLocation.locality ??
                        "Locating Address ...",
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: Colors.grey.withOpacity(0.6), fontSize: 15),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                authProvider.uid != null
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 22,
                        child: Padding(
                          padding: const EdgeInsets.all(0.5),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 21.5,
                            child: ClipRRect(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(500)),
                              child: CachedNetworkImage(
                                imageUrl: authProvider.profilePicURL!,
                                width: MediaQuery.of(context).size.width,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: Image.asset(
                                    AssetImageClass.appLogo,
                                    color: ColorPalette.dark,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Center(
                                  child: Image.asset(
                                    AssetImageClass.appLogo,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          primary: ColorPalette.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (authProvider.authStatus == "Registration") {
                            RegistrationDialog.showCustomDialog(
                                context: context,
                                phoneNumber: authProvider.user!.phoneNumber!,
                                uid: authProvider.user!.uid);
                          } else if (authProvider.authStatus == "Login") {
                            LoginDialog.showCustomDialog(context);
                          }
                        },
                        child: Text(
                          "Login / Register".toUpperCase(),
                          style:
                              CustomStyleClass.onboardingBodyTextStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      scaffoldKey.currentState!.openEndDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: ColorPalette.white,
                    )),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        );
      }),
    );
  }
}
