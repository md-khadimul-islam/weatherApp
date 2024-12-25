import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../gen/assets.gen.dart';
import '../gen/colors.gen.dart';
import '../providers/weather_provider.dart';
import '../utils/constant.dart';
import '../utils/helper_function.dart';
import '../utils/text_font_style.dart';
import 'setting.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(weatherProvider.notifier).getData();
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.h),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment(0.71, -0.71),
          end: Alignment(-0.71, 0.71),
          colors: [AppColors.c97ABFF, AppColors.c123597],
        )),
        child: weatherState.isLoading
            ? CircularProgressIndicator()
            : weatherState.currentWeather != null &&
                    weatherState.forecastWeather != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headerSection(weatherState),
                      Row(
                        spacing: 27.w,
                        children: [
                          Image.network(
                            "$iconsUrlPrefix${weatherState.currentWeather!.weather![0].icon}$iconsUrlSuffix",
                            fit: BoxFit.cover,
                          ),
                          Text(
                              "${weatherState.currentWeather?.main?.temp ?? "0"}$degree${weatherState.unitSymbol}",
                              style: TextFontStyle.headline50w400Inter)
                        ],
                      ),
                      Center(
                        child: Text(
                          "${weatherState.currentWeather?.weather![0].description ?? "N/A"} - H: ${weatherState.currentWeather?.main?.tempMax ?? "0"}$degree${weatherState.unitSymbol} - L: ${weatherState.currentWeather?.main?.tempMin ?? "0"}$degree${weatherState.unitSymbol}",
                          style: TextFontStyle.headline18w400Inter,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(8.sp),
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1.w),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Wind speed: ${weatherState.currentWeather!.wind?.speed.toString() ?? "0"} km/h"),
                            Text(
                                "Humidity: ${weatherState.currentWeather!.main?.humidity ?? "0"}%"),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(8.sp),
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1.w),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Feels like: ${weatherState.currentWeather!.main?.feelsLike.toString()}$degree${weatherState.unitSymbol}",
                            ),
                            Text(
                                "Country: ${weatherState.currentWeather?.sys?.country ?? "N/A"}"),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(8.sp),
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1.w),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Pressure: ${weatherState.currentWeather?.main?.pressure ?? "N/A"} hPa"),
                            Text(
                                "Visibility: ${"${(weatherState.currentWeather!.visibility! / 1000).toStringAsFixed(1)} km"}"),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(8.sp),
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1.w),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Sunrise: ${getFormattedDate(weatherState.currentWeather!.sys!.sunrise!)}"),
                            Text(
                                "Sunset: ${getFormattedDate(weatherState.currentWeather!.sys!.sunset!)}"),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),

                      // Forecast weather section
                      forecastWeatherSection(weatherState),
                    ],
                  )
                : Text("No data available"),
      ),
    );
  }

  Padding forecastWeatherSection(WeatherState weatherState) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w),
      child: SizedBox(
        height: 220.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Forecast Weather", style: TextFontStyle.headline32w700Inter),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemCount: weatherState.forecastWeather!.list!.length,
                itemBuilder: (context, index) {
                  final forecastData =
                      weatherState.forecastWeather!.list![index];

                  return Container(
                    width: 100.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        border:
                            Border.all(color: AppColors.c8296DF, width: 1.w),
                        gradient: LinearGradient(
                          begin: Alignment(0.26, -0.97),
                          end: Alignment(-0.26, 0.97),
                          colors: [
                            Colors.white,
                            Colors.white.withAlpha(0),
                          ],
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getFormattedDate(forecastData.dt!,
                              pattern: "EEE HH:mm"),
                          textAlign: TextAlign.center,
                          style: TextFontStyle.headline12w400Inter
                              .copyWith(color: Colors.black, fontSize: 16.sp),
                        ),
                        Image.network(
                          "$iconsUrlPrefix${forecastData.weather![0].icon}$iconsUrlSuffix",
                          fit: BoxFit.cover,
                        ),
                        Text(
                            "${forecastData.main?.temp ?? "0"}$degree${weatherState.unitSymbol}",
                            style: TextFontStyle.headline50w400Inter
                                .copyWith(fontSize: 16.sp)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column headerSection(WeatherState weatherState) {
    return Column(
      spacing: .2.h,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingTools()),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Icon(Icons.settings, color: Colors.white, size: 25.sp),
            ),
          ),
        ),
        Text(weatherState.currentWeather?.name ?? "Location",
            style: TextFontStyle.headline32w700Inter),
        Row(
          spacing: 8.w,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.icons.location,
              fit: BoxFit.cover,
            ),
            Text(
              "Current location",
              style: TextFontStyle.headline12w400Inter,
            ),
          ],
        ),
      ],
    );
  }
}
