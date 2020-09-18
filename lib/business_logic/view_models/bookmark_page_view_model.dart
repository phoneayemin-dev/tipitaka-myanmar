import 'package:flutter/material.dart';
import 'package:tipitaka_myanmar/app.dart';
import 'package:tipitaka_myanmar/business_logic/models/book.dart';
import 'package:tipitaka_myanmar/business_logic/models/bookmark.dart';
import 'package:tipitaka_myanmar/services/database/database_provider.dart';
import 'package:tipitaka_myanmar/services/repositories/bookmark_repo.dart';

class BookmarkPageViewModel extends ChangeNotifier {
  List<Bookmark> bookmarks = [];

  Future<void> fetchBookmarks() async {
    bookmarks =
        await BookmarkDatabaseRepository(DatabaseProvider()).getBookmarks();
    notifyListeners();
  }

  Future<void> delete(int index) async {
    final bookmark = bookmarks[index];
    bookmarks.removeAt(index);
    notifyListeners();
    await BookmarkDatabaseRepository(DatabaseProvider()).delete(bookmark);
  }

  Future<void> deleteAll() async {
    bookmarks.clear();
    notifyListeners();
    await BookmarkDatabaseRepository(DatabaseProvider()).deleteAll();
  }

    void openBook(Bookmark bookmark, BuildContext context) {
    final book = Book(bookmark.bookID, bookmark.bookName);
    Navigator.pushNamed(context, ReaderRoute,
        arguments: {'book': book, 'currentPage': bookmark.bookName});
  }
}
