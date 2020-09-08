import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tipitaka_myanmar/business_logic/view_models/recent_list_view_model.dart';
import 'package:tipitaka_myanmar/utils/mm_number.dart';

class RecentListTile extends StatelessWidget {
  final RecentListViewModel vm;
  final int index;
  RecentListTile(this.vm, this.index);

  @override
  Widget build(BuildContext context) {
    final recent = vm.recents[index];
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          icon: Icons.delete,
          color: Colors.red,
          onTap: () => vm.delete(index),
        )
      ],
      child: ListTile(
        title: Text(recent.bookName),
        trailing: Container(
          width: 80,
          child: Row(
            children: [
              Text('နှာ - '),
              Expanded(
                  child: Text(
                '${MmNumber.get(recent.pageNumber)}',
                textAlign: TextAlign.end,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
