import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/business_logic/view_models/reader_view_model.dart';
import 'package:tipitaka_myanmar/ui/dialogs/goto_dialog.dart';
import 'package:tipitaka_myanmar/ui/screens/reader/widgets/slider.dart';
import 'package:tipitaka_myanmar/ui/dialogs/toc_dialog.dart';

class ControlBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('building control bar');
    final vm = Provider.of<ReaderViewModel>(context, listen: false);
    return Container(
      height: 56.0,
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () => _openGotoDialog(context, vm)),
          Expanded(child: MySlider()),
          IconButton(
              icon: Icon(Icons.toc),
              onPressed: () {
                _openTocDialog(context, vm);
              })
        ],
      ),
    );
  }

  void _openGotoDialog(BuildContext context, ReaderViewModel vm) async {
    int pageNumber = await showDialog(
      context: context,
      builder: (BuildContext context) => GotoDialog(vm.book),
    );
    if (pageNumber != null) {
      vm.gotoPage(pageNumber.toDouble());
    }
  }

  void _openTocDialog(BuildContext context, ReaderViewModel vm) async {
    int pageNumber = await showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        expand: false,
        context: context,
        builder: (context, _) {
          return TocDialog(vm.book.id);
        });
    if (pageNumber != null) {
      vm.gotoPage(pageNumber.toDouble());
    }
  }
}
