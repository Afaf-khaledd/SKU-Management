import 'package:go_router/go_router.dart';
import 'package:sku/features/Branches/presentation/views/branchesList.dart';
import 'package:sku/features/Home/presentation/view/homeScreen.dart';
import 'package:sku/features/SKUs/presentation/views/skuList.dart';
import 'package:sku/features/Starting/presentation/views/OnboardingScreen.dart';
import 'package:sku/features/Starting/presentation/views/SplashScreen.dart';

import '../../features/Authentication/presentation/views/LoginScreen.dart';

abstract class AppRouter{
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/branches',
        builder: (context, state) => const BranchesListScreen(),
      ),
      GoRoute(
        path: '/items',
        builder: (context, state) => const SKUsListScreen(),
      ),
    ],
  );
}

