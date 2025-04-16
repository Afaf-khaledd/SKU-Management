import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/utils/colors.dart';
import 'core/utils/routers.dart';
import 'features/Authentication/data/repository/authRepo.dart';
import 'features/Authentication/presentation/logic/auth_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),

      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: ColorsManager.BGColor,
          focusColor: ColorsManager.lightPrimaryColor,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: ColorsManager.primaryColor,
            selectionColor: ColorsManager.primaryColor,
            selectionHandleColor: ColorsManager.primaryColor,
          ),
          primaryColor: ColorsManager.primaryColor,
          textTheme: GoogleFonts.dmSansTextTheme().copyWith(
            bodyLarge: GoogleFonts.poppins(
                fontWeight: FontWeight.w400, color: Colors.black),
            bodyMedium: GoogleFonts.poppins(
                fontWeight: FontWeight.w400, color: Colors.black),
            bodySmall: GoogleFonts.poppins(
                fontWeight: FontWeight.w400, color: Colors.black),
            titleLarge: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400, color: Colors.black),
            titleMedium: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400, color: Colors.black),
            titleSmall: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ),//routes?
        //home: const SplashScreen(),
      ),
    );
  }
}