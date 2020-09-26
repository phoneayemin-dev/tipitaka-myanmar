import 'package:sqflite/sql.dart';
import 'package:tipitaka_myanmar/business_logic/models/recent.dart';
import 'package:tipitaka_myanmar/services/dao/recent_dao.dart';
import 'package:tipitaka_myanmar/services/database/database_provider.dart';

abstract class RecentRepository {
  DatabaseProvider databaseProvider;

  Future<int> insertOrReplace(Recent recent);

  Future<int> delete(Recent recent);

  Future<int> deleteAll();

  Future<List<Recent>> getRecents();
}

class RecentDatabaseRepository implements RecentRepository {
  final dao = RecentDao();
  @override
  DatabaseProvider databaseProvider;

  RecentDatabaseRepository(this.databaseProvider);

  @override
  Future<int> insertOrReplace(Recent recent) async {
    final db = await databaseProvider.database;
    // var result = await db.update(dao.tableName, dao.toMap(recent),
    //     where: '${dao.columnBookId} = ?', whereArgs: [recent.bookID]);
    // print('update result: $result');
    // if (result == 0) {
    //   result = await db.insert(dao.tableName, dao.toMap(recent));
    // }

    var result = await db.delete(dao.tableName,
        where: '${dao.columnBookId} = ?', whereArgs: [recent.bookID]);
    result = await db.insert(dao.tableName, dao.toMap(recent),
        conflictAlgorithm: ConflictAlgorithm.ignore);

    return result;
  }

  @override
  Future<int> delete(Recent recent) async {
    final db = await databaseProvider.database;
    return await db.delete(dao.tableName,
        where: '${dao.columnBookId} = ?', whereArgs: [recent.bookID]);
  }

  @override
  Future<int> deleteAll() async {
    final db = await databaseProvider.database;
    return await db.delete(dao.tableName);
  }

  @override
  Future<List<Recent>> getRecents() async {
    final db = await databaseProvider.database;
    List<Map> maps = await db.rawQuery('''
      SELECT ${dao.columnBookId}, ${dao.columnPageNumber}, ${dao.columnBookName}
      FROM ${dao.tableName}
      INNER JOIN book ON book.id = ${dao.tableName}.${dao.columnBookId}
      ''');
    return dao.fromList(maps).reversed.toList();
  }
}
