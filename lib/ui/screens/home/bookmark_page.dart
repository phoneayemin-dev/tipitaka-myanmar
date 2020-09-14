import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/business_logic/view_models/bookmark_page_view_model.dart';
import 'package:tipitaka_myanmar/ui/screens/home/widgets/bookmark_list_tile.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookmarkPageViewModel>(
      create: (context) {
        BookmarkPageViewModel vm = BookmarkPageViewModel();
        vm.fetchBookmarks();
        return vm;
      },
      child: Scaffold(
        appBar: BaseAppBar(),
        body: Consumer<BookmarkPageViewModel>(
          builder: (context, vm, child) {
            return vm.bookmarks.isEmpty
                ? Center(child: Text('မှတ်ထားသည်များ မရှိပါ'))
                : ListView.separated(
                    itemCount: vm.bookmarks.length,
                    itemBuilder: (context, index) {
                      return BookmarkListTile(
                          bookmarkViewmodel: vm, index: index);
                    },separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey,
                  );
                });
          },
        ),
      ),
    );
  }
}

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BookmarkPageViewModel>(context, listen: false);
    return AppBar(
      title: Text('မှတ်သားချက်များ'),
      actions: [
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final result = await showOkCancelAlertDialog(
                  context: context,
                  message: 'မှတ်စုအားလုံးကို ဖျက်ရန် သေချာပြီလား',
                  cancelLabel: 'မဖျက်တော့ဘူး',
                  okLabel: 'ဖျက်မယ်');
              if (result == OkCancelResult.ok) {
                vm.deleteAll();
              }
            })
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}
