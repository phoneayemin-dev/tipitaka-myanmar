import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/business_logic/view_models/recent_page_view_model.dart';
import 'package:tipitaka_myanmar/ui/screens/home/widgets/recent_list_tile.dart';


class RecentPage extends StatefulWidget {
  @override
  _RecentPageState createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecentPageViewModel>(
      create: (context) {
        RecentPageViewModel vm = RecentPageViewModel();
        vm.fetchRecents();
        return vm;
      },
      child: Scaffold(
        appBar: BaseAppBar(),
        body: Consumer<RecentPageViewModel>(builder: (context, vm, child) {
          return vm.recents.isEmpty
              ? Center(child: Text('ဖတ်ဆဲစာအုပ်များ မရှိပါ'))
              : ListView.separated(
                  itemCount: vm.recents.length,
                  itemBuilder: (context, index) {
                    return RecentListTile(vm, index);
                  },
                  separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey,
                  );
                });
        }),
      ),
    );
  }

}

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RecentPageViewModel>(context, listen: false);
    return AppBar(
      title: Text('ဖတ်ဆဲကျမ်းစာများ'),
      actions: [
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final result = await showOkCancelAlertDialog(
                  context: context,
                  message: 'ဖတ်ဆဲစာရင်းအားလုံးကို ဖျက်ရန် သေချာပြီလား',
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
