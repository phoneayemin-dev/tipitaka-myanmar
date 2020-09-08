import 'package:tipitaka_myanmar/business_logic/models/recent.dart';
import 'package:tipitaka_myanmar/services/dao/dao.dart';

class RecentDao implements Dao<Recent> {
  final tableName = 'recent';
  final columnBookId = 'book_id';
  final columnPageNumber = 'page_number';
  final columnBookName = 'name'; // from book table

  @override
  List<Recent> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  Recent fromMap(Map<String, dynamic> query) {
    return Recent(
        query[columnBookId], query[columnPageNumber], query[columnBookName]);
  }

  @override
  Map<String, dynamic> toMap(Recent object) {
    return <String, dynamic>{
      columnBookId: object.bookID,
      columnPageNumber: object.pageNumber
    };
  }
}
