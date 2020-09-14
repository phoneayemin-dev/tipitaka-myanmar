import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_myanmar/ui/screens/home/bookmark_page.dart';
import 'package:tipitaka_myanmar/ui/screens/home/recent_page.dart';

import 'home_page.dart';

enum Screen { Home, Bookmark, Recent, Search }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Color _backgroundColor =
        ThemeProvider.themeOf(context).data.scaffoldBackgroundColor;
    Color _selectedItemColor = ThemeProvider.themeOf(context).data.accentColor;
    Color _unselectedItemColor =
        ThemeProvider.themeOf(context).data.textTheme.bodyText2.color;
    return Scaffold(
        body: _getScreen(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: _backgroundColor,
          selectedItemColor: _selectedItemColor,
          unselectedItemColor: _unselectedItemColor,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              title: Text('Home'),
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
                title: Text('Bookmark'), icon: Icon(Icons.bookmark)),
            BottomNavigationBarItem(
                title: Text('Recent'), icon: Icon(Icons.history)),
            BottomNavigationBarItem(
                title: Text('Search'), icon: Icon(Icons.search)),
          ],
          onTap: _changePage,
        ));
  }

  _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _getScreen(int index) {
    switch (index) {
      case 0:
        return HomePage();
        break;
      case 1:
        return BookmarkPage();
        break;
      case 2:
        return RecentPage();
        break;
    }
  }
}
