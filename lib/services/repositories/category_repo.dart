import 'package:tipitaka_myanmar/business_logic/models/category.dart';
import 'package:tipitaka_myanmar/services/dao/catergory_dao.dart';
import 'package:tipitaka_myanmar/services/database/database_provider.dart';

abstract class CategoryRepository {
  DatabaseProvider databaseProvider;
  Future<List<Category>> getCategories();
}

class CategoryDatabaseRepository implements CategoryRepository {
  final dao = CategoryDao();
  @override
  DatabaseProvider databaseProvider;
  CategoryDatabaseRepository(this.databaseProvider);

  @override
  Future<List<Category>> getCategories() async {
    final db = await databaseProvider.database;
    List<Map> maps = await db.query(
      dao.tableName,
      columns: [dao.columnID, dao.columnName]
    );
    return dao.fromList(maps);
  }
}
