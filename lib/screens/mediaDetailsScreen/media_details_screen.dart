import 'package:book_my_show_clone_web/utils/color_palette.dart';
import 'package:book_my_show_clone_web/utils/custom_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/providerService/api_data_provider.dart';
import '../../utils/asset_images_strings.dart';
import '../../utils/enum_classes.dart';
import '../../utils/responsive.dart';
import '../../widgets/desktop_appbar.dart';
import '../../widgets/drawer.dart';
import '../homeScreen/components/media_list_slider.dart';
import '../selectMovieHallScreen/select_movie_hall_screen.dart';

class MediaDetailsScreen extends StatefulWidget {
  static const String id = "mediaDetails-screen";
  final String title;
  final String mediaId;
  final MediaType mediaType;
  const MediaDetailsScreen(
      {Key? key,
      required this.title,
      required this.mediaId,
      required this.mediaType})
      : super(key: key);

  @override
  State<MediaDetailsScreen> createState() => _MediaDetailsScreenState();
}

class _MediaDetailsScreenState extends State<MediaDetailsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey =  GlobalKey<ScaffoldState>();
  @override
  void initState() {
    var apiDataProvider = Provider.of<ApiDataProvider>(context, listen: false);
    apiDataProvider.getMediaDetails(widget.mediaId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
        endDrawer: const MyDrawer(),
      backgroundColor: ColorPalette.background,
      resizeToAvoidBottomInset: false,
      body: body(),
    );
  }

  Widget body() {
    return Consumer<ApiDataProvider>(
        builder: (context, apiDataProvider, child) {
      return apiDataProvider.movieDetailsData == null
          ? const Center(
              child: CupertinoActivityIndicator(
                animating: true,
                color: ColorPalette.secondary,
              ),
            )
          : Scaffold(
              appBar:
                  Responsive.isMobile(context) ? null :  AppBar(
              elevation: 0,
              backgroundColor: ColorPalette.secondary,
              automaticallyImplyLeading: false,
              centerTitle: false,
               toolbarHeight: kToolbarHeight -20,
              flexibleSpace: Container(color: ColorPalette.secondary),
              bottom: DesktopAppBarBottom(scaffoldKey: scaffoldKey),
              actions: const [SizedBox()],
            ),
              bottomNavigationBar: Responsive.isMobile(context)
                  ? SafeArea(
                      child: Container(
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, -2),
                              color: ColorPalette.secondary.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 0),
                        ]),
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: ColorPalette.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                //selctTicketCountSheet(context);
                                Navigator.pushNamed(
                                    context, SelectMovieHallScreen.id,
                                    arguments:
                                        apiDataProvider.movieDetailsData);
                              },
                              child: Text(
                                (widget.mediaType == MediaType.movies ||
                                        widget.mediaType ==
                                            MediaType.relaredMovies)
                                    ? "Book Tickets"
                                    : "Subscribe Now",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10 * 2,
                                ),
                              )),
                        ),
                      ),
                    )
                  : null,
              body: Responsive.isMobile(context)
                  ? bodyMobile(apiDataProvider)
                  : bodyDesktop(apiDataProvider));
    });
  }

  Widget bodyMobile(ApiDataProvider apiDataProvider) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: ColorPalette.secondary,
            expandedHeight: (MediaQuery.of(context).size.height / 3) + 12,
            floating: false,
            pinned: true,
            centerTitle: false,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  shadows: [
                    BoxShadow(
                        offset: Offset(1, 1),
                        color: ColorPalette.secondary,
                        spreadRadius: 10,
                        blurRadius: 10),
                  ],
                )),
            title: Text(
              widget.title,
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                color: Colors.white,
                shadows: [
                  const BoxShadow(
                      offset: Offset(1, 1),
                      color: ColorPalette.secondary,
                      spreadRadius: 10,
                      blurRadius: 10),
                ],
                fontSize: 10 * 2,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    color: Colors.grey.shade100,
                    width: MediaQuery.of(context).size.width,
                    child: AspectRatio(
                      aspectRatio: 0.8,
                      child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(0)),
                        child: CachedNetworkImage(
                          imageUrl: apiDataProvider.movieDetailsData!.poster!,
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
                ],
              ),
            ),
          )
        ];
      },
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: Responsive.isDesktop(context)
              ? 1200
              : MediaQuery.of(context).size.width,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? 1200
                          : MediaQuery.of(context).size.width,
                      child: Text(
                        widget.title,
                        style:
                            CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? 1200
                          : MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: ColorPalette.primary,
                            size: 22,
                          ),
                          Text(
                            " ${(double.parse(apiDataProvider.movieDetailsData!.imdbRating!) * 10).toStringAsFixed(0)}%    ",
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                              color: Colors.black,
                              fontSize: 10 * 1.8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: ColorPalette.secondary,
                                size: 14,
                              ),
                              Text(
                                " ${apiDataProvider.movieDetailsData!.imdbVotes!} Votes",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: Colors.black,
                                  fontSize: 10 * 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: Responsive.isDesktop(context)
                          ? 1200
                          : MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorPalette.dark.withOpacity(0.2)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: ColorPalette.primary.withOpacity(1)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 15,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    " Ratings",
                                    style: CustomStyleClass
                                        .onboardingBodyTextStyle
                                        .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      fontSize: 10 * 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            ListView.separated(
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: apiDataProvider
                                  .movieDetailsData!.ratings!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${apiDataProvider.movieDetailsData!.ratings![index].source}",
                                      style: CustomStyleClass
                                          .onboardingBodyTextStyle
                                          .copyWith(
                                        color: ColorPalette.secondary,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                        fontSize: 10 * 1.5,
                                      ),
                                    ),
                                    Text(
                                      "${apiDataProvider.movieDetailsData!.ratings![index].value}",
                                      style: CustomStyleClass
                                          .onboardingBodyTextStyle
                                          .copyWith(
                                        color: ColorPalette.secondary,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                        fontSize: 10 * 1.5,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 5);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? 1200
                          : MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: ColorPalette.dark.withOpacity(0.2)),
                              child: Text(
                                "${apiDataProvider.movieDetailsData!.language}",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                        color: ColorPalette.secondary,
                                        fontSize: 10 * 1.6),
                              )),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: ColorPalette.primary.withOpacity(1)),
                            child: Text(
                              "${apiDataProvider.movieDetailsData!.rated}",
                              style: CustomStyleClass.onboardingBodyTextStyle
                                  .copyWith(
                                      color: ColorPalette.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10 * 1.6),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? 1200
                          : MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: ColorPalette.dark.withOpacity(0.2)),
                              child: Text(
                                "${apiDataProvider.movieDetailsData!.genre}",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                        color: ColorPalette.secondary,
                                        fontSize: 10 * 1.6),
                              )),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: ColorPalette.dark.withOpacity(0.2)),
                            child: Text(
                              "${apiDataProvider.movieDetailsData!.runtime}",
                              style: CustomStyleClass.onboardingBodyTextStyle
                                  .copyWith(
                                      color: ColorPalette.secondary,
                                      fontSize: 10 * 1.6),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: Responsive.isDesktop(context)
                            ? 1200
                            : MediaQuery.of(context).size.width,
                        child:
                            Text("${apiDataProvider.movieDetailsData!.plot}")),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? 1200
                          : MediaQuery.of(context).size.width,
                      child: Text(
                        "Casting",
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10 * 2),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Responsive.isDesktop(context)
                          ? 1200
                          : MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Actors : ${apiDataProvider.movieDetailsData!.actors}",
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                                    color: ColorPalette.secondary,
                                    fontSize: 10 * 1.6),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Director : ${apiDataProvider.movieDetailsData!.director}",
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                                    color: ColorPalette.secondary,
                                    fontSize: 10 * 1.6),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Writer : ${apiDataProvider.movieDetailsData!.writer}",
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                                    color: ColorPalette.secondary,
                                    fontSize: 10 * 1.6),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Awards : ${apiDataProvider.movieDetailsData!.awards}",
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                                    color: ColorPalette.secondary,
                                    fontSize: 10 * 1.6),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (widget.mediaType == MediaType.movies ||
                              widget.mediaType == MediaType.relaredMovies)
                            const MediaListSlider(
                              title: 'You might also like',
                              mediaType: MediaType.relaredMovies,
                            ),
                          if (widget.mediaType == MediaType.series ||
                              widget.mediaType == MediaType.relatedSeries)
                            const MediaListSlider(
                              title: 'You might also like',
                              mediaType: MediaType.relatedSeries,
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget bodyDesktop(ApiDataProvider apiDataProvider) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              color: ColorPalette.secondary,
              child: Center(
                child: SizedBox(
                  width: Responsive.isDesktop(context)
                      ? 1200
                      : MediaQuery.of(context).size.width,
                  height: 400,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl: apiDataProvider.movieDetailsData!.poster!,
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
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ColorPalette.secondary,
                                Colors.transparent
                              ],
                              stops: [0.0, 0.5],
                              end: Alignment.centerLeft,
                              begin: Alignment.centerRight,
                            ),
                          ),
                          width: 100,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ColorPalette.secondary,
                                Colors.transparent
                              ],
                              stops: [0.0, 1.0],
                              end: Alignment.centerRight,
                              begin: Alignment.centerLeft,
                            ),
                          ),
                          width: 300,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            height: 400,
                            width: Responsive.isDesktop(context)
                                ? 1200
                                : MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AspectRatio(
                                  aspectRatio: 0.7,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                    decoration: BoxDecoration(boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(1, 1),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          color: ColorPalette.secondary)
                                    ], borderRadius: BorderRadius.circular(10)),
                                    child: ClipRRect(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: CachedNetworkImage(
                                        imageUrl: apiDataProvider
                                            .movieDetailsData!.poster!,
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
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: SizedBox(
                                          width: Responsive.isDesktop(context)
                                              ? 1200
                                              : MediaQuery.of(context)
                                                  .size
                                                  .width,
                                          child: Text(
                                            widget.title,
                                            style: CustomStyleClass
                                                .onboardingBodyTextStyle
                                                .copyWith(
                                              color: Colors.white,
                                              
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: SizedBox(
                                          width: Responsive.isDesktop(context)
                                              ? 1200
                                              : MediaQuery.of(context)
                                                  .size
                                                  .width,
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.favorite,
                                                color: ColorPalette.primary,
                                                size: 22,
                                              ),
                                              Text(
                                                " ${(double.parse(apiDataProvider.movieDetailsData!.imdbRating!) * 10).toStringAsFixed(0)}%    IMDB Rating",
                                                style: CustomStyleClass
                                                    .onboardingBodyTextStyle
                                                    .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 10 * 2,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: SizedBox(
                                            width: Responsive.isDesktop(context)
                                                ? 1200
                                                : MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.person,
                                                  color: ColorPalette.white,
                                                  size: 14,
                                                ),
                                                Text(
                                                  " ${apiDataProvider.movieDetailsData!.imdbVotes!} IMDB Votes",
                                                  style: CustomStyleClass
                                                      .onboardingBodyTextStyle
                                                      .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 10 * 1.8,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: SizedBox(
                                              width:
                                                  Responsive.isDesktop(context)
                                                      ? 1200
                                                      : MediaQuery.of(context)
                                                          .size
                                                          .width,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: ColorPalette
                                                                .white)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0,
                                                          horizontal: 15),
                                                      child: Text(
                                                        "Released on  ${apiDataProvider.movieDetailsData!.released!}",
                                                        style: CustomStyleClass
                                                            .onboardingBodyTextStyle
                                                            .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 10 * 2.1,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 60,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 10),
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          ColorPalette.primary,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      //selctTicketCountSheet(context);
                                                      Navigator.pushNamed(
                                                          context,
                                                          SelectMovieHallScreen
                                                              .id,
                                                          arguments: apiDataProvider
                                                              .movieDetailsData);
                                                    },
                                                    child: Text(
                                                      (widget.mediaType ==
                                                                  MediaType
                                                                      .movies ||
                                                              widget.mediaType ==
                                                                  MediaType
                                                                      .relaredMovies)
                                                          ? "Book Tickets"
                                                              .toUpperCase()
                                                          : "Subscribe Now"
                                                              .toUpperCase(),
                                                      style: CustomStyleClass
                                                          .onboardingBodyTextStyle
                                                          .copyWith(
                                                        color: Colors.white,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10 * 2,
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: Responsive.isDesktop(context)
                    ? 1200
                    : MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: ColorPalette.dark.withOpacity(0.2)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: ColorPalette.primary.withOpacity(1)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 15,
                              color: Colors.amber,
                            ),
                            Text(
                              " Ratings",
                              style: CustomStyleClass.onboardingBodyTextStyle
                                  .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                fontSize: 10 * 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      ListView.separated(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            apiDataProvider.movieDetailsData!.ratings!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${apiDataProvider.movieDetailsData!.ratings![index].source}",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: ColorPalette.secondary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  fontSize: 10 * 1.5,
                                ),
                              ),
                              Text(
                                "${apiDataProvider.movieDetailsData!.ratings![index].value}",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: ColorPalette.secondary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  fontSize: 10 * 1.5,
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 5);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SizedBox(
                width: Responsive.isDesktop(context)
                    ? 1200
                    : MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: ColorPalette.dark.withOpacity(0.2)),
                        child: Text(
                          "${apiDataProvider.movieDetailsData!.language}",
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  color: ColorPalette.secondary,
                                  fontSize: 10 * 1.6),
                        )),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorPalette.primary.withOpacity(1)),
                      child: Text(
                        "${apiDataProvider.movieDetailsData!.rated}",
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10 * 1.6),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SizedBox(
                width: Responsive.isDesktop(context)
                    ? 1200
                    : MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: ColorPalette.dark.withOpacity(0.2)),
                        child: Text(
                          "${apiDataProvider.movieDetailsData!.genre}",
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  color: ColorPalette.secondary,
                                  fontSize: 10 * 1.6),
                        )),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorPalette.dark.withOpacity(0.2)),
                      child: Text(
                        "${apiDataProvider.movieDetailsData!.runtime}",
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontSize: 10 * 1.6),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: Responsive.isDesktop(context)
                    ? 1200
                    : MediaQuery.of(context).size.width,
                child: Text(
                  "About the movie",
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: ColorPalette.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 10 * 2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                  width: Responsive.isDesktop(context)
                      ? 1200
                      : MediaQuery.of(context).size.width,
                  child: Text("${apiDataProvider.movieDetailsData!.plot}")),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: Responsive.isDesktop(context)
                    ? 1200
                    : MediaQuery.of(context).size.width,
                child: Text(
                  "Casting",
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: ColorPalette.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 10 * 2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: Responsive.isDesktop(context)
                    ? 1200
                    : MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Actors : ${apiDataProvider.movieDetailsData!.actors}",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary, fontSize: 10 * 1.6),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Director : ${apiDataProvider.movieDetailsData!.director}",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary, fontSize: 10 * 1.6),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Writer : ${apiDataProvider.movieDetailsData!.writer}",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary, fontSize: 10 * 1.6),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Awards : ${apiDataProvider.movieDetailsData!.awards}",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary, fontSize: 10 * 1.6),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // if (widget.mediaType == MediaType.movies ||
                    //     widget.mediaType == MediaType.relaredMovies)
                    //   const MediaListSlider(
                    //     title: 'You might also like',
                    //     mediaType: MediaType.relaredMovies,
                    //   ),
                    // if (widget.mediaType == MediaType.series ||
                    //     widget.mediaType == MediaType.relatedSeries)
                    //   const MediaListSlider(
                    //     title: 'You might also like',
                    //     mediaType: MediaType.relatedSeries,
                    //   ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
