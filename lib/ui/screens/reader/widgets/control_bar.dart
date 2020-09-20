import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
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
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => _openGotoDialog(context, vm)),
          ),
          Expanded(child: MySlider()),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
                icon: Icon(Icons.toc),
                onPressed: () {
                  _openTocDialog(context, vm);
                }),
          )
        ],
      ),
    );
  }

  void _openGotoDialog(BuildContext context, ReaderViewModel vm) async {
    final firstParagraph = await vm.getFirstParagraph();
    final lastParagraph = await vm.getLastParagraph();
    final gotoResult = await showDialog<GotoDialogResult>(
      context: context,
      builder: (BuildContext context) => GotoDialog(
        firstPage: vm.book.firstPage,
        lastPage: vm.book.lastPage,
        firstParagraph: firstParagraph,
        lastParagraph: lastParagraph,
      ),
    );
    final int pageNumber = gotoResult.type == GotoType.page
        ? gotoResult.number
        : await vm.getPageNumber(gotoResult.number);
    vm.gotoPage(pageNumber.toDouble());
    // if (pageNumber != null) {
    //   vm.gotoPage(pageNumber.toDouble());
    // }
  }

  void _openTocDialog(BuildContext context, ReaderViewModel vm) async {
    int pageNumber = await showBarModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        expand: false,
        context: context,
        builder: (context, _) {
          return ThemeConsumer(child: TocDialog(vm.book.id));
        });
    if (pageNumber != null) {
      vm.gotoPage(pageNumber.toDouble());
    }
  }
}
