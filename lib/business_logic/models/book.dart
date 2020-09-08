import 'package:tipitaka_myanmar/services/database/database_provider.dart';

class Book {
  String id;
  String name;
  int firstPage;
  int lastPage;

  Book(this.id, this.name, {this.firstPage, this.lastPage});
  Map<String, dynamic> toMap(){
        return {
      COLUMN_ID: id,
      COLUMN_NAME: name,
      COLUMN_FIRST_PAGE: firstPage,
      COLUMN_LAST_PAGE: lastPage,
    };
  }
  Book.fromMap(Map<String, dynamic> map){
    this.id = map[COLUMN_ID];
    this.name = map[COLUMN_NAME];
    this.firstPage =map[COLUMN_FIRST_PAGE];
    this.lastPage =map[COLUMN_LAST_PAGE];
  }
}
