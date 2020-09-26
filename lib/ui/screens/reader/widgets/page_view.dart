import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_myanmar/business_logic/view_models/reader_view_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('building pageview');
    final vm = Provider.of<ReaderViewModel>(context);
    final _pageController = PageController(
        initialPage: vm.currentPage - 1, viewportFraction: 0.999);

    if (vm.pages == null) {
      return Container();
    } else {
      print('page length: ${vm.pages.length}');
      vm.pageController = _pageController;
      return PageView.builder(
        physics: RangeMaintainingScrollPhysics(),
        allowImplicitScrolling: true,
        // preloadPagesCount: 2,
        controller: _pageController,
        itemCount: vm.pages.length,
        itemBuilder: (context, index) {
          // print('building page ${index + 1}');
          return WebView(
            initialUrl: vm.getPageContent(index).toString(),
            javascriptMode: JavascriptMode.unrestricted,
            gestureRecognizers: Set()
              ..add(Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer())),
            onWebViewCreated: (controller) =>
                vm.webViewControllers[index] = controller,
            onPageFinished: (_) {
              vm.webViewControllers[index].evaluateJavascript('''
                      var goto = document.getElementById("goto_001");
                      if(goto != null){
                        goto.scrollIntoView();
                      }
                      ''');
            },
          );
        },
        onPageChanged: vm.onPageChanged,
      );
    }
  }
}
