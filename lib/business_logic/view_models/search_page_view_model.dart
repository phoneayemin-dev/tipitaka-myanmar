import 'package:flutter/material.dart';
import 'package:tipitaka_myanmar/app.dart';
import 'package:tipitaka_myanmar/business_logic/models/search_result.dart';
import 'package:tipitaka_myanmar/services/search_provider.dart';

class SearchViewModel extends ChangeNotifier {
  List<SearchResult> results;
  bool isSearching = false;
  String _searchWord;

  String get searchWord => _searchWord;

  Future<void> doSearch(String searchWord) async {
    _searchWord = searchWord.trim();
    if (_searchWord.isNotEmpty) {
      if (results != null) {
        results.clear();
      }
      isSearching = true;
      notifyListeners();
      results = await SearchProvider.getResults(_searchWord);
      isSearching = false;
      notifyListeners();
    }
  }

  void openBook(SearchResult result, BuildContext context) {
    Navigator.pushNamed(context, ReaderRoute, arguments: {
      'book': result.book,
      'currentPage': result.pageNumber,
      'textToHighlight': _searchWord
    });
  }
}
