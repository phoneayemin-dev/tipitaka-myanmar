import 'package:tipitaka_myanmar/services/database/database_provider.dart';

class Toc {
  String name;
  int type;
  int pageNumber;

  Toc(this.name, this.type, this.pageNumber);

  Toc.fromMap(Map<String, dynamic> map) {
    this.name = map[COLUMN_NAME];
    this.type = map[COLUMN_TYPE];
    this.pageNumber = map[COLUMN_PAGE_NUMBER];
  }
}
