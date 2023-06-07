import 'package:flutter/material.dart';
import 'package:advisor_ui/module/home/presentation/home_screen.dart';

import '../../pages/budget_page.dart';
import '../../pages/create_budge_page.dart';
import '../../pages/daily_page.dart';
import '../../pages/profile_page.dart';
import '../../pages/root_app.dart';
import '../../pages/stats_page.dart';
import '/core/route/app_route_name.dart';

class AppRoute {
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteName.home:
        return MaterialPageRoute(
          builder: (_) =>  HomeScreen(),
          settings: settings,
        );
        case AppRouteName.budget:
        return MaterialPageRoute(
          builder: (_) =>  BudgetPage(),
          settings: settings,
        );
        case AppRouteName.createbudget:
        return MaterialPageRoute(
          builder: (_) =>  CreatBudgetPage(),
          settings: settings,
        );
          case AppRouteName.daily:
        return MaterialPageRoute(
          builder: (_) =>  DailyPage(),
          settings: settings,
        );
          case AppRouteName.profile:
        return MaterialPageRoute(
          builder: (_) =>  ProfilePage(),
          settings: settings,
        );
          case AppRouteName.root:
        return MaterialPageRoute(
          builder: (_) =>  RootApp(),
          settings: settings,
        );
          case AppRouteName.stats:
        return MaterialPageRoute(
          builder: (_) =>  StatsPage(),
          settings: settings,
        );
    }

    return null;
  }
}
