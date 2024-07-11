import "dart:async";

import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:go_router/go_router.dart";
import "package:tic_tac_toe/src/enum/enum.dart";
import "package:tic_tac_toe/src/screens/auth/login.screen.dart";
import "package:tic_tac_toe/src/screens/auth/registration.screen.dart";
import "package:tic_tac_toe/src/screens/game/game_screen.dart";
import "package:tic_tac_toe/src/screens/game/lobby_screen.dart";
import "package:tic_tac_toe/src/screens/home/home.screen.dart";
import "package:tic_tac_toe/src/screens/home/wrapper.dart";
import "../controllers/auth_controller.dart";

/// https://pub.dev/packages/go_router

class GlobalRouter {
  // Static method to initialize the singleton in GetIt
  static void initialize() {
    GetIt.instance.registerSingleton<GlobalRouter>(GlobalRouter());
  }

  // Static getter to access the instance through GetIt
  static GlobalRouter get instance => GetIt.instance<GlobalRouter>();

  static GlobalRouter get I => GetIt.instance<GlobalRouter>();

  late GoRouter router;
  late GlobalKey<NavigatorState> _rootNavigatorKey;
  late GlobalKey<NavigatorState> _shellNavigatorKey;

  FutureOr<String?> handleRedirect(
      BuildContext context, GoRouterState state) async {
    if (AuthController.I.state == AuthState.authenticated) {
      if (state.matchedLocation == LoginScreen.route) {
        return HomeScreen.route;
      }
      if (state.matchedLocation == RegistrationScreen.route) {
        return HomeScreen.route;
      }
      return null;
    }
    if (AuthController.I.state != AuthState.authenticated) {
      if (state.matchedLocation == LoginScreen.route) {
        return null;
      }
      if (state.matchedLocation == RegistrationScreen.route) {
        return null;
      }
      return LoginScreen.route;
    }
    return null;
  }

  GlobalRouter() {
    _rootNavigatorKey = GlobalKey<NavigatorState>();
    _shellNavigatorKey = GlobalKey<NavigatorState>();
    router = GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: HomeScreen.route,
        redirect: handleRedirect,
        refreshListenable: AuthController.I,
        routes: [
          GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: LoginScreen.route,
              name: LoginScreen.name,
              builder: (context, _) {
                return const LoginScreen();
              }),
          GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: RegistrationScreen.route,
              name: RegistrationScreen.name,
              builder: (context, _) {
                return const RegistrationScreen();
              }),
          ShellRoute(
              navigatorKey: _shellNavigatorKey,
              routes: [
                GoRoute(
                    parentNavigatorKey: _shellNavigatorKey,
                    path: HomeScreen.route,
                    name: HomeScreen.name,
                    builder: (context, _) {
                      return const HomeScreen();
                    }),
                GoRoute(
                  parentNavigatorKey: _shellNavigatorKey,
                  path: "${GameScreen.route}/:gameId/:playerId",
                  name: GameScreen.name,
                  builder: (context, state) {
                    final String gameId = state.pathParameters['gameId'] ?? "";
                    final String playerId = state.pathParameters['playerId'] ??
                        ""; // Corrected parameter name
                    return GameScreen(
                      gameId: gameId,
                      playerId: playerId,
                    );
                  },
                ),
                GoRoute(
                    parentNavigatorKey: _shellNavigatorKey,
                    path: LobbyScreen.route,
                    name: LobbyScreen.name,
                    builder: (context, _) {
                      return const LobbyScreen();
                    }),
              ],
              builder: (context, state, child) {
                return HomeWrapper(
                  child: child,
                );
              }),
        ]);
  }
}
