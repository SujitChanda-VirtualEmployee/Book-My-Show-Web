import 'dart:developer';
import 'package:book_my_show_clone_web/models/hall_details_model.dart';
import 'package:book_my_show_clone_web/models/movie_details_model.dart';
import 'package:book_my_show_clone_web/utils/color_palette.dart';
import 'package:book_my_show_clone_web/utils/custom_styles.dart';
import 'package:book_my_show_clone_web/widgets/customDialog/selectSeatCountDialog/select_seat_count_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/asset_images_strings.dart';
import '../../utils/responsive.dart';
import '../../widgets/desktop_appbar.dart';
import '../../widgets/drawer.dart';
import 'components/cinema_hall_tile.dart';

class SelectMovieHallScreen extends StatefulWidget {
  final MovieDetailsModel movieDetailsData;
  static const String id = "selectMovieHall-screen";
  const SelectMovieHallScreen({Key? key, required this.movieDetailsData})
      : super(key: key);

  @override
  State<SelectMovieHallScreen> createState() => _SelectMovieHallScreenState();
}

class _SelectMovieHallScreenState extends State<SelectMovieHallScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();
  DateTime endDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  List<bool> selectedDateIndex = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  List<DateTime> dateList = [];

  // selctTicketCountSheet({
  //   required BuildContext context,
  //   required CinemaHallClass theatreDetailsData,
  //   required DateTime date,
  //   required String time,
  // }) {
  //   return showModalBottomSheet(
  //       isDismissible: true,
  //       isScrollControlled: true,
  //       enableDrag: true,
  //       context: context,
  //       backgroundColor: Colors.transparent,
  //       builder: (context) {
  //         return SelectTicketCountSheetComponent(
  //           movieDetailsData: widget.movieDetailsData,
  //           theatreDetailsData: theatreDetailsData,
  //           selectedDate: date,
  //           selectedTime: time,
  //         );
  //       }).then((val) {
  //     log("=============================================================");
  //     if (val != null) {
  //       if (val == true) {
  //         // Navigator.pushNamed(context, NewBookingDetailsScreen.id);
  //       }
  //     }
  //   });
  // }

  getDateList() {
    for (int i = 0; i < 7; i++) {
      dateList.add(now.add(Duration(days: i)));
    }
  }

  @override
  void initState() {
    // endDate = now.add(const Duration(days: 15));
    getDateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      key: scaffoldKey,
      endDrawer: const MyDrawer(),
      appBar: Responsive.isMobile(context)
          ? AppBar(
              elevation: 0,
              backgroundColor: ColorPalette.secondary,
              centerTitle: true,
              title: Text(
                widget.movieDetailsData.title.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10 * 2),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
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
            ), // DesktopAppBar(scaffoldKey: scaffoldKey,),
      body: body(),
    );
  }

  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: !Responsive.isMobile(context),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 100,
              width: Responsive.isDesktop(context)
                  ? 1200
                  : MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        child: CachedNetworkImage(
                          imageUrl: widget.movieDetailsData.poster!,
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
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.movieDetailsData.title!,
                          style:
                              CustomStyleClass.onboardingBodyTextStyle.copyWith(
                            color: ColorPalette.secondary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: ColorPalette.primary,
                              size: 22,
                            ),
                            Text(
                              " ${(double.parse(widget.movieDetailsData.imdbRating!) * 10).toStringAsFixed(0)}%    IMDB Rating",
                              style: CustomStyleClass.onboardingBodyTextStyle
                                  .copyWith(
                                color: ColorPalette.secondary,
                                fontSize: 10 * 1.6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 100,
          width: Responsive.isDesktop(context)
              ? 1200
              : MediaQuery.of(context).size.width,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  selectedDateIndex.clear();
                  for (int i = 0; i < 7; i++) {
                    if (i == index) {
                      selectedDateIndex.add(true);
                      selectedDate = dateList[index];
                    } else {
                      selectedDateIndex.add(false);
                      log("Sujit Chanda False");
                    }
                  }
                  setState(() {});
                  log(selectedDate.toString());
                },
                child: Container(
                  width: Responsive.isDesktop(context)
                      ? 1200 / 7
                      : MediaQuery.of(context).size.width / 7,
                  height: double.infinity,
                  color: selectedDateIndex[index] == true
                      ? ColorPalette.primary
                      : ColorPalette.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.E().format(dateList[index]).toUpperCase(),
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: selectedDateIndex[index] == true
                                    ? ColorPalette.white
                                    : ColorPalette.secondary,
                                fontSize: 10 * 1.5),
                      ),
                      Text(DateFormat.d().format(dateList[index]).toUpperCase(),
                          style:
                              CustomStyleClass.onboardingBodyTextStyle.copyWith(
                            color: selectedDateIndex[index] == true
                                ? ColorPalette.white
                                : ColorPalette.secondary,
                          )),
                      Text(
                          DateFormat.MMM()
                              .format(dateList[index])
                              .toUpperCase(),
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  color: selectedDateIndex[index] == true
                                      ? ColorPalette.white
                                      : ColorPalette.secondary,
                                  fontSize: 10 * 1.5)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(
          thickness: 1,
          height: 0,
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
            child: SizedBox(
          width: Responsive.isDesktop(context)
              ? 1200
              : MediaQuery.of(context).size.width,
          child: ListView.separated(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            itemCount: demoCinemaHallList.length,
            itemBuilder: (BuildContext context, int index) {
              return CinemaHallTile(
                data: demoCinemaHallList[index],
                onTimeSelect: (selectedTime) {
                  // Fluttertoast.cancel();
                  SelectSeatCountDialog.showCustomDialog(
                      theatreDetailsData: demoCinemaHallList[index],
                      date: selectedDate,
                      time: selectedTime,
                      movieDetailsData: widget.movieDetailsData);
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 15,
              );
            },
          ),
        ))
      ],
    );
  }
}
