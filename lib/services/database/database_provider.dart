import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tipitaka_myanmar/business_logic/models/book.dart';
import 'package:tipitaka_myanmar/business_logic/models/category.dart';
import 'package:tipitaka_myanmar/business_logic/models/list_item.dart';
import 'package:tipitaka_myanmar/business_logic/models/toc.dart';

const String TABLE_CATEGORY = 'category';
const String TABLE_BOOK = 'book';
const String TABLE_PARA_PAGE_MAP = 'para_page_map';
const String TABLE_TOC = 'toc';
const String TABLE_MATCH_BOOKS = 'match_books';
const String TABLE_BOOKMARK = 'bookmark';
const String TABLE_RECENT = 'recent';
const String COLUMN_CATEGORYID = 'category_id';
const String COLUMN_ID = 'id';
const String COLUMN_NAME = 'name';
const String COLUMN_FIRST_PAGE = 'first_page';
const String COLUMN_LAST_PAGE = 'last_page';
const String COLUMN_BOOK_ID = 'book_id';
const String COLUMN_MM_BOOK_ID = 'mm_book_id';
const String COLUMN_PALI_BOOK_ID = 'pali_book_id';
const String COLUMN_PAGE_NUMBER = 'page_number';
const String COLUMN_PARAGRAPH_NUMBER = 'paragraph_number';
const String COLUMN_TYPE = 'type';

class DatabaseProvider {
  static final String _assetsFolder = 'assets';
  static final String _databasePath = 'database';
  static final String _databaseName = 'tipi_mm.db';

  DatabaseProvider._internal();
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  factory DatabaseProvider() => _instance;

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

// Open Assets Database
  _initDatabase() async {
    print('initializing Database');
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, _databaseName);

    var exists = await databaseExists(path);
    if (!exists) {
      print('creating new copy from asset');
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle
          .load(join(_assetsFolder, _databasePath, _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print('opening existing database');
    }
    // Read ONLY for dictionary
    print('opening Database ...');
    return await openDatabase(path);
  }

  Future<List<ListItem>> getBookListItem() async {
    List<ListItem> bookListIem = [];
    var dbClient = await database;
    List<Map<String, dynamic>> maps =
        await dbClient.query(TABLE_CATEGORY, columns: [
      COLUMN_ID,
      COLUMN_NAME,
    ]);
    List<Category> categories =
        List.generate(maps.length, (index) => Category.fromMap(maps[index]));
    for (int i = 0; i < categories.length; i++) {
      bookListIem.add(CategoryItem(categories[i]));
      List<BookItem> books = await _getBooks(categories[i]);
      bookListIem.addAll(books);
    }
    return bookListIem;
  }

  Future<List<BookItem>> _getBooks(Category category) async {
    var dbClient = await database;
    List<Map<String, dynamic>> maps = await dbClient.query(TABLE_BOOK,
        columns: [COLUMN_ID, COLUMN_NAME, COLUMN_FIRST_PAGE, COLUMN_LAST_PAGE],
        where: "$COLUMN_CATEGORYID = ?",
        whereArgs: [category.id]);
    return List.generate(
        maps.length, (index) => BookItem(Book.fromMap(maps[index])));
  }

  Future<Map<int, int>> getParagraphs(String bookID) async {
    var dbClient = await database;
    List<Map<String, dynamic>> maps = await dbClient.query(TABLE_PARA_PAGE_MAP,
        columns: [
          COLUMN_PARAGRAPH_NUMBER,
          COLUMN_PAGE_NUMBER,
        ],
        where: "$COLUMN_BOOK_ID = ?",
        whereArgs: [bookID]);
    Map<int, int> paraPageMap = Map();
    for (Map map in maps) {
      final int paragraphNumber = map[COLUMN_PARAGRAPH_NUMBER];
      final int pageNumber = map[COLUMN_PAGE_NUMBER];
      // some book contains duplicate paragraph number
      if (!paraPageMap.containsKey(paragraphNumber)) {
        paraPageMap[paragraphNumber] = pageNumber;
      }
    }
    return paraPageMap;
  }

  Future<List<Toc>> getTOC(String bookID) async {
    var dbClient = await database;
    List<Map<String, dynamic>> maps = await dbClient.query(TABLE_TOC,
        columns: [
          COLUMN_NAME,
          COLUMN_TYPE,
          COLUMN_PAGE_NUMBER,
        ],
        where: "$COLUMN_BOOK_ID = ?",
        whereArgs: [bookID]);

    return List.generate(maps.length, (index) => Toc.fromMap(maps[index]));
  }

  Future close() async {
    return _database.close();
  }
}
