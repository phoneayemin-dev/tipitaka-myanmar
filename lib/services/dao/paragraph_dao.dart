import 'package:tipitaka_myanmar/services/dao/dao.dart';
import 'package:tipitaka_myanmar/services/database/database_provider.dart';
import 'package:tipitaka_myanmar/services/repositories/paragraph_repo.dart';

class ParagraphDao implements Dao {
  final tableName = 'para_page_map';
  final columnBookId = 'book_id';
  final columnParagraphNumber = 'paragraph_number';
  final columnPageNumber = 'page_number';


  @override
  List fromList(List<Map<String, dynamic>> query) {}

  @override
  fromMap(Map<String, dynamic> query) {}

  @override
  Map<String, dynamic> toMap(object) {}
}
