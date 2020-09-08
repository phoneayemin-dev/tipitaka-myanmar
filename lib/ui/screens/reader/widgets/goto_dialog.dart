import 'package:flutter/material.dart';

enum Goto { page, paragraph }

class GotoDialog extends StatefulWidget {
  final int firstPage;
  final int lastPage;
  final int firstParagraph;
  final int lastParagraph;
  final void Function(int, Goto) onSubmit;
  GotoDialog(
      {this.firstPage,
      this.lastPage,
      this.firstParagraph,
      this.lastParagraph,
      this.onSubmit});
  @override
  _GotoDialogState createState() => _GotoDialogState(
      firstPage: firstPage,
      lastPage: lastPage,
      firstParagraph: firstParagraph,
      lastParagraph: lastParagraph,
      onSubmit: onSubmit);
}

class _GotoDialogState extends State<GotoDialog> {
  final int firstPage;
  final int lastPage;
  final int firstParagraph;
  final int lastParagraph;
  final void Function(int, Goto) onSubmit;

  // static const backgroundColor = Colors.blueAccent;
  static const _radius = 16.0;

  int value;
  Goto _selected = Goto.page;

  bool valid = false;
  _GotoDialogState(
      {this.firstPage,
      this.lastPage,
      this.firstParagraph,
      this.lastParagraph,
      this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          side: BorderSide.none, borderRadius: BorderRadius.circular(_radius)),
      elevation: 10.0,
      // backgroundColor: Colors.grey[200],
      child: dialogContent(),
    );
  }

  dialogContent() {
    return Container(
      // height: 350,
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[title(), Divider(),body(), actions()],
      ),
    );
  }

  title() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        'သို့',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
    );
  }

  body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: TextField(
              decoration: InputDecoration(
                  hintText: _selected == Goto.page
                      ? '($firstPage-$lastPage)'
                      : '($firstParagraph-$lastParagraph)'),
              onChanged: validateInput,
              keyboardType: TextInputType.number),
        ),
        ListTile(
          title: const Text('စာမျက်နှာ'),
          leading: Radio(
            value: Goto.page,
            groupValue: _selected,
            onChanged: (Goto value) {
              setState(() {
                _selected = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('စာပိုဒ်'),
          leading: Radio(
            value: Goto.paragraph,
            groupValue: _selected,
            onChanged: (Goto value) {
              setState(() {
                _selected = value;
              });
            },
          ),
        ),
      ],
    );
  }

  actions() {
    return Row(
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
            onPressed: !valid ? null : onPressedGoto,
            child: Text('သွားမယ်'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius - 8),
            ),
          ),
        ),
      ],
    );
  }

  validateInput(String inputString) {
    if (inputString.isEmpty) {
      setState(() => valid = false);
      return;
    }
    value = int.parse(inputString.trim());

    switch (_selected) {
      case Goto.page:
        if (firstPage <= value && value <= lastPage) {
          if (!valid) {
            valid = !valid;
          }
        } else {
          valid = false;
        }
        break;
      case Goto.paragraph:
        if (firstParagraph <= value && value <= lastParagraph) {
          if (!valid) {
            valid = !valid;
          }
        } else {
          valid = false;
        }
        break;
    }
    setState(() {});
  }

  void onPressedGoto() {
    onSubmit(value, _selected);
    Navigator.of(context).pop();
  }
}
