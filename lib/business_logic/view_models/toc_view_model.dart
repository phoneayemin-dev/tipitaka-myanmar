import 'package:tipitaka_myanmar/business_logic/models/toc.dart';
import 'package:tipitaka_myanmar/business_logic/models/toc_list_item.dart';
import 'package:tipitaka_myanmar/services/database/database_provider.dart';
import 'package:tipitaka_myanmar/services/repositories/toc_repo.dart';

class TocViewModel {
  final String bookID;

  TocViewModel(this.bookID);
  List<TocListItem> listItems;

  Future<List<TocListItem>> fetchTocListItems() async {
    final tocs = await _fetchToc();
    return _fromList(tocs);
  }

  Future<List<Toc>> _fetchToc() async {
    final DatabaseProvider databaseProvider = DatabaseProvider();
    final TocRepository tocRepository = TocDatabaseRepository(databaseProvider);
    return await tocRepository.getTocs(bookID);
  }

  List<TocListItem> _fromList(List<Toc> tocs) {
    List<TocListItem> listItems = List<TocListItem>();
    tocs.forEach((toc) {
      switch (toc.type) {
        case 1:
          listItems.add(TocHeadingOne(toc));
          break;
        case 2:
          listItems.add(TocHeadingTwo(toc));
          break;
        case 3:
          listItems.add(TocHeadingThree(toc));
          break;
        case 4:
          listItems.add(TocHeadingFour(toc));
          break;
        case 5:
          listItems.add(TocHeadingFive(toc));
          break;
        default:
          listItems.add(TocHeadingFive(toc));
          break;
      }
    });
    return listItems;
  }
}
