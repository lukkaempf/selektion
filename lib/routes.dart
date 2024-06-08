import 'package:flutter/material.dart';
import 'package:selektion/model/player.dart';
import 'package:selektion/model/team.dart';
import 'package:selektion/views/analysis_screen.dart';
import 'package:selektion/views/analysis_top4_screen.dart';
import 'package:selektion/views/home.dart';
import 'package:selektion/views/player_screen.dart';
import 'package:selektion/views/rating_screen.dart';
import 'package:selektion/views/team_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String teamScreen = '/teamScreen';
  static const String playerScreen = '/playerScreen';
  static const String ratingScreen = '/ratingScreen';
  static const String analysisScreen = '/analysisScreen';
  static const String analysisTop4Screen = '/analysisTop4Screen';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const Home(),
          settings: const RouteSettings(
            name: AppRoutes.home,
          ),
        );
      case teamScreen:
        return MaterialPageRoute(
          builder: (_) => const TeamScreen(),
        );
      case playerScreen:
        if (args is Team) {
          return MaterialPageRoute(builder: (_) => PlayerScreen(team: args));
        }
      case ratingScreen:
        args as Map;
        return MaterialPageRoute(
            builder: (_) => RatingScreen(
                teamId: args['teamId'], player: args['player'] as Player));
      case analysisScreen:
        return MaterialPageRoute(builder: (_) => const AnalysisScreen());

      case analysisTop4Screen:
        return MaterialPageRoute(builder: (_) => const AnalysisTop4());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Fehler')),
        body: const Center(child: Text('Seite nicht gefunden!')),
      );
    });
  }
}
