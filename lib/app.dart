import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_myanmar/business_logic/view_models/recent_list_view_model.dart';
import 'package:tipitaka_myanmar/screens/reader/reader.dart';
import 'ui/screens/home/home.dart';
import 'data/theme_data.dart';


const HomeRoute = '/';
const ReaderRoute = '/reader';

class App extends StatelessWidget {
  final List<AppTheme> themes = MyTheme.fetchAll();
  
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
        loadThemeOnInit: true,
        defaultThemeId: themes.first.id,
        themes: themes,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: _routes(),
        home: ThemeConsumer(child: MultiProvider(
          providers: [
            ChangeNotifierProvider<RecentListViewModel>(
              create: (context) => RecentListViewModel(),              
            )
          ],
          child: Home())),
      ),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case HomeRoute:
          screen = Home();
          break;
        case ReaderRoute:
          screen = Reader(arguments['book']);
          break;
        default:
          return null;
      }
      return MaterialPageRoute(
          builder: (BuildContext context) => ThemeConsumer(child: screen));
    };
  }
}
