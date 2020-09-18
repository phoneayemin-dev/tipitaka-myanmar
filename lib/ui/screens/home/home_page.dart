import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_myanmar/app.dart';
import 'package:tipitaka_myanmar/business_logic/models/list_item.dart';
import 'package:tipitaka_myanmar/business_logic/view_models/home_page_view_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('ပိဋကတ်သုံးပုံမြန်မာပြန်')),
        actions: [
          IconButton(
              icon: Icon(Icons.palette),
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) => ThemeConsumer(child: ThemeDialog(hasDescription: false,)))),
                  IconButton(icon: Icon(Icons.info), onPressed: (){})
        ],
      ),
      body: FutureBuilder(
        future: HomePageViewModel().fecthItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final listItems = snapshot.data;
            return ListView.separated(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: ListTile(
                      title: listItems[index].build(context),
                    ),
                    onTap: () => _openBook(context, listItems[index]),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey,
                  );
                });
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _openBook(BuildContext context, ListItem listItem) {
    if (listItem.runtimeType == BookItem) {
      BookItem bookItem = listItem;
      print('book name: ${bookItem.book.name}');
      Navigator.pushNamed(context, ReaderRoute,
          arguments: {'book': bookItem.book});
    }
  }
}
