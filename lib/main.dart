// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, depend_on_referenced_packages, unused_local_variable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quiz_app/Widgets/colors.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'Screens/AuthScreens/splash_screen_update.dart';

Size mq = MediaQuery.of(NavigationService.navigatorKey.currentContext!).size;


Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();

  _configureFirebase();

  // Step 3
  SystemChrome.setPreferredOrientations(
      [ DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown, ]
  ).then((value) => runApp( const MyApp()));
  // runApp( MyApp());
}


//Too recieve FCM notification
void _configureFirebase() async {

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDLjm-NHk2v9_uXXnOeRhUtJ597Elcqb14",
          authDomain: "triggerhappy-a7406.firebaseapp.com",
          projectId: "triggerhappy-a7406",
          storageBucket: "triggerhappy-a7406.appspot.com",
          messagingSenderId: "201811649952",
          appId: "1:201811649952:web:5407a6fb6e5234598c70c5",
          measurementId: "G-P7SF41DNCY"
      )
  );

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): ActivateIntent(),
      },
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      title: 'Burgeon',
      theme: ThemeData(
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppColors.primaryColor
        ),
        primaryColor: buildMaterialColor(AppColors.primaryColor),
        textButtonTheme: TextButtonThemeData(style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(color: AppColors.textWhiteColor)),
        )),
        appBarTheme:  const AppBarTheme(color: AppColors.primaryColor),
        elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
            textStyle:  MaterialStateProperty.all<TextStyle>(
                const TextStyle(
                  color: AppColors.textWhiteColor,
                )
            )
        )),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primaryColor),
        primarySwatch: buildMaterialColor(AppColors.primaryColor),
      ),
      home: const SplashScreenUpdate(),
    );
  }

  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
}

