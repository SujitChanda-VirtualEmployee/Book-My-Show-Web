import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../models/purchase_history_model.dart';
import '../screens/profileScreen/purchaseHistoryScreen/components/purchase_history_tile.dart';
import '../screens/splashScreen/splash_screen.dart';
import '../services/firebaseServices/firebase_services.dart';
import '../services/providerService/auth_provider.dart';
import '../services/providerService/location_provider.dart';
import '../utils/asset_images_strings.dart';
import '../utils/color_palette.dart';
import '../utils/custom_styles.dart';
import 'customDialog/editProfileDialog/edit_profile_dialog.dart';
import 'customDialog/mapDialog/map_dialog.dart';
import 'custom_expansion_tile.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  FirebaseServices firebaseServices = FirebaseServices();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, dataProvider, child) {
      return Drawer(
        width: 430,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                elevation: 4,
                child: Container(
                  height: 95,
                  color: ColorPalette.secondary,
                  width: double.infinity,
                  child: dataProvider.uid == null
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text("Hey!",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: ColorPalette.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hi ${dataProvider.userName} !",
                                        style: CustomStyleClass
                                            .onboardingBodyTextStyle
                                            .copyWith(color: Colors.white),
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: ColorPalette.secondary,
                                          child: InkWell(
                                            onTap: () {
                                              EditProfileDialog
                                                  .showCustomDialog();
                                              // pushNewScreenWithRouteSettings(
                                              //   context,
                                              //   screen:
                                              //       const EditProfileScreen(),
                                              //   settings: const RouteSettings(
                                              //       name: EditProfileScreen.id),
                                              //   withNavBar: false,
                                              //   pageTransitionAnimation:
                                              //       PageTransitionAnimation
                                              //           .cupertino,
                                              // ).then((value) {
                                              //   setState(() {});
                                              // });
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Edit Profile ",
                                                  style: CustomStyleClass
                                                      .onboardingBodyTextStyle
                                                      .copyWith(
                                                          color: Colors
                                                              .grey.shade500,
                                                          letterSpacing: 0.5,
                                                          fontSize: 8 * 1.5),
                                                ),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
                                                  size: 10,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                    ],
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 22,
                                child: Padding(
                                  padding: const EdgeInsets.all(0.5),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 21.5,
                                    child: ClipRRect(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(500)),
                                      child: CachedNetworkImage(
                                        imageUrl: dataProvider.profilePicURL!,
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                        errorWidget: (context, url, error) =>
                                            Center(
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
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              sliverUpperSection(dataProvider)
            ],
          ),
        ),
      );
    });
  }

  Widget sliverUpperSection(AuthProvider dataProvider) {
    return SingleChildScrollView(
        child: Stack(
      children: [
        Column(
          children: [
            // Visibility(
            //   visible: dataProvider.uid == null,
            //   child: Card(
            //     margin: EdgeInsets.zero,
            //     elevation: 5,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(0.0),
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(
            //           horizontal: 12.0, vertical: 12),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           CircleAvatar(
            //             backgroundColor: ColorPalette.primary,
            //             radius: 22,
            //             child: Padding(
            //               padding: const EdgeInsets.all(0.5),
            //               child: CircleAvatar(
            //                 backgroundColor: Colors.white,
            //                 radius: 21.5,
            //                 child: ClipRRect(
            //                     clipBehavior: Clip.antiAliasWithSaveLayer,
            //                     borderRadius: const BorderRadius.all(
            //                         Radius.circular(500)),
            //                     child: Padding(
            //                       padding: const EdgeInsets.all(4.0),
            //                       child: Image.asset(
            //                         AssetImageClass.appLogo,
            //                         width: 50,
            //                         height: 50,
            //                       ),
            //                     )),
            //               ),
            //             ),
            //           ),
            //           Expanded(
            //             child: Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //               child: Text(
            //                   "Unlock special offers and great benefits",
            //                   style: CustomStyleClass.onboardingBodyTextStyle
            //                       .copyWith(
            //                     color: ColorPalette.secondary,
            //                     fontWeight: FontWeight.normal,
            //                     fontSize: 16,
            //                   )),
            //             ),
            //           ),
            //           ElevatedButton(
            //               style: ElevatedButton.styleFrom(
            //                 primary: ColorPalette.white,
            //                 padding: const EdgeInsets.symmetric(
            //                     horizontal: 15, vertical: 20),
            //                 shape: RoundedRectangleBorder(
            //                   side: const BorderSide(
            //                       color: ColorPalette.primary, width: 1),
            //                   borderRadius: BorderRadius.circular(8),
            //                 ),
            //               ),
            //               onPressed: () {
            //                 Navigator.pop(context);
            //                 if (dataProvider.authStatus == "Registration") {
            //                   RegistrationDialog.showCustomDialog(
            //                       context: context,
            //                       phoneNumber: dataProvider.user!.phoneNumber!,
            //                       uid: dataProvider.user!.uid);
            //                 } else if (dataProvider.authStatus == "Login") {
            //                   LoginDialog.showCustomDialog(context);
            //                 }
            //               },
            //               child: Text(
            //                 "Login / Register".toUpperCase(),
            //                 style: CustomStyleClass.onboardingBodyTextStyle
            //                     .copyWith(
            //                   color: ColorPalette.primary,
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: 14,
            //                 ),
            //               )),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 18,
            ),
            Container(
              color: ColorPalette.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomExpansionTile(
                    iconColor: dataProvider.uid == null
                        ? ColorPalette.dark
                        : ColorPalette.secondary,
                    collapsedIconColor: dataProvider.uid == null
                        ? ColorPalette.dark
                        : ColorPalette.secondary,
                    backgroundColor: ColorPalette.background,
                    leading: Icon(
                      Icons.shopping_cart_checkout_rounded,
                      color: dataProvider.uid == null
                          ? ColorPalette.dark
                          : ColorPalette.secondary,
                      //  size: 20,
                    ),
                    title: Text('Purchase History',
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: dataProvider.uid == null
                                    ? ColorPalette.dark
                                    : ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 2)),
                    subtitle: Text("View all your booking and purchases",
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: dataProvider.uid == null
                                    ? ColorPalette.dark
                                    : ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 1.4)),
                    children: dataProvider.uid == null
                        ? []
                        : [
                            FutureBuilder(
                              future: firebaseServices.booking
                                  .where("customerID",
                                      isEqualTo: firebaseAuth.currentUser!.uid)
                                  .get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(AssetImageClass.empty),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text("No History Available!",
                                            style: CustomStyleClass
                                                .onboardingBodyTextStyle),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CupertinoActivityIndicator(
                                        animating: true,
                                        color: ColorPalette.secondary),
                                  );
                                }
                                if (snapshot.data!.size == 0) {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(AssetImageClass.empty),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text("No History Available!",
                                            style: CustomStyleClass
                                                .onboardingBodyTextStyle),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                log(snapshot.data!.size.toString());

                                return ListView.separated(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: snapshot.data!.size,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return PurchaseHistoryTile(
                                        model: purchaseHistoryModelFromJson(
                                            jsonEncode(snapshot
                                                .data!.docs[index]
                                                .data())));
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(
                                      height: 20,
                                    );
                                  },
                                );
                              },
                            )
                          ],
                  ),
                  const Divider(
                    thickness: 1,
                    height: 0,
                  ),
                  ListTile(
                    dense: true,
                    onTap: () {},
                    leading: const Icon(
                      Icons.video_library_outlined,
                      color: ColorPalette.secondary,
                      //  size: 20,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorPalette.secondary,
                      size: 20,
                    ),
                    title: Text('Stream Library',
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 2)),
                    subtitle: Text("Rented, Purchased and Downloaded movies",
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 1.4)),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 0,
                  ),
                  ListTile(
                    tileColor: ColorPalette.primary,
                    dense: true,
                    onTap: () {},
                    leading: const Icon(
                      Icons.messenger_outline,
                      color: ColorPalette.secondary,
                      //  size: 20,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorPalette.secondary,
                      size: 20,
                    ),
                    title: Text('Help & Support',
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 2)),
                    subtitle: Text("View commonly asked questions and Chat",
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 1.5)),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 0,
                  ),
                  CustomExpansionTile(
                    childrenPadding: EdgeInsets.zero,
                    iconColor: dataProvider.uid == null
                        ? ColorPalette.dark
                        : ColorPalette.secondary,
                    collapsedIconColor: dataProvider.uid == null
                        ? ColorPalette.dark
                        : ColorPalette.secondary,
                    backgroundColor: ColorPalette.background,
                    leading: Icon(
                      Icons.settings_outlined,
                      color: dataProvider.uid == null
                          ? ColorPalette.dark
                          : ColorPalette.secondary,
                      //  size: 20,
                    ),

                    title: Text('Accounts & Settings',
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: dataProvider.uid == null
                                    ? ColorPalette.dark
                                    : ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 2)),
                    subtitle: Text("View or Edit your account Details",
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: dataProvider.uid == null
                                    ? ColorPalette.dark
                                    : ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 1.4)),

                    // onTap: () {
                    //   pushNewScreenWithRouteSettings(
                    //     context,
                    //     screen: const AccountSettingScreen(),
                    //     settings:
                    //         const RouteSettings(name: AccountSettingScreen.id),
                    //     withNavBar: false,
                    //     pageTransitionAnimation:
                    //         PageTransitionAnimation.cupertino,
                    //   );
                    // },
                    children: dataProvider.uid == null ? [] : accountBodyList(),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 0,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Container(
              color: ColorPalette.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    tileColor: ColorPalette.primary,
                    //  dense: true,
                    onTap: () {},
                    leading: const Icon(
                      Icons.discount_outlined,
                      color: ColorPalette.secondary,
                      //  size: 20,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorPalette.secondary,
                      size: 20,
                    ),
                    title: Text('Restaurant Discounts',
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 2)),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 0,
                  ),
                  ListTile(
                    tileColor: ColorPalette.primary,
                    // dense: true,
                    onTap: () {},
                    leading: const Icon(
                      CupertinoIcons.tickets,
                      color: ColorPalette.secondary,
                      //  size: 20,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorPalette.secondary,
                      size: 20,
                    ),
                    title: Text('Discount Store',
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 2)),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 0,
                  ),
                  ListTile(
                    tileColor: ColorPalette.primary,
                    dense: true,
                    onTap: () {},
                    leading: const Icon(
                      CupertinoIcons.gift,
                      color: ColorPalette.secondary,
                      //  size: 20,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorPalette.secondary,
                      size: 20,
                    ),
                    title: Text('Rewards',
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 2)),
                    subtitle: Text("View your rewars & unlock new ones",
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 1.5)),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 0,
                  ),
                  ListTile(
                    tileColor: ColorPalette.primary,
                    //dense: true,
                    onTap: () {},
                    leading: const Icon(
                      CupertinoIcons.checkmark_seal,
                      color: ColorPalette.secondary,
                      //  size: 20,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorPalette.secondary,
                      size: 20,
                    ),
                    title: Text('Offers',
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 2)),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 0,
                  ),
                  ListTile(
                    tileColor: ColorPalette.primary,
                    //dense: true,
                    onTap: () {},
                    leading: const Icon(
                      CupertinoIcons.gift_alt,
                      color: ColorPalette.secondary,
                      //  size: 20,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorPalette.secondary,
                      size: 20,
                    ),
                    title: Text('Gift Cards',
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 2)),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 0,
                  ),
                  ListTile(
                    tileColor: ColorPalette.primary,
                    //dense: true,
                    onTap: () {},
                    leading: const Icon(
                      Icons.fastfood_outlined,
                      color: ColorPalette.secondary,
                      //  size: 20,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorPalette.secondary,
                      size: 20,
                    ),
                    title: Text('Food & Beverages',
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 2)),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 0,
                  ),
                  ListTile(
                    tileColor: ColorPalette.primary,
                    //dense: true,
                    onTap: () {},
                    leading: const Icon(
                      Icons.broadcast_on_home_rounded,
                      color: ColorPalette.secondary,
                      //  size: 20,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorPalette.secondary,
                      size: 20,
                    ),
                    title: Text('List Your Show',
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 8 * 2)),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }

  List<Widget> accountBodyList() {
    return [
      ListTile(
        leading: const Icon(
          Icons.my_location_rounded,
          color: ColorPalette.secondary,
          size: 20,
        ),
        tileColor: ColorPalette.background,
        dense: true,
        onTap: () {
          MapDialog.showCustomDialog(context: context);
          //  Navigator.pushNamed(context, MapScreen.id);
        },
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: ColorPalette.secondary,
          size: 15,
        ),
        title: Text('My Location',
            style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                color: ColorPalette.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 7 * 2)),
        subtitle:
            Consumer<LocationProvider>(builder: (context, locProvider, child) {
          return Text(
              locProvider.currentLocation.locality ?? "Locating Address...",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 8 * 1.4));
        }),
      ),
      const Divider(
        thickness: 1,
        height: 0,
      ),
      ListTile(
        leading: const Icon(
          Icons.delete_outline_rounded,
          size: 20,
          color: ColorPalette.secondary,
        ),
        tileColor: ColorPalette.background,
        dense: true,
        onTap: () {
          // Navigator.pushNamed(context, MapScreen.id);
          MapDialog.showCustomDialog(context: context);
        },
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: ColorPalette.secondary,
          size: 15,
        ),
        title: Text('Delete My Account',
            style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                color: ColorPalette.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 7 * 2)),
        subtitle: Text("Your Account will be deleted Permanently",
            style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                color: ColorPalette.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 8 * 1.4)),
      ),
      const Divider(
        thickness: 1,
        height: 0,
      ),
      ListTile(
        leading: const Icon(
          Icons.power_settings_new_rounded,
          color: ColorPalette.secondary,
          size: 20,
        ),
        tileColor: ColorPalette.background,
        dense: true,
        onTap: () {
          showDialog();
        },
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: ColorPalette.secondary,
          size: 15,
        ),
        title: Text('Sign Out',
            style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                color: ColorPalette.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 7 * 2)),
        subtitle: Text("Sign out from Current Account",
            style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                color: ColorPalette.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 8 * 1.4)),
      ),
    ];
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
                    color: ColorPalette.secondary,
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
                        .copyWith(color: ColorPalette.secondary),
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
                        .copyWith(color: ColorPalette.secondary),
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
          Get.offAllNamed(
            SplashScreen.id,
          );
        });
      }
    });
  }
}
