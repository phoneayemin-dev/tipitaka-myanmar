import 'package:tipitaka_myanmar/business_logic/models/bookmark.dart';
import 'package:tipitaka_myanmar/services/dao/dao.dart';

class BookmarkDao extends Dao<Bookmark> {
  final tableName = 'bookmark';
  final columnBookId = 'book_id';
  final columnPageNumber = 'page_number';
  final columnNote = 'note';
  final columnBookName = 'name'; // from book table

  @override
  Bookmark fromMap(Map<String, dynamic> query) {
    return Bookmark(query[columnBookId], query[columnPageNumber],
        query[columnNote], query[columnBookName]);
  }

  @override
  Map<String, dynamic> toMap(Bookmark object) {
    return {
      columnBookId: object.bookID,
      columnPageNumber: object.pageNumber,
      columnNote: object.note
    };
  }

  @override
  List<Bookmark> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }
}
