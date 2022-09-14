import 'dart:developer';
import 'package:book_my_show_clone_web/services/firebaseServices/firebase_services.dart';
import 'package:book_my_show_clone_web/services/providerService/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_web/razorpay_web.dart';
import '../../models/hall_details_model.dart';
import '../../models/movie_details_model.dart';
import '../../services/providerService/location_provider.dart';
import '../../utils/asset_images_strings.dart';
import '../../utils/color_palette.dart';
import '../../utils/custom_styles.dart';
import '../../utils/dashed_line.dart';
import '../../utils/miUi_animBuilder.dart';
import '../../widgets/customDialog/confirmDialog/confirm_dialog.dart';
import '../ticketBookingScreen/ticket_booking_screen.dart';

class PaymentScreen extends StatefulWidget {
  static const String id = 'payment-screen';
  final MovieDetailsModel movieDetailsData;
  final CinemaHallClass theatreDetailsData;
  final DateTime selectedDate;
  final String selectedTime;
  final List<ChairList> chairList;
  const PaymentScreen({
    Key? key,
    required this.movieDetailsData,
    required this.theatreDetailsData,
    required this.selectedDate,
    required this.selectedTime,
    required this.chairList,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController pickupLoc = TextEditingController();
  TextEditingController dropLoc = TextEditingController();
  TextEditingController notes = TextEditingController();

  String? phone, email;
  late Razorpay _razorpay;
  double subtotalAmount = 0;
  double totalPayable = 0;
  double baseAmount = 0;
  double gst = 0;
  double convenienceFees = 0;
  int bookASmileFees = 0;
  FirebaseServices firebaseServices = FirebaseServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthProvider authProvider = AuthProvider();

  String tickets = "";
  @override
  void initState() {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    phone = authProvider.phoneNumber;
    email = authProvider.email;

    calculateAmount();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_J0dMlFPU3ymav2',
      'amount': (totalPayable * 100).toInt(),
      'name': widget.movieDetailsData.title!,
      'description': widget.theatreDetailsData.hallName,
      'send_sms_hash': true,
      'prefill': {'contact': phone, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  static displaySnackNat(String body) {
    // Fluttertoast.cancel();
    return showToast(
      " $body ",
      position: ToastPosition.bottom,
      backgroundColor: Colors.red.withOpacity(0.8),
      radius: 13.0,
      textStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
      animationBuilder: const Miui10AnimBuilder(),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async{
    log('Success Response: ${response.paymentId!}');
    Navigator.pop(context);
    EasyLoading.show(status: "Processing Order");
    String bookingID = await firebaseServices.getAndSetCurrentBookingID();
    log(bookingID);
    firebaseServices.createNewBookingData({
      'bookingID': bookingID,
      'customerID': _firebaseAuth.currentUser!.uid,
      'moviveName': widget.movieDetailsData.title,
      'moviePoster': widget.movieDetailsData.poster,
      'movieRating': widget.movieDetailsData.imdbRating,
      'movieDate': DateFormat.yMMMEd().format(widget.selectedDate),
      "movieTime": widget.selectedTime,
      "movieTheaterName": widget.theatreDetailsData.hallName,
      "movieTheaterAddress": widget.theatreDetailsData.address,
      "movieTheaterLat": widget.theatreDetailsData.lat,
      "movieTheaterLng": widget.theatreDetailsData.lng,
      "numberOfTickets": widget.chairList.length,
      "tickets": tickets.substring(2),
      "subtotalAmount": "₹ ${subtotalAmount.toStringAsFixed(2)}",
      "conveniemcefees": "₹ ${convenienceFees.toStringAsFixed(2)}",
      "baseAmount": "₹ ${baseAmount.toStringAsFixed(2)}",
      "gst": "₹ ${gst.toStringAsFixed(2)}",
      "contributionToBookASmile": "₹ ${bookASmileFees.toStringAsFixed(2)}",
      "totalPayable": "₹ ${totalPayable.toStringAsFixed(2)}",
    }).whenComplete(() {
      EasyLoading.dismiss();

       ConfirmDialog.showCustomDialog(response.paymentId!);
    });
   
    // Fluttertoast.showToast(msg: "SUCCESS: ${response.paymentId!}", toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response)  {
    log('Error Response: $response');
    Navigator.pop(context);
    
    displaySnackNat(response.message!);
    // Fluttertoast.showToast(msg: "ERROR: ${response.code} - ${response.message!}", toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Navigator.pop(context);
    log('External SDK Response: $response');
    // Fluttertoast.showToast(msg: "EXTERNAL_WALLET: ${response.walletName!}", toastLength: Toast.LENGTH_SHORT);
  }

  calculateAmount() {
    for (int i = 0; i < widget.chairList.length; i++) {
      subtotalAmount = subtotalAmount + widget.chairList[i].price;

      tickets = "$tickets | ${widget.chairList[i].id}";
    }
    gst = (18 / 100) * subtotalAmount;
    baseAmount = (10 / 100) * subtotalAmount;
    bookASmileFees = widget.chairList.length;
    convenienceFees = gst + baseAmount;
    totalPayable = convenienceFees + subtotalAmount + bookASmileFees;
    log(tickets.substring(2));
  }

  @override
  Widget build(BuildContext context) {
    // final PaymentController paymentController = Get.put(PaymentController());
    return Center(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        width: 500,
        height: MediaQuery.of(context).size.height / 1.5,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorPalette.background,
          bottomSheet: SafeArea(
            child: Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    offset: const Offset(0, -2),
                    color: ColorPalette.secondary.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 0),
              ]),
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Consumer<AuthProvider>(
                    builder: (context, dataProvider, child) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: ColorPalette.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        openCheckout();
                      },
                      child: Text(
                        "Pay ₹ ${totalPayable.toStringAsFixed(2)}",
                        style:
                            CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10 * 2,
                        ),
                      ));
                }),
              ),
            ),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: ColorPalette.background,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: ColorPalette.secondary,
                )),
            centerTitle: false,
            title: Text(
              "Almost there!",
              style: CustomStyleClass.onboardingBodyTextStyle
                  .copyWith(color: ColorPalette.secondary, fontSize: 10 * 2),
            ),
          ),
          body: body(),
        ),
      ),
    );
  }

  Widget body() {
    return Container(
      color: ColorPalette.background,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: ColorPalette.white,
                borderRadius: BorderRadius.circular(0)),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height / 3,
                  bottom: MediaQuery.of(context).size.height / 3,
                  left: MediaQuery.of(context).size.width / 3,
                  right: MediaQuery.of(context).size.width / 3,
                  child: Image.asset(
                    AssetImageClass.appLogo,
                    height: 1 * 30,
                    width: 1 * 30,
                    color: Colors.grey.shade200,
                  ),
                ),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 150,
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(children: [
                            SizedBox(
                              height: 150,
                              width: 95,
                              child: ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(2)),
                                child: CachedNetworkImage(
                                  imageUrl: widget.movieDetailsData.poster!,
                                  width: MediaQuery.of(context).size.width,
                                  height: double.infinity,
                                  fit: BoxFit.fill,
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
                            const SizedBox(
                              width: 1 * 20,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.movieDetailsData.title!,
                                      maxLines: 2,
                                      style: CustomStyleClass
                                          .onboardingBodyTextStyle
                                          .copyWith(
                                        fontSize: 10 * 2,
                                        fontWeight: FontWeight.bold,
                                        color: ColorPalette.secondary,
                                      )),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        color: ColorPalette.primary,
                                        size: 15,
                                      ),
                                      Text(
                                        " ${(double.parse(widget.movieDetailsData.imdbRating!) * 10).toStringAsFixed(0)}%    ",
                                        style: CustomStyleClass
                                            .onboardingBodyTextStyle
                                            .copyWith(
                                          color: Colors.black,
                                          fontSize: 10 * 1.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      "${DateFormat.yMMMEd().format(widget.selectedDate)} | ${widget.selectedTime}",
                                      style: CustomStyleClass
                                          .onboardingBodyTextStyle
                                          .copyWith(
                                              color: ColorPalette.secondary,
                                              fontSize: 10 * 1.5)),
                                  Text(widget.theatreDetailsData.hallName,
                                      style: CustomStyleClass
                                          .onboardingBodyTextStyle
                                          .copyWith(
                                              color: ColorPalette.secondary,
                                              fontSize: 10 * 1.5)),
                                ],
                              ),
                            )
                          ]),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(widget.chairList.length.toString(),
                                style: CustomStyleClass
                                    .onboardingSkipButtonStyle
                                    .copyWith(
                                  color: ColorPalette.secondary,
                                )),
                            Text("\nM-Ticket",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                        color: ColorPalette.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10 * 1.5)),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  halfCircleDivider(),
                  contactDetailsSection(),
                  const MySeparator(
                    height: 1.5,
                    color: ColorPalette.background,
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  amountSection(),
                  const Divider(
                    height: 10,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ]),
                Positioned(
                  top: -15,
                  left: 10,
                  right: 10,
                  child: printHalfCircles(),
                ),
                Positioned(
                  bottom: -15,
                  left: 10,
                  right: 10,
                  child: printHalfCircles(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget printHalfCircles() {
    double totalWidth = MediaQuery.of(context).size.height - 30;
    double remainingLength = 0;
    double circleSize = 25;
    List<Widget> circleList = [];

    while (remainingLength < totalWidth) {
      // log(remainingLength.toString());
      circleList.add(Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500),
            color: ColorPalette.background),
        height: 25,
        width: 25,
      ));
      remainingLength = (remainingLength + circleSize * 4);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: circleList,
    );
    //return Container();
  }

  Widget halfCircleDivider() {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: const [
          Center(
            child: MySeparator(
              height: 1.5,
              color: ColorPalette.background,
              direction: Axis.horizontal,
            ),
          ),
          Positioned(
              left: -30,
              top: 0,
              bottom: 0,
              child: CircleAvatar(
                backgroundColor: ColorPalette.background,
                radius: 30,
              )),
          Positioned(
              right: -30,
              top: 0,
              bottom: 0,
              child: CircleAvatar(
                backgroundColor: ColorPalette.background,
                radius: 30,
              ))
        ],
      ),
    );
  }

  Widget contactDetailsSection() {
    return Consumer2<AuthProvider, LocationProvider>(
        builder: (context, dataProvider, locProvider, child) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 8,
          ),
          Text(
            'Contact Details',
            style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                color: ColorPalette.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 10 * 1.8),
          ),
          const Divider(
            color: ColorPalette.background,
            thickness: 1,
            height: 15,
          ),
          Text(
            dataProvider.userName!,
            style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                color: ColorPalette.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 10 * 1.5),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            dataProvider.email!,
            style: CustomStyleClass.onboardingBodyTextStyle
                .copyWith(color: ColorPalette.secondary, fontSize: 10 * 1.5),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                dataProvider.phoneNumber!,
                maxLines: 1,
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    color: ColorPalette.secondary, fontSize: 10 * 1.5),
              ),
              locProvider.currentLocation.locality != null
                  ? Text(
                      "  |  ${locProvider.currentLocation.locality}",
                      maxLines: 1,
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary,
                          letterSpacing: 0.6,
                          fontSize: 10 * 1.5),
                    )
                  : const SizedBox(),
              const Expanded(child: SizedBox())
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ]),
      );
    });
  }

  Widget amountSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(children: [
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sub Total',
              style: CustomStyleClass.onboardingBodyTextStyle
                  .copyWith(color: ColorPalette.secondary, fontSize: 10 * 1.8),
            ),
            Text(
              "₹ ${subtotalAmount.toStringAsFixed(2)}",
              style: CustomStyleClass.onboardingBodyTextStyle
                  .copyWith(color: ColorPalette.secondary, fontSize: 10 * 1.9),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Convenience fees',
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: ColorPalette.secondary, fontSize: 10 * 1.8),
                ),
                const Icon(
                  Icons.arrow_drop_down_outlined,
                  color: ColorPalette.secondary,
                  size: 18,
                )
              ],
            ),
            Text(
              "₹ ${convenienceFees.toStringAsFixed(2)}",
              style: CustomStyleClass.onboardingBodyTextStyle
                  .copyWith(color: ColorPalette.secondary, fontSize: 10 * 1.8),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Base Amount',
              style: CustomStyleClass.onboardingBodyTextStyle
                  .copyWith(color: ColorPalette.dark, fontSize: 10 * 1.7),
            ),
            Text(
              "₹ ${baseAmount.toStringAsFixed(2)}",
              style: CustomStyleClass.onboardingBodyTextStyle
                  .copyWith(color: ColorPalette.dark, fontSize: 10 * 1.7),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Integrated GST (IGST) @ 18%',
              style: CustomStyleClass.onboardingBodyTextStyle
                  .copyWith(color: ColorPalette.dark, fontSize: 10 * 1.7),
            ),
            Text(
              "₹ ${gst.toStringAsFixed(2)}",
              style: CustomStyleClass.onboardingBodyTextStyle
                  .copyWith(color: ColorPalette.dark, fontSize: 10 * 1.7),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Image.asset(
                      AssetImageClass.appLogo,
                      height: 18,
                      width: 18,
                    ),
                    Text(
                      ' Contribution to BookASmile',
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10 * 1.5),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '   (₹1 per ticket has been added)',
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: ColorPalette.dark,
                      //fontWeight: FontWeight.bold,
                      fontSize: 10 * 1.5),
                ),
              ],
            ),
            Text(
              "₹ ${bookASmileFees.toStringAsFixed(2)}",
              style: CustomStyleClass.onboardingBodyTextStyle
                  .copyWith(color: ColorPalette.secondary, fontSize: 10 * 1.8),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          thickness: 1,
          height: 15,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Payable Amount',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10 * 1.8),
            ),
            Text(
              "₹ ${totalPayable.toStringAsFixed(2)}",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10 * 1.8),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ]),
    );
  }
}
