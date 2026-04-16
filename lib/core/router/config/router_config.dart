import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../names/app_routes.dart';
import '../../../screens/public/login/login_screen.dart';
import '../../../screens/private/home/home_screen.dart';
import '../../../services/auth_service.dart';

part 'router_config.g.dart';

@riverpod
GoRouter routerConfig(RouterConfigRef ref) {
  final authState = ref.watch(authNotifierProvider);
  final bool isLogged = authState.valueOrNull == AuthStatus.authenticated;

  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      final bool isLoggingIn = state.matchedLocation == AppRoutes.login;

      // Only allow access to Home if status is definitively authenticated
      if (!isLogged) {
        return isLoggingIn ? null : AppRoutes.login;
      }

      // If authenticated and tries to go to login, send to home
      if (isLoggingIn) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
