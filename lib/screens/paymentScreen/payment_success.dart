// import 'dart:io';
// import 'package:book_my_show_clone_web/services/providerService/auth_provider.dart';
// import 'package:book_my_show_clone_web/utils/size_config.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';
// import 'package:provider/provider.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';
// import '../../models/hall_details_model.dart';
// import '../../models/movie_details_model.dart';
// import '../../utils/asset_images_strings.dart';
// import '../../utils/color_palette.dart';
// import '../../utils/custom_styles.dart';
// import '../../utils/dashed_line.dart';
// import '../../widgets/customDialog/confirmDialog/confirm_dialog.dart';
// import '../landingScreen/landing_screen.dart';
// import '../ticketBookingScreen/ticket_booking_screen.dart';

// class PaymentSuccessScreen extends StatefulWidget {
//   static const String id = 'paymentSuccess-screen';
//   final MovieDetailsModel movieDetailsData;
//   final CinemaHallClass theatreDetailsData;
//   final DateTime selectedDate;
//   final String selectedTime;
//   final List<ChairList> chairList;
//   final String orderID;
//   const PaymentSuccessScreen({
//     Key? key,
//     required this.movieDetailsData,
//     required this.theatreDetailsData,
//     required this.selectedDate,
//     required this.selectedTime,
//     required this.chairList,
//     required this.orderID,
//   }) : super(key: key);

//   @override
//   State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
// }

// class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
//   TextEditingController pickupLoc = TextEditingController();
//   TextEditingController dropLoc = TextEditingController();
//   TextEditingController notes = TextEditingController();
//   double subtotalAmount = 0;
//   double totalPayable = 0;
//   double baseAmount = 0;
//   double gst = 0;
//   double convenienceFees = 0;
//   int bookASmileFees = 0;
//   ScreenshotController screenshotController = ScreenshotController();

//   List<String> ticketNumbers = [];
//   @override
//   void initState() {
//     calculateAmount();
//     // WidgetsBinding.instance
//     //     .addPostFrameCallback((_) => ConfirmDialog.showCustomDialog());
//     super.initState();
//   }

//   calculateAmount() {
//     for (int i = 0; i < widget.chairList.length; i++) {
//       subtotalAmount = subtotalAmount + widget.chairList[i].price;
//       ticketNumbers.add(widget.chairList[i].id);
//     }
//     gst = (18 / 100) * subtotalAmount;
//     baseAmount = (10 / 100) * subtotalAmount;
//     bookASmileFees = widget.chairList.length;
//     convenienceFees = gst + baseAmount;
//     totalPayable = convenienceFees + subtotalAmount + bookASmileFees;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         int count = 5;
//         Navigator.of(context).popUntil((_) => count-- <= 0);
//         return Future.value(false);
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: ColorPalette.background,
//         bottomSheet: SafeArea(
//           child: Container(
//             decoration: BoxDecoration(color: Colors.white, boxShadow: [
//               BoxShadow(
//                   offset: const Offset(0, -2),
//                   color: ColorPalette.secondary.withOpacity(0.1),
//                   spreadRadius: 0,
//                   blurRadius: 0),
//             ]),
//             height: 60,
//             width: MediaQuery.of(context).size.width,
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//               child: Consumer<AuthProvider>(
//                   builder: (context, dataProvider, child) {
//                 return ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       primary: ColorPalette.primary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.pushNamedAndRemoveUntil(
//                           context, LandingScreen.id, (route) => false);
//                     },
//                     child: Text(
//                       "Continue".toUpperCase(),
//                       style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
//                         color: Colors.white,
//                         letterSpacing: 1,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 10 * 2,
//                       ),
//                     ));
//               }),
//             ),
//           ),
//         ),
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: ColorPalette.background,
//           automaticallyImplyLeading: false,
//           centerTitle: true,
//           actions: [
//             IconButton(
//                 onPressed: () async {
//                   await screenshotController
//                       .capture(delay: const Duration(milliseconds: 10))
//                       .then((image) async {
//                     if (image != null) {
//                       final dir = await getApplicationDocumentsDirectory();
//                       final imagePath =
//                           await File('${dir.path}/image.png').create();
//                       await imagePath.writeAsBytes(image);
//                       await Share.shareFiles([imagePath.path],
//                           subject: "Movie Ticket",
//                           text: widget.movieDetailsData.title);
//                     }
//                   });
//                 },
//                 icon: const Icon(Icons.share_outlined))
//           ],
//           titleSpacing: 1,
//           title: Row(
//             children: [
//               Text(
//                 "   Ticket Booked   ",
//                 style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
//                   color: ColorPalette.secondary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: body(),
//       ),
//     );
//   }

//   Widget body() {
//     return Screenshot(
//       controller: screenshotController,
//       child: Container(
//         color: ColorPalette.background,
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Container(
//             decoration: BoxDecoration(
//                 color: ColorPalette.white,
//                 borderRadius: BorderRadius.circular(0)),
//             child: Stack(
//               clipBehavior: Clip.antiAlias,
//               children: [
//                 Positioned(
//                   top: MediaQuery.of(context).size.height / 6,
//                   bottom: MediaQuery.of(context).size.height / 6,
//                   left: MediaQuery.of(context).size.width / 6,
//                   right: MediaQuery.of(context).size.width / 6,
//                   child: Image.asset(
//                     AssetImageClass.appLogo,
//                     height: 1 * 30,
//                     width: 1 * 30,
//                     color: Colors.grey.shade200,
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 10,
//                   left: MediaQuery.of(context).size.width / 6,
//                   right: MediaQuery.of(context).size.width / 6,
//                   child: Image.asset(
//                     AssetImageClass.paidLogo,
//                     height: 1 * 30,
//                     width: 1 * 30,
//                     color: Colors.green,
//                   ),
//                 ),
//                 Column(mainAxisSize: MainAxisSize.min, children: [
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     height: 150,
//                     padding: const EdgeInsets.only(
//                         top: 10, bottom: 10, left: 10, right: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Row(children: [
//                             SizedBox(
//                               height: 150,
//                               width: 95,
//                               child: ClipRRect(
//                                 clipBehavior: Clip.antiAlias,
//                                 borderRadius:
//                                     const BorderRadius.all(Radius.circular(2)),
//                                 child: CachedNetworkImage(
//                                   imageUrl: widget.movieDetailsData.poster!,
//                                   width: MediaQuery.of(context).size.width,
//                                   height: double.infinity,
//                                   fit: BoxFit.fill,
//                                   placeholder: (context, url) => Center(
//                                     child: Image.asset(
//                                       AssetImageClass.appLogo,
//                                       color: ColorPalette.dark,
//                                       width: 50,
//                                       height: 50,
//                                     ),
//                                   ),
//                                   errorWidget: (context, url, error) => Center(
//                                     child: Image.asset(
//                                       AssetImageClass.appLogo,
//                                       width: 50,
//                                       height: 50,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 1 * 20,
//                             ),
//                             Expanded(
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(widget.movieDetailsData.title!,
//                                       maxLines: 2,
//                                       style: CustomStyleClass
//                                           .onboardingBodyTextStyle
//                                           .copyWith(
//                                         fontSize: 10 * 2,
//                                         fontWeight: FontWeight.bold,
//                                         color: ColorPalette.secondary,
//                                       )),
//                                   Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.favorite,
//                                         color: ColorPalette.primary,
//                                         size: 15,
//                                       ),
//                                       Text(
//                                         " ${(double.parse(widget.movieDetailsData.imdbRating!) * 10).toStringAsFixed(0)}%    ",
//                                         style: CustomStyleClass
//                                             .onboardingBodyTextStyle
//                                             .copyWith(
//                                           color: Colors.black,
//                                           fontSize: 10 * 1.5,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Text(
//                                       "${DateFormat.yMMMEd().format(widget.selectedDate)} | ${widget.selectedTime}",
//                                       style: CustomStyleClass
//                                           .onboardingBodyTextStyle
//                                           .copyWith(
//                                               color: ColorPalette.secondary,
//                                               fontSize: 10 * 1.5)),
//                                   Text(widget.theatreDetailsData.hallName,
//                                       style: CustomStyleClass
//                                           .onboardingBodyTextStyle
//                                           .copyWith(
//                                               color: ColorPalette.secondary,
//                                               fontSize: 10 * 1.5)),
//                                 ],
//                               ),
//                             )
//                           ]),
//                         ),
//                         const SizedBox(
//                           width: 5,
//                         ),
//                         RotatedBox(
//                           quarterTurns: -1,
//                           child: Text("\nM-Ticket",
//                               style: CustomStyleClass.onboardingBodyTextStyle
//                                   .copyWith(
//                                       color: ColorPalette.primary,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 10 * 1.5)),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   halfCircleDivider(),
//                   bookingDetailsSection(),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   amountSection(),
//                   const Divider(
//                     height: 10,
//                     thickness: 1,
//                   ),
//                   SizedBox(
//                     height: 90,
//                   ),
//                 ]),
//                 Positioned(
//                   top: -15,
//                   left: 10,
//                   right: 10,
//                   child: printHalfCircles(),
//                 ),
//                 Positioned(
//                   bottom: -15,
//                   left: 10,
//                   right: 10,
//                   child: printHalfCircles(),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget printHalfCircles() {
//     double totalWidth = MediaQuery.of(context).size.height - 30;
//     double remainingLength = 0;
//     double circleSize = 25;
//     List<Widget> circleList = [];

//     while (remainingLength < totalWidth) {
//       // log(remainingLength.toString());
//       circleList.add(Container(
//         margin: const EdgeInsets.symmetric(horizontal: 5),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(500),
//             color: ColorPalette.background),
//         height: 25,
//         width: 25,
//       ));
//       remainingLength = (remainingLength + circleSize * 4);
//     }

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: circleList,
//     );
//     //return Container();
//   }

//   Widget halfCircleDivider() {
//     return SizedBox(
//       height: 60,
//       width: MediaQuery.of(context).size.width,
//       child: Stack(
//         children: [
//           const Center(
//             child: MySeparator(
//               height: 1.5,
//               color: ColorPalette.background,
//               direction: Axis.horizontal,
//             ),
//           ),
//           Positioned(
//               left: -30,
//               top: 0,
//               bottom: 0,
//               child: CircleAvatar(
//                 backgroundColor: ColorPalette.background,
//                 radius: 30,
//               )),
//           Positioned(
//               right: -30,
//               top: 0,
//               bottom: 0,
//               child: CircleAvatar(
//                 backgroundColor: ColorPalette.background,
//                 radius: 30,
//               ))
//         ],
//       ),
//     );
//   }

//   Widget bookingDetailsSection() {
//     return Container(
//       height: 150,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//           color: ColorPalette.dark.withOpacity(0.4),
//           borderRadius: BorderRadius.circular(10)),
//       margin: const EdgeInsets.symmetric(horizontal: 10.0),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Container(
//               clipBehavior: Clip.antiAlias,
//               decoration: BoxDecoration(
//                   color: ColorPalette.white,
//                   borderRadius: BorderRadius.circular(10)),
//               height: 130,
//               width: 130,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: PrettyQr(
//                   image: const AssetImage(AssetImageClass.appLogo),
//                   typeNumber: 3,
//                   size: 200,
//                   data: widget.orderID,
//                   errorCorrectLevel: QrErrorCorrectLevel.M,
//                   roundEdges: true,
//                 ),
//               ),
//             ),
//             const Expanded(flex: 1, child: SizedBox()),
//             Expanded(
//               flex: 2,
//               child: SizedBox(
//                 height: 150,
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Text(
//                         "${widget.chairList.length} Ticket(s)",
//                         textAlign: TextAlign.center,
//                         style: CustomStyleClass.onboardingBodyTextStyle
//                             .copyWith(
//                                 color: ColorPalette.secondary,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 10 * 1.8),
//                       ),
//                       Text(
//                         ticketsId(),
//                         textAlign: TextAlign.center,
//                         style: CustomStyleClass.onboardingBodyTextStyle
//                             .copyWith(
//                                 color: ColorPalette.secondary,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 10 * 1.3),
//                       ),
//                       Text(
//                         widget.orderID,
//                         style: CustomStyleClass.onboardingBodyTextStyle
//                             .copyWith(
//                                 color: ColorPalette.secondary,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 1,
//                                 fontSize: 10 * 1.5),
//                       ),
//                     ]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String ticketsId() {
//     String tickets = "";
//     for (int i = 0; i < ticketNumbers.length; i++) {
//       tickets = "$tickets | ${ticketNumbers[i]}";
//     }
//     return tickets.substring(2);
//   }

//   Widget amountSection() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//       child: Column(children: [
//         SizedBox(
//           height: 8,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Sub Total',
//               style: CustomStyleClass.onboardingBodyTextStyle
//                   .copyWith(color: ColorPalette.secondary, fontSize: 10 * 1.8),
//             ),
//             Text(
//               "₹ ${subtotalAmount.toStringAsFixed(2)}",
//               style: CustomStyleClass.onboardingBodyTextStyle
//                   .copyWith(color: ColorPalette.secondary, fontSize: 10 * 1.9),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Convenience fees',
//                   style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
//                       color: ColorPalette.secondary, fontSize: 10 * 1.8),
//                 ),
//                 const Icon(
//                   Icons.arrow_drop_down_outlined,
//                   color: ColorPalette.secondary,
//                   size: 18,
//                 )
//               ],
//             ),
//             Text(
//               "₹ ${convenienceFees.toStringAsFixed(2)}",
//               style: CustomStyleClass.onboardingBodyTextStyle
//                   .copyWith(color: ColorPalette.secondary, fontSize: 10 * 1.8),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 5,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Base Amount',
//               style: CustomStyleClass.onboardingBodyTextStyle
//                   .copyWith(color: ColorPalette.dark, fontSize: 10 * 1.7),
//             ),
//             Text(
//               "₹ ${baseAmount.toStringAsFixed(2)}",
//               style: CustomStyleClass.onboardingBodyTextStyle
//                   .copyWith(color: ColorPalette.dark, fontSize: 10 * 1.7),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 5,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Integrated GST (IGST) @ 18%',
//               style: CustomStyleClass.onboardingBodyTextStyle
//                   .copyWith(color: ColorPalette.dark, fontSize: 10 * 1.7),
//             ),
//             Text(
//               "₹ ${gst.toStringAsFixed(2)}",
//               style: CustomStyleClass.onboardingBodyTextStyle
//                   .copyWith(color: ColorPalette.dark, fontSize: 10 * 1.7),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 12,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     Image.asset(
//                       AssetImageClass.appLogo,
//                       height: 18,
//                       width: 18,
//                     ),
//                     Text(
//                       ' Contribution to BookASmile',
//                       style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
//                           color: ColorPalette.secondary,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 10 * 1.5),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   '   (₹1 per ticket has been added)',
//                   style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
//                       color: ColorPalette.dark,
//                       //fontWeight: FontWeight.bold,
//                       fontSize: 10 * 1.5),
//                 ),
//               ],
//             ),
//             Text(
//               "₹ ${bookASmileFees.toStringAsFixed(2)}",
//               style: CustomStyleClass.onboardingBodyTextStyle
//                   .copyWith(color: ColorPalette.secondary, fontSize: 10 * 1.8),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         const Divider(
//           thickness: 1,
//           height: 15,
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Total Payable Amount',
//               style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
//                   color: ColorPalette.secondary,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 10 * 1.8),
//             ),
//             Text(
//               "₹ ${totalPayable.toStringAsFixed(2)}",
//               style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
//                   color: ColorPalette.secondary,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 10 * 1.8),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 15,
//         ),
//       ]),
//     );
//   }
// }
