import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_myanmar/ui/screens/reader/reader.dart';
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
        home: ThemeConsumer(child: Home()),
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
          final currentPage =
              arguments['currentPage'] == null ? 1 : arguments['currentPage'];
          screen = Reader(
            book: arguments['book'],
            currentPage: currentPage,
            textToHighlight: arguments['textToHighlight'],
          );
          break;
        default:
          return null;
      }
      return MaterialPageRoute(
          builder: (BuildContext context) => ThemeConsumer(child: screen));
    };
  }
}
