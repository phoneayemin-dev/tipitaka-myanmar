import 'package:tipitaka_myanmar/business_logic/models/book.dart';
import 'package:tipitaka_myanmar/business_logic/models/search_result.dart';
import 'package:tipitaka_myanmar/services/database/database_provider.dart';
import 'package:tipitaka_myanmar/services/repositories/book_repo.dart';
import 'package:tipitaka_myanmar/services/storage/asset_book_provider.dart';

class SearchProvider {
  static Future<List<SearchResult>> getResults(String searchWord) async {
    List<SearchResult> results = List<SearchResult>();
    DatabaseProvider databaseProvider = DatabaseProvider();
    BookRepository bookRepository = BookDatabaseRepository(databaseProvider);
    List<Book> books = await bookRepository.getAllBooks();
    for (int i = 0; i < books.length; i++) {
      String bookContent = await AssetsProvider.loadBook(books[i].id);
      bookContent = _removeAllHtmlTags(bookContent);
      List<String> pages = bookContent.split('--');
      // pages.removeAt(0);
      pages.removeLast();
      // print('number of page: ${pages.length}');
      for (int j = 0; j < pages.length; j++) {
        int start = 0;
        while (true) {
          int index = pages[j].indexOf(searchWord, start);
          if (index == -1) {
            break;
          } else {
            // print('${books[i].name} page-$j');
            // print('found at $index');
            String description =
                _extractDescription(pages[j], index, searchWord);
            start = (index + 1);
            final book = Book(books[i].id, books[i].name);
            results.add(SearchResult(searchWord, description, book, j + 1));
          }
        }
      }
    }
    return results;
  }

  static String _removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  static String _extractDescription(
      String pageContent, int index, String searchWord) {
    int length = pageContent.length;
    int startIndexOfQuery = index;
    int endIndexOfQuery = startIndexOfQuery + searchWord.length;
    int briefCharCount = 65;
    int counter = 1;

    while (startIndexOfQuery - counter >= 0 && counter < briefCharCount) {
      counter++;
    }
    int startIndexOfBrief = startIndexOfQuery - (counter - 1);

    counter = 1; //reset counter
    while (endIndexOfQuery + counter < length && counter < briefCharCount) {
      counter++;
    }
    int endIndexOfBrief = endIndexOfQuery + (counter - 1);

    return pageContent.substring(startIndexOfBrief, endIndexOfBrief);
  }
}
