import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/business_logic/view_models/reader_view_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('building pageview');
    final vm = Provider.of<ReaderViewModel>(context);
    final PageController _pageController = PageController(initialPage: vm.currentPage - 1);

    if (vm.pages == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      vm.pageController = _pageController;
      return PageView.builder(
        controller: _pageController,
        itemCount: vm.pages.length,
        itemBuilder: (context, index) {
          print('building page ${index + 1}');
          return WebView(
            initialUrl: vm.getPageContent(index).toString(),
            onWebViewCreated: (controller) => vm.webViewController = controller,
          );
        },
        onPageChanged: vm.onPageChanged,
      );
    }
  }
}
