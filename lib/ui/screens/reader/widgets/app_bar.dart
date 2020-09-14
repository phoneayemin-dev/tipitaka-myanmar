import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/business_logic/view_models/reader_view_model.dart';

class ReaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReaderAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ReaderViewModel>(context, listen: false);
    return AppBar(
      title: Text('${vm.book.name}'),
      actions: [
        IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: vm.increaseFontSize),
        IconButton(
            icon: Icon(Icons.remove_circle_outline),
            onPressed: vm.decreaseFontSize),
        IconButton(
            icon: Icon(Icons.book_outlined),
            onPressed: () {
              _addBookmark(vm, context);
            }),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);

  void _addBookmark(ReaderViewModel vm, BuildContext context) async {
    final texts = await showTextInputDialog(
        context: context,
        title: 'စာမှတ်',
        textFields: const [DialogTextField(hintText: 'မှတ်လိုသောစာသား ထည့်ပါ')],
        okLabel: 'မှတ်သားမယ်',
        cancelLabel: 'မမှတ်တော့ဘူး');
    if (texts != null) {
      vm.saveToBookmark(texts[0]);
    }
  }
}
