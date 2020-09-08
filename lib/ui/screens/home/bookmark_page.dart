import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tipitaka_myanmar/business_logic/models/bookmark.dart';
import 'package:tipitaka_myanmar/services/database/database_provider.dart';
import 'package:tipitaka_myanmar/services/repositories/bookmark_repo.dart';
import 'package:tipitaka_myanmar/utils/mm_number.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Bookmark> bookmarks = [];

  @override
  void initState() {
    super.initState();
    BookmarkDatabaseRepository(DatabaseProvider()).getBookmarks().then((value) {
      setState(() {
        bookmarks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('မှတ်သားချက်များ'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _removeAll,
          )
        ],
      ),
      body: bookmarks.isEmpty
          ? Center(child: Text('ဖတ်ဆဲစာအုပ်များ မရှိပါ'))
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  secondaryActions: [
                    IconSlideAction(
                      icon: Icons.delete,
                      color: Colors.red,
                      onTap: () {
                        setState(() {
                          BookmarkDatabaseRepository(DatabaseProvider())
                              .delete(bookmarks[index]);
                          bookmarks.removeAt(index);
                        });
                      },
                    )
                  ],
                  child: ListTile(
                    title: Text(bookmarks[index].bookName),
                    trailing: Container(
                      width: 80,
                      child: Row(
                        children: [
                          Text('နှာ - '),
                          Expanded(
                              child: Text(
                            '${MmNumber.get(bookmarks[index].pageNumber)}',
                            textAlign: TextAlign.end,
                          )),
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }

  _removeAll() {
    setState(() {
      bookmarks.clear();
    });
    BookmarkDatabaseRepository(DatabaseProvider()).deleteAll();
  }
}
