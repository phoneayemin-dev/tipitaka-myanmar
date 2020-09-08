import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/business_logic/view_models/recent_list_view_model.dart';
import 'package:tipitaka_myanmar/ui/screens/home/widgets/recent_list_tile.dart';

class RecentPage extends StatefulWidget {
  @override
  _RecentPageState createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<RecentListViewModel>(context, listen: false).fetchRecents();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RecentListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ဖတ်ဆဲစာအုပ်များ'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => vm.deleteAll(),
          )
        ],
      ),
      body: vm.recents.isEmpty
          ? Center(child: Text('ဖတ်ဆဲစာအုပ်များ မရှိပါ'))
          : ListView.builder(
              itemCount: vm.recents.length,
              itemBuilder: (context, index) {
                return RecentListTile(vm, index);
              }),
    );
  }
}
