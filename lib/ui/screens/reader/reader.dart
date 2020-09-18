import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/business_logic/models/book.dart';
import 'package:tipitaka_myanmar/business_logic/view_models/reader_view_model.dart';
import 'package:tipitaka_myanmar/ui/screens/reader/widgets/app_bar.dart';
import 'package:tipitaka_myanmar/ui/screens/reader/widgets/control_bar.dart';
import 'package:tipitaka_myanmar/ui/screens/reader/widgets/page_view.dart';

class Reader extends StatelessWidget {
  final Book book;
  final int currentPage;
  final String textToHighlight;
  const Reader({Key key, @required this.book, this.currentPage, this.textToHighlight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('current Page in Reader Screen: $currentPage');
    print('textToHighlight in Reader Screen: $textToHighlight');

    return ChangeNotifierProvider<ReaderViewModel>(
      create: (context) {
        ReaderViewModel vm = ReaderViewModel(
            context: context, book: book, currentPage: currentPage, textToHighlight: textToHighlight);
        // vm.currentPage = 1;
        vm.loadAllData();
        return vm;
      },
      child: Scaffold(
        appBar: ReaderAppBar(),
        body: MyPageView(),
        bottomNavigationBar: ControlBar(),
      ),
    );
  }
}
