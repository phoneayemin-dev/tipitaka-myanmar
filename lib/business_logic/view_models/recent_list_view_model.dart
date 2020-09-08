import 'package:flutter/material.dart';
import 'package:tipitaka_myanmar/business_logic/models/recent.dart';
import 'package:tipitaka_myanmar/services/database/database_provider.dart';
import 'package:tipitaka_myanmar/services/repositories/recent_repo.dart';

class RecentListViewModel extends ChangeNotifier {
  List<Recent> recents = [];

  Future<void> fetchRecents() async {
    recents =
        await RecentDatabaseRepository(DatabaseProvider()).getRecents();
    notifyListeners();
  }

  Future<void> delete(int index) async {
    final Recent recent = recents[index];
    recents.removeAt(index);
    notifyListeners();
    await RecentDatabaseRepository(DatabaseProvider()).delete(recent);
  }

  Future<void> deleteAll() async {
    recents.clear();
    notifyListeners();
    await RecentDatabaseRepository(DatabaseProvider()).deleteAll();
  }
}
