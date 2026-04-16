import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../names/app_routes.dart';
import '../../../screens/public/login/login_screen.dart';
import '../../../screens/private/home/home_screen.dart';
import '../../../services/auth_service.dart';

part 'router_config.g.dart';

@riverpod
GoRouter routerConfig(RouterConfigRef ref) {
  final bool isLogged = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      final bool isLoggingIn = state.matchedLocation == AppRoutes.login;

      if (!isLogged) {
        return isLoggingIn ? null : AppRoutes.login;
      }

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
