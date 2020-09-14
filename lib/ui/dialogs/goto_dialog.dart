import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/business_logic/models/book.dart';
import 'package:tipitaka_myanmar/business_logic/view_models/goto_view_model.dart';

class GotoDialog extends StatelessWidget {
  final Book book;
  final double _radius = 16.0;
  GotoDialog(this.book);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GotoViewModel>(
      create: (_) {
        GotoViewModel vm = GotoViewModel(book);
        vm.init();
        return vm;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(_radius)),
        elevation: 10.0,
        child: dialogContent(),
      ),
    );
  }

  Widget dialogContent() {
    return Consumer<GotoViewModel>(builder: (context, vm, child) {
      return Container(
        // height: 350,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'သို့',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            Divider(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                      decoration: InputDecoration(
                          hintText: vm.selected == Goto.page
                              ? vm.pagehintText
                              : vm.parahintText),
                      onChanged: vm.validate,
                      keyboardType: TextInputType.number),
                ),
                ListTile(
                  title: const Text('စာမျက်နှာ'),
                  leading: Radio(
                    value: Goto.page,
                    groupValue: vm.selected,
                    onChanged: vm.setSelected,
                  ),
                ),
                ListTile(
                  title: const Text('စာပိုဒ်'),
                  leading: Radio(
                    value: Goto.paragraph,
                    groupValue: vm.selected,
                    onChanged: vm.setSelected,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 120,
                  margin: EdgeInsets.all(8.0),
                  child: FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('မသွားတော့ဘူး'),
                    // textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_radius - 8),
                    ),
                  ),
                ),
                Container(
                  width: 120,
                  margin: EdgeInsets.all(8.0),
                  child: FlatButton(
                    onPressed: vm.isValid
                        ? () {
                            onClickOK(context, vm);
                          }
                        : null,
                    child: Text('သွားမယ်'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_radius - 8),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  void onClickOK(BuildContext context, GotoViewModel vm) async {
    if (vm.selected == Goto.paragraph) {
      vm.inputValue = await vm.getPageNumber(vm.inputValue);
    }
    Navigator.pop(context, vm.inputValue);
  }
}
