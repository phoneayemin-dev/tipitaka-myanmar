import 'package:tipitaka_myanmar/business_logic/models/category.dart';
import 'package:tipitaka_myanmar/services/dao/dao.dart';

class CategoryDao implements Dao<Category> {
  final String tableName = 'category';
  final String columnID = 'id';
  final String columnName = 'name';
  @override
  List<Category> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  Category fromMap(Map<String, dynamic> query) {
    return Category(query[columnID], query[columnName]);
  }

  @override
  Map<String, dynamic> toMap(Category object) {
    throw UnimplementedError();
  }
}
