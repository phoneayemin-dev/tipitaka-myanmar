import 'package:tipitaka_myanmar/business_logic/models/bookmark.dart';
import 'package:tipitaka_myanmar/services/dao/bookmark_dao.dart';
import 'package:tipitaka_myanmar/services/database/database_provider.dart';

abstract class BookmarkRepository {
  DatabaseProvider databaseProvider;

  Future<int> insert(Bookmark bookmark);
  
  Future<int> delete(Bookmark bookmark);

  Future<int> deleteAll();

  Future<List<Bookmark>> getBookmarks();
}

class BookmarkDatabaseRepository extends BookmarkRepository {
  
  final dao = BookmarkDao();

  @override
  DatabaseProvider databaseProvider;

  BookmarkDatabaseRepository(this.databaseProvider);

  @override
  Future<int> insert(Bookmark bookmark) async {
    final db = await databaseProvider.database;
    return await db.insert(dao.tableName, dao.toMap(bookmark));
  }

  @override
  Future<int> delete(Bookmark bookmark) async {
    final db = await databaseProvider.database;
    return await db.delete(dao.tableName,
        where: '${dao.columnBookId} = ?', whereArgs: [bookmark.bookID]);
  }

@override
  Future<int> deleteAll() async {
    final db = await databaseProvider.database;
    return await db.delete(dao.tableName);
  }

  @override
  Future<List<Bookmark>> getBookmarks() async{
    final db = await databaseProvider.database;
    var maps = await db.rawQuery('''
      SELECT ${dao.columnBookId}, ${dao.columnPageNumber}, ${dao.columnNote}, ${dao.columnBookName}
      FROM ${dao.tableName}
      INNER JOIN book ON book.id = ${dao.tableName}.${dao.columnBookId}
      ''');
    return dao.fromList(maps);
  }
}