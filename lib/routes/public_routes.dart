import 'package:KleanApp/pages/entry_point.dart';
import 'package:KleanApp/pages/login/login.dart';
import 'package:KleanApp/pages/register/register.dart';
import 'package:go_router/go_router.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const EntryPoint(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const Register(),
    ),
  ],
);
