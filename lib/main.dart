import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sku/features/Branches/data/repository/branchRepo.dart';
import 'package:sku/features/Branches/presentation/logic/branch_bloc.dart';
import 'package:sku/features/SKUs/data/repository/skuRepo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/utils/colors.dart';
import 'core/utils/routers.dart';
import 'features/Authentication/data/repository/authRepo.dart';
import 'features/Authentication/presentation/logic/auth_bloc.dart';
import 'features/Branches/presentation/logic/branch_event.dart';
import 'features/SKUs/presentation/logic/items_bloc.dart';
import 'features/SKUs/presentation/logic/items_event.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://eyxkovzsyebbysipriyt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV5eGtvdnpzeWViYnlzaXByaXl0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ5OTEyMzEsImV4cCI6MjA2MDU2NzIzMX0.ON5ZsG4zXFbaLtE8jYA2Ar3sBRGdxULoNjOGuh-HL8s',
  );
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
        BlocProvider<BranchBloc>(
          create: (context) => BranchBloc(branchRepository: BranchRepository())..add(FetchBranches()),
        ),
        BlocProvider<ItemsBloc>(
          create: (context) => ItemsBloc(itemsRepository: SKURepository())..add(LoadSKUs()),
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