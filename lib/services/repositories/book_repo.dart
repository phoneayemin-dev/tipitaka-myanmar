import 'package:tipitaka_myanmar/services/dao/book_dao.dart';
import 'package:tipitaka_myanmar/services/database/database_provider.dart';
import 'package:tipitaka_myanmar/business_logic/models/book.dart';

abstract class BookRepository {
  DatabaseProvider databaseProvider;
  Future<List<Book>> getBooks(int categoryID);
}

class BookDatabaseRepository implements BookRepository {
  final dao = BookDao();
  @override
  DatabaseProvider databaseProvider;
  BookDatabaseRepository(this.databaseProvider);

  @override
  Future<List<Book>> getBooks(int categoryID) async {
    final db = await databaseProvider.database;
    List<Map> maps = await db.query(dao.tableName,
        columns: [dao.columnID, dao.columnName],
        where: '${dao.colunmCategoryID} = ?',
        whereArgs: [categoryID]);
    return dao.fromList(maps);
  }
}
