import 'dart:developer';
import 'package:book_my_show_clone_web/screens/splashScreen/splash_screen.dart';
import 'package:book_my_show_clone_web/services/providerService/location_provider.dart';
import 'package:book_my_show_clone_web/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../services/firebaseServices/firebase_services.dart';
import '../../../services/providerService/auth_provider.dart';
import '../../../utils/asset_images_strings.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/custom_styles.dart';
import 'components/dob_picker_sheet_content.dart';

class EditProfileScreen extends StatefulWidget {
  static const String id = 'EditProfileScreen';
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? status;
  String? drivingLicenceUrl;
  String? id;
  String? profilePicUrl;
  String? email;
  String? name;
  bool loading = false;
  String? uploadedProfilePicURL;
  XFile? profilePic;
  XFile? cropped;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ImagePicker picker = ImagePicker();
  bool edit = false;
  int remainingDays = 0;
  bool? identity, married;
  FirebaseServices userServices = FirebaseServices();
  LocationProvider locationProvider = LocationProvider();
  AuthProvider authProvider = AuthProvider();

  String? userDoB;

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();

  TextEditingController pinCodeTextEditingController = TextEditingController();
  TextEditingController addressLineTextEditingController =
      TextEditingController();
  TextEditingController localityTextEditingController = TextEditingController();
  TextEditingController cityTextEditingController = TextEditingController();
  TextEditingController stateTextEditingController = TextEditingController();

  @override
  void initState() {
    locationProvider = Provider.of<LocationProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    pinCodeTextEditingController.text =
        locationProvider.currentLocation.postalCode ?? "";
    addressLineTextEditingController.text =
        locationProvider.currentLocation.placeFormattedAddress ?? "";
    localityTextEditingController.text =
        locationProvider.currentLocation.locality ?? "";
    cityTextEditingController.text =
        locationProvider.currentLocation.city ?? "";
    stateTextEditingController.text =
        locationProvider.currentLocation.stateOrProvince ?? "";
    nameTextEditingController.text = authProvider.userName.toString();
    emailTextEditingController.text = authProvider.email.toString();
    phoneTextEditingController.text = authProvider.phoneNumber.toString();
    userDoB = authProvider.userDoB ?? "Select Date of Birth";
    identity = authProvider.identity;
    married = authProvider.married;

    super.initState();
  }

  void updateUser(
      {required String id,
      required String name,
      required String emailId,
      required String phoneNumber,
      required String profilePic}) {
    userServices.updateUserData({
      'id': id,
      'name': name,
      'email': emailId,
      'number': phoneNumber,
      'profile_Pic_URL': uploadedProfilePicURL ?? profilePic,
      'user_dob': userDoB,
      'identity': identity,
      'married': married,
      'token': authProvider.token,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0))),
        backgroundColor: Colors.green.shade400,
        content: Text("Profile Update Successful !",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white)),
        duration: const Duration(milliseconds: 3000),
      ));
    });

    authProvider.saveUserDetails(
      email: emailId,
      phoneNumber: phoneNumber,
      token: authProvider.token.toString(),
      profilePicURL: uploadedProfilePicURL ?? profilePic,
      uid: id,
      userName: name,
      userDoB: userDoB,
      identity: identity,
      married: married,
    );
  }

  void _showDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) {
          return const DobPickerSheetContent();
        }).then((value) {
      if (value != null) {
        setState(() {
          userDoB = DateFormat.yMMMMd('en_US').format(value);
        });
      }
    });
  }

  @override
  void dispose() {
    nameTextEditingController.dispose();
    phoneTextEditingController.dispose();
    emailTextEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: Responsive.isMobile(context)
            ? null
            : MediaQuery.of(context).size.height / 1.5,
        width: Responsive.isMobile(context) ? null : 500,
        decoration: Responsive.isMobile(context)
            ? const BoxDecoration()
            : BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Scaffold(
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
            centerTitle: false,
            title: Text(
              "Edit Profile",
              style: CustomStyleClass.onboardingBodyTextStyle
                  .copyWith(color: ColorPalette.white, fontSize: 10 * 1.8),
            ),
          ),
          body: body(),
          bottomNavigationBar: _bottomSheet(),
        ),
      ),
    );
  }

  Widget body() {
    return Consumer<AuthProvider>(builder: (context, dataProvider, child) {
      return SingleChildScrollView(
        child: Column(
          children: [
            _myPic(dataProvider),
            const SizedBox(
              height: 20,
            ),
            Column(children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text("Mobile Number",
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontSize: 10 * 1.8,
                                fontWeight: FontWeight.bold)),
                  )),
              _phoneEditor(),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text("Email Address",
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontSize: 10 * 1.8,
                                fontWeight: FontWeight.bold)),
                  )),
              _emailEditor(),
              Container(
                height: 15,
                color: ColorPalette.background,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text("Personal Details",
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontSize: 10 * 1.8,
                                fontWeight: FontWeight.bold)),
                  )),
              _nameEditor(),
              _dobEditor(),
              _identitySelector(
                  firstButtonTitle: "Woman",
                  secondButtonTitle: 'Man',
                  selectorTypeTitle: 'Identity (Optional)'),
              const SizedBox(
                height: 5,
              ),
              _marriageSelector(
                  firstButtonTitle: "Yes",
                  secondButtonTitle: 'No',
                  selectorTypeTitle: 'Married? (Optional)'),
              Container(
                height: 15,
                width: MediaQuery.of(context).size.width,
                color: ColorPalette.background,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text("Address (Optional)",
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontSize: 10 * 1.8,
                                fontWeight: FontWeight.bold)),
                  )),
              _pinCodeEditor(),
              _addressLineEditor(),
              _localityEditor(),
              _cityEditor(),
              _stateEditor(),
              const SizedBox(height: 20 * 1),
              Container(
                height: 50,
                color: ColorPalette.background,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text.rich(
                    TextSpan(
                        text: 'I agree to  ',
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontSize: 10 * 1.5),
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                                    decoration: TextDecoration.underline,
                                    color: ColorPalette.secondary,
                                    fontSize: 10 * 1.5),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Container(),
                          ),
                          TextSpan(
                            text: ' and ',
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                                    color: ColorPalette.secondary,
                                    fontSize: 10 * 1.5),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Container(),
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                                    decoration: TextDecoration.underline,
                                    color: ColorPalette.secondary,
                                    fontSize: 10 * 1.5),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Container(),
                          )
                        ]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ]),
          ],
        ),
      );
    });
  }

  _myPic(AuthProvider dataProvider) {
    return Container(
      height: 200 * 1,
      color: ColorPalette.secondary,
      child: Center(
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            height: 180 * 1,
            width: 180 * 1,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: const BorderRadius.all(Radius.circular(500)),
              child: CachedNetworkImage(
                imageUrl: uploadedProfilePicURL == null
                    ? dataProvider.profilePicURL!
                    : uploadedProfilePicURL!,
                height: 180 * 1,
                width: 180 * 1,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: Image.asset(
                    AssetImageClass.appLogo,
                    color: ColorPalette.dark,
                    width: 100 * 1,
                    height: 100 * 1,
                  ),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Image.asset(
                    AssetImageClass.appLogo,
                    width: 100 * 1,
                    height: 100 * 1,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 15,
              right: 15,
              child: ClipOval(
                child: GestureDetector(
                  onTap: () {
                    getProfileImage();
                  },
                  child: const Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(800)),
                        side: BorderSide(width: 0.1, color: Colors.black)),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(1),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.edit_outlined,
                              size: 20, color: ColorPalette.secondary),
                        ),
                      ),
                    ),
                  ),
                ),
              ))
        ]),
      ),
    );
  }

  _nameEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Full Name",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: 10 * 1.5,
                )),
            const SizedBox(
              height: 5,
            ),
            _textEditor(
                verified: false,
                prefixIcon: Icons.person_outline_outlined,
                controller: nameTextEditingController,
                readOnly: false,
                hintText: "User Name")
          ],
        ));
  }

  _dobEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Birthday (Optional)",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: 10 * 1.5,
                )),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () => _showDatePicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                decoration: BoxDecoration(
                    color: ColorPalette.white,
                    borderRadius: BorderRadius.circular(5.0),
                    border:
                        Border.all(width: 0.5, color: ColorPalette.secondary)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      const Icon(Icons.cake_outlined,
                          color: ColorPalette.secondary, size: 20),
                      // SizedBox(width: 10.0),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          userDoB != null ? userDoB! : 'No date time picked!',
                          style:
                              CustomStyleClass.onboardingBodyTextStyle.copyWith(
                            color: ColorPalette.secondary,
                            fontSize: 10 * 1.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  _phoneEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: _textEditor(
            verified: true,
            prefixIcon: Icons.phone_iphone_outlined,
            controller: phoneTextEditingController,
            readOnly: true,
            hintText: "Phone Number"));
  }

  _emailEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: _textEditor(
            verified: false,
            prefixIcon: Icons.email_outlined,
            controller: emailTextEditingController,
            readOnly: false,
            hintText: "Email Id"));
  }

  _pinCodeEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Area Pincode",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: 10 * 1.5,
                )),
            const SizedBox(
              height: 5,
            ),
            _textEditor(
                verified: false,
                prefixIcon: Icons.pin_drop_outlined,
                controller: pinCodeTextEditingController,
                readOnly: false,
                hintText: "Area Pincode")
          ],
        ));
  }

  _addressLineEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Address Line",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: 10 * 1.5,
                )),
            const SizedBox(
              height: 5,
            ),
            _textEditor(
                verified: false,
                prefixIcon: Icons.home_outlined,
                controller: addressLineTextEditingController,
                readOnly: false,
                hintText: "Address Line")
          ],
        ));
  }

  _localityEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Locality",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: 10 * 1.5,
                )),
            const SizedBox(
              height: 5,
            ),
            _textEditor(
                verified: false,
                prefixIcon: Icons.pin_drop_outlined,
                controller: localityTextEditingController,
                readOnly: false,
                hintText: "Locality")
          ],
        ));
  }

  _cityEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Town / City",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: 10 * 1.5,
                )),
            const SizedBox(
              height: 5,
            ),
            _textEditor(
                verified: false,
                prefixIcon: Icons.pin_drop_outlined,
                controller: cityTextEditingController,
                readOnly: false,
                hintText: "Town / City")
          ],
        ));
  }

  _stateEditor() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("State",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: 10 * 1.5,
                )),
            const SizedBox(
              height: 5,
            ),
            _textEditor(
                verified: false,
                prefixIcon: Icons.pin_drop_outlined,
                controller: stateTextEditingController,
                readOnly: false,
                hintText: "State")
          ],
        ));
  }

  _identitySelector({
    required String selectorTypeTitle,
    required String firstButtonTitle,
    required String secondButtonTitle,
  }) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(selectorTypeTitle,
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: 10 * 1.5,
                )),
            const SizedBox(
              height: 5,
            ),
            _identitySelctorButtons(
              firstButtonTitle: firstButtonTitle,
              secondButtonTitle: secondButtonTitle,
            )
          ],
        ));
  }

  _marriageSelector({
    required String selectorTypeTitle,
    required String firstButtonTitle,
    required String secondButtonTitle,
  }) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(selectorTypeTitle,
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: 10 * 1.5,
                )),
            const SizedBox(
              height: 5,
            ),
            _marriageSelctorButtons(
              firstButtonTitle: firstButtonTitle,
              secondButtonTitle: secondButtonTitle,
            )
          ],
        ));
  }

  _textEditor({
    IconData? prefixIcon,
    TextEditingController? controller,
    bool? readOnly,
    bool verified = false,
    String? hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: ColorPalette.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(width: 0.5, color: ColorPalette.secondary)),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            const SizedBox(width: 5),
            Icon(prefixIcon, color: ColorPalette.secondary, size: 20),
            // SizedBox(width: 10.0),
            Expanded(
              child: TextField(
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: 10 * 1.8,
                ),
                readOnly: readOnly!,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.grey),
                  fillColor: Colors.transparent,
                  filled: true,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                ),
              ),
            ),
            verified
                ? Icon(CupertinoIcons.checkmark_alt_circle,
                    color: Colors.green.shade700)
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheet() {
    return Consumer<AuthProvider>(builder: (context, dataProvider, child) {
      return SafeArea(
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: ColorPalette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (nameTextEditingController.text.isNotEmpty &&
                      emailTextEditingController.text.isNotEmpty) {
                    updateUser(
                      id: _firebaseAuth.currentUser!.uid,
                      name: nameTextEditingController.text,
                      emailId: emailTextEditingController.text,
                      profilePic: dataProvider.profilePicURL!,
                      phoneNumber: phoneTextEditingController.text,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0))),
                      backgroundColor: Colors.red.shade400,
                      content: Text("Fields Can not be Empty !",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white)),
                      duration: const Duration(milliseconds: 3000),
                    ));
                  }
                },
                child: Text(
                  "Save Changes",
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10 * 1.8,
                  ),
                )),
          ),
        ),
      );
    });
  }

  Future getProfileImage() async {
    await picker
        .pickImage(source: ImageSource.gallery, maxHeight: 1024, maxWidth: 1024)
        .then((image) async {
      try {
        if (image != null) {
          var data = await ImageCropper().cropImage(
              sourcePath: image.path,
              aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
              maxWidth: 1024,
              maxHeight: 1024,
              compressFormat: ImageCompressFormat.jpg,
              uiSettings: [
                AndroidUiSettings(
                  toolbarColor: Theme.of(context).colorScheme.secondary,
                  toolbarTitle: "Crop Image",
                  statusBarColor: Theme.of(context).colorScheme.secondary,
                  backgroundColor: Colors.white,
                ),
                WebUiSettings(
                  context: context,
                ),
              ]);
          if (data != null) cropped = XFile(data.path);

          if (cropped != null) {
            setState(() {
              profilePic = cropped;
            });

            await uploadImageToStorage(profilePic!);
            if (cropped?.path == null) retrieveLostData(profilePic!);
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0))),
              backgroundColor: Colors.red.shade400,
              content: Text("$e!",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.white)),
              duration: const Duration(milliseconds: 5000),
            ))
            .closed
            .then((_) {
          setState(() {});
        });
      }
    });
  }



  uploadImageToStorage(XFile pickedFile) async {
      await EasyLoading.show(status: 'Uploading...');

try{      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('${_firebaseAuth.currentUser!.uid}/profilePicture.jpg');
    await storageReference
        .putData(
      await pickedFile.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    )
        .whenComplete(() async {
      await storageReference.getDownloadURL().then((fileURL) async {
       setState(() {
            uploadedProfilePicURL = fileURL;
            if (kDebugMode) {
              print(fileURL.toString());
            }
            if (kDebugMode) {
              print(
                  'From Storage URL Upload: ${uploadedProfilePicURL.toString()}');
            }
          });
          if (kDebugMode) {
            print("========================");
          }

       
      });
    }); } catch (e) {
      log(e.toString());
      EasyLoading.dismiss();
    }

    EasyLoading.dismiss();
  }

  Future<void> retrieveLostData(XFile image) async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        image = XFile(response.file!.path);
      });
    } else {
      if (kDebugMode) {
        print(response.file);
      }
    }
  }

  _identitySelctorButtons({
    required String firstButtonTitle,
    required String secondButtonTitle,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        InkWell(
          onTap: () {
            setState(() {
              identity = true;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: (identity == null
                      ? ColorPalette.dark
                      : identity == true
                          ? ColorPalette.primary
                          : identity == false
                              ? ColorPalette.dark
                              : ColorPalette.white)),
              color: (identity == null
                  ? ColorPalette.white
                  : identity == true
                      ? ColorPalette.primary
                      : identity == false
                          ? ColorPalette.white
                          : ColorPalette.white),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 15.0),
              child: Text(firstButtonTitle,
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: (identity == null
                          ? ColorPalette.dark
                          : identity == true
                              ? ColorPalette.white
                              : identity == false
                                  ? ColorPalette.dark
                                  : ColorPalette.white),
                      fontSize: 10 * 1.5,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        const SizedBox(
          width: 1 * 30,
        ),
        InkWell(
          onTap: () {
            setState(() {
              identity = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: (identity == null
                      ? ColorPalette.dark
                      : identity == false
                          ? ColorPalette.primary
                          : identity == true
                              ? ColorPalette.dark
                              : ColorPalette.white)),
              color: (identity == null
                  ? ColorPalette.white
                  : identity == false
                      ? ColorPalette.primary
                      : identity == true
                          ? ColorPalette.white
                          : ColorPalette.white),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 15.0),
              child: Text(secondButtonTitle,
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: (identity == null
                          ? ColorPalette.dark
                          : identity == false
                              ? ColorPalette.white
                              : identity == true
                                  ? ColorPalette.dark
                                  : ColorPalette.white),
                      fontSize: 10 * 1.5,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ]),
    );
  }

  _marriageSelctorButtons({
    required String firstButtonTitle,
    required String secondButtonTitle,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        InkWell(
          onTap: () {
            setState(() {
              married = true;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: (married == null
                      ? ColorPalette.dark
                      : married == true
                          ? ColorPalette.primary
                          : married == false
                              ? ColorPalette.dark
                              : ColorPalette.white)),
              color: (married == null
                  ? ColorPalette.white
                  : married == true
                      ? ColorPalette.primary
                      : married == false
                          ? ColorPalette.white
                          : ColorPalette.white),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 15.0),
              child: Text(firstButtonTitle,
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: (married == null
                          ? ColorPalette.dark
                          : married == true
                              ? ColorPalette.white
                              : married == false
                                  ? ColorPalette.dark
                                  : ColorPalette.white),
                      fontSize: 10 * 1.5,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        const SizedBox(
          width: 1 * 30,
        ),
        InkWell(
          onTap: () {
            setState(() {
              married = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: (married == null
                      ? ColorPalette.dark
                      : married == false
                          ? ColorPalette.primary
                          : married == true
                              ? ColorPalette.dark
                              : ColorPalette.white)),
              color: (married == null
                  ? ColorPalette.white
                  : married == false
                      ? ColorPalette.primary
                      : married == true
                          ? ColorPalette.white
                          : ColorPalette.white),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 15.0),
              child: Text(secondButtonTitle,
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: (married == null
                          ? ColorPalette.dark
                          : married == false
                              ? ColorPalette.white
                              : married == true
                                  ? ColorPalette.dark
                                  : ColorPalette.white),
                      fontSize: 10 * 1.5,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ]),
    );
  }

  showDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Confirm Logout ?"),
          content: const Text("\nAre you sure you want to logout?\n"),
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
      },
    ).then((value) async {
      if (value != null && value == true) {
        await FirebaseAuth.instance.signOut().then((val) {
          // preferences!.clear();
          Provider.of<AuthProvider>(context, listen: false).resetAuth();
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (BuildContext context) {
                return const SplashScreen();
              },
            ),
            (_) => true,
          );

          // pushNewScreenWithRouteSettings(
          //   context,
          //   screen: const WelcomeScreen(),
          //   settings: const RouteSettings(name: WelcomeScreen.id),
          //   withNavBar: false,
          //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
          // );
        });
      }
    });
  }
}
