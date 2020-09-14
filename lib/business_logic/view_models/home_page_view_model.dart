import 'package:tipitaka_myanmar/business_logic/models/list_item.dart';
import 'package:tipitaka_myanmar/services/database/database_provider.dart';
import 'package:tipitaka_myanmar/services/repositories/book_repo.dart';
import 'package:tipitaka_myanmar/services/repositories/category_repo.dart';

class HomePageViewModel {
  Future<List<ListItem>> fecthItems() async {
    final databaseProvider = DatabaseProvider();
    List<ListItem> listItems = List<ListItem>();
    final categories =
        await CategoryDatabaseRepository(databaseProvider).getCategories();

    for(int i= 0; i < categories.length; ++i){
      listItems.add(CategoryItem(categories[i]));
      final books =
          await BookDatabaseRepository(databaseProvider).getBooks(categories[i].id);
      final bookListItems = books.map((book) => BookItem(book)).toList();
      listItems.addAll(bookListItems);
    }
    return listItems;
  }
}
