import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/business_logic/view_models/search_page_view_model.dart';
import 'package:tipitaka_myanmar/ui/screens/home/widgets/search_bar.dart';
import 'package:tipitaka_myanmar/ui/screens/home/widgets/search_list_tile.dart';
import 'package:tipitaka_myanmar/utils/mm_number.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchViewModel>(
      create: (_) => SearchViewModel(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('စာရှာ'),
          ),
          body: Consumer<SearchViewModel>(builder: (context, vm, child) {
            return Column(
              children: [
                Expanded(
                    child: vm.results == null
                        ? Container()
                        : ListView.separated(
                            itemCount: vm.results.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: SearchListTile(
                                    result: vm.results[index],
                                    textToHighlight: vm.searchWord),
                                onTap: () {
                                  vm.openBook(vm.results[index], context);
                                },
                              );
                            },
                            separatorBuilder: (context, index) => Divider(),
                          )),
                SearchBar(onSubmitted: (searchWord) async {
                  if (searchWord.trim().isNotEmpty) {
                    final progressDialog = ProgressDialog(context);
                    progressDialog.style(
                      message: 'ရှာနေဆဲ ...',
                    );
                    await progressDialog.show();
                    await vm.doSearch(searchWord.trim());
                    await progressDialog.hide();
                    final info = vm.results.isEmpty
                        ? 'ရှာမတွေ့ပါ'
                        : 'တွေ့ရှိမှု - ${MmNumber.get(vm.results.length)} ကြိမ်';
                    final snackBar = SnackBar(content: Text(info));
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                }),
              ],
            );
          })),
    );
  }
}
