import 'package:tipitaka_myanmar/services/dao/dao.dart';
import 'package:tipitaka_myanmar/business_logic/models/book.dart';

class BookDao implements Dao<Book> {
  final String tableName = 'book';
  final String columnID = 'id';
  final String columnName = 'name';
  @override
  List<Book> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  Book fromMap(Map<String, dynamic> query) {
    return Book(query[columnID], query[columnName]);
  }

  @override
  Map<String, dynamic> toMap(Book object) {
    throw UnimplementedError();
  }
}
