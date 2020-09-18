import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_myanmar/business_logic/models/book.dart';
import 'package:tipitaka_myanmar/business_logic/models/bookmark.dart';
import 'package:tipitaka_myanmar/business_logic/models/recent.dart';
import 'package:tipitaka_myanmar/services/database/database_provider.dart';
import 'package:tipitaka_myanmar/services/repositories/bookmark_repo.dart';
import 'package:tipitaka_myanmar/services/repositories/recent_repo.dart';
import 'package:tipitaka_myanmar/services/storage/asset_book_provider.dart';
import 'package:tipitaka_myanmar/utils/mm_number.dart';
import 'package:tipitaka_myanmar/utils/shared_preferences_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

const kdartTheme = 'default_dark_theme';
const kblackTheme = 'black';
const String kGotoID = 'goto_001';

class ReaderViewModel with ChangeNotifier {
  final Book book;
  final String textToHighlight;
  int currentPage;
  List<String> pages;
  int numberOfPage;
  int _fontSize;
  String _cssFont;
  String _cssData;
  bool loadFinished = false;
  PageController pageController;
  WebViewController webViewController;
  final BuildContext context;

  ReaderViewModel({
    this.context,
    this.book,
    this.currentPage,
    this.textToHighlight,
  });

  Future<void> loadAllData() async {
    print('loading all required data');
    final fontName = 'NotoSansMyanmar-Regular.otf';
    _cssFont = await loadCssFont(fontName: fontName);
    _fontSize = await loadFontSize();
    _cssData = await loadCssData();
    pages = await loadBook(book.id);
    book.firstPage = 1;
    book.lastPage = pages.length;
    numberOfPage = pages.length;
    notifyListeners();
    print('number of pages: ${pages.length}');
    print('loading finished');
  }

  Future<ByteData> loadFont(String fontName) async {
    return await AssetsProvider.loadFont(fontName);
  }

  Future<String> loadCssFont(
      {@required String fontName,
      String fontExt = 'otf',
      String fontMineType = 'font/truetype'}) async {
    final fontData = await loadFont(fontName);
    final buffer = fontData.buffer;
    final fontUri = Uri.dataFromBytes(
            buffer.asUint8List(fontData.offsetInBytes, fontData.lengthInBytes),
            mimeType: fontMineType)
        .toString();
    return '@font-face { font-family: NotoSansMyanmar; src: url($fontUri); }';
  }

  Future<String> loadCssData() async {
    final cssFileName = _isDarkTheme() ? 'style_night.css' : 'style_day.css';

    return await AssetsProvider.loadCSS(cssFileName);
  }

  Future<List<String>> loadBook(String bookID) async {
    final content = await AssetsProvider.loadBook(bookID);
    return _getPages(content);
  }

  List<String> _getPages(String content) {
    String pageBreakMarker = '--';
    final List<String> pages = content.split(pageBreakMarker);
    pages.remove(0);
    pages.removeLast();
    return pages;
  }

  Uri getPageContent(int index) {
    String pageContent = pages[index];
    if (textToHighlight != null) {
      pageContent = pageContent.replaceAll(
          textToHighlight, '<span class="highlight">$textToHighlight</span>');
      pageContent = pageContent.replaceFirst(
          '<span class="highlight">', '<span class="highlight" id="$kGotoID">');
    }
    return Uri.dataFromString('''
    <!DOCTYPE html>
          <html>
          <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
          <style>
          html {font-size: $_fontSize%}
          $_cssFont
          $_cssData
          </style>
          <body>
          <p>${MmNumber.get(index + 1)}</p>
          $pageContent
          </body>
          </html>
    ''', mimeType: 'text/html', encoding: Encoding.getByName('utf-8'));
  }

  Future onPageChanged(int index) async {
    currentPage = index + 1;
    notifyListeners();
    await _saveToRecent();
  }

  Future setCurrentPage(double value) async {
    currentPage = value.toInt();
    notifyListeners();
    await _saveToRecent();
  }

  Future gotoPage(double value) async {
    currentPage = value.toInt();
    pageController.jumpToPage(currentPage - 1);
    await _saveToRecent();
  }

  Future<int> loadFontSize() async {
    return await SharedPrefProvider.getInt(key: 'font-size');
  }

  void increaseFontSize() {
    _fontSize += 5;
    webViewController.loadUrl(getPageContent(currentPage - 1).toString());
    SharedPrefProvider.setInt(key: 'font-size', value: _fontSize);
  }

  void decreaseFontSize() {
    _fontSize -= 5;
    webViewController.loadUrl(getPageContent(currentPage - 1).toString());
    SharedPrefProvider.setInt(key: 'font-size', value: _fontSize);
  }

  bool _isDarkTheme() {
    final themeID = ThemeProvider.themeOf(context).id;
    return (themeID == kdartTheme || themeID == kblackTheme);
  }

  void saveToBookmark(String note) {
    BookmarkRepository repository =
        BookmarkDatabaseRepository(DatabaseProvider());
    repository.insert(Bookmark(book.id, currentPage, note));
  }

  Future _saveToRecent() async {
    final DatabaseProvider databaseProvider = DatabaseProvider();
    final RecentRepository recentRepository =
        RecentDatabaseRepository(databaseProvider);
    recentRepository.insertOrUpdate(Recent(book.id, currentPage));
  }
}
