// ignore: file_names
import 'dart:developer';
import 'package:book_my_show_clone_web/services/apiService/api_urls.dart';
import 'package:book_my_show_clone_web/services/apiService/base_api.dart';

class SeriesListApiService {
  static Future seriesListApiService() async {
    var response = await BaseApi.getRequest1(extendedURL: ApiUrl.seriesList);
    if (response.statusCode != 200) {
      log(response.statusCode.toString());
    }
    return response;
  }

  static Future relatedSeriesListApiService() async {
    var response =
        await BaseApi.getRequest1(extendedURL: ApiUrl.relatedSeriesList);
    if (response.statusCode != 200) {
      log(response.statusCode.toString());
    }
    return response;
  }
}
