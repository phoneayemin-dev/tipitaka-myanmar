import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_myanmar/app.dart';
import 'package:tipitaka_myanmar/business_logic/models/list_item.dart';
import 'package:tipitaka_myanmar/services/database/database_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ListItem> _listItems = [];

  @override
  void initState() {
    super.initState();
    loadBooks().then((value) {
      setState(() {
        _listItems = value;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text('ပိဋကတ်သုံးပုံမြန်မာပြန်')),
          actions: [
            IconButton(
                icon: Icon(Icons.palette),
                onPressed: () =>
                    ThemeProvider.controllerOf(context).nextTheme())
          ],
        ),
          body: ListView.separated(
          itemCount: _listItems.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: ListTile(
                title: _listItems[index].build(context),
              ),
              onTap: () {
                _openBook(context, _listItems[index]);
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey,
            );
          }),
    );
  }

  Future<List<ListItem>> loadBooks() async {
    DatabaseProvider databaseHelper = DatabaseProvider();
    List<ListItem> listItems = await databaseHelper.getBookListItem();
    return listItems;
  }

  _openBook(BuildContext context, ListItem listItem) {
    if (listItem.runtimeType == BookItem) {
      BookItem bookItem = listItem;
      Navigator.pushNamed(context, ReaderRoute,
          arguments: {'book': bookItem.book});
    }
  }
}
