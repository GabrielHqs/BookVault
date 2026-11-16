import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_strings.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/registro_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/livros/livro_detalhe_screen.dart';
import 'screens/livros/livro_form_screen.dart';
import 'screens/livros/livros_screen.dart';
import 'services/auth_service.dart';

final GoRouter _router = GoRouter(
  initialLocation: RoutePaths.home,
  refreshListenable: AuthService.instance,
  redirect: (context, state) {
    final logado = AuthService.instance.logado;
    final local = state.matchedLocation;
    final emTelaDeAuth =
        local == RoutePaths.login || local == RoutePaths.registro;

    if (!logado && !emTelaDeAuth) return RoutePaths.login;
    if (logado && emTelaDeAuth) return RoutePaths.home;
    return null;
  },
  routes: [
    GoRoute(
      path: RoutePaths.login,
      name: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RoutePaths.registro,
      name: RouteNames.registro,
      builder: (context, state) => const RegistroScreen(),
    ),
    GoRoute(
      path: RoutePaths.home,
      name: RouteNames.home,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: RoutePaths.livros,
          name: RouteNames.livros,
          builder: (context, state) => const LivrosScreen(),
          routes: [
            // "novo" precisa vir antes de ":id".
            GoRoute(
              path: RoutePaths.livroNovo,
              name: RouteNames.livroNovo,
              builder: (context, state) => const LivroFormScreen(),
            ),
            GoRoute(
              path: RoutePaths.livroDetalhe,
              name: RouteNames.livroDetalhe,
              builder: (context, state) =>
                  LivroDetalheScreen(livroId: state.pathParameters['id']!),
              routes: [
                GoRoute(
                  path: RoutePaths.livroEditar,
                  name: RouteNames.livroEditar,
                  builder: (context, state) =>
                      LivroFormScreen(livroId: state.pathParameters['id']),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appNome,
      theme: AppTheme.light,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
