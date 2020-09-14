// import 'dart:convert';

// import 'package:adaptive_dialog/adaptive_dialog.dart';
// import 'package:expandable/expandable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:theme_provider/theme_provider.dart';
// import 'package:tipitaka_myanmar/business_logic/models/book.dart';
// import 'package:tipitaka_myanmar/business_logic/models/bookmark.dart';
// import 'package:tipitaka_myanmar/business_logic/models/recent.dart';
// import 'package:tipitaka_myanmar/business_logic/models/toc.dart';
// import 'package:tipitaka_myanmar/business_logic/models/page.dart' as Pitaka;
// import 'package:tipitaka_myanmar/services/database/database_provider.dart';
// import 'package:path/path.dart';
// import 'package:tipitaka_myanmar/services/repositories/bookmark_repo.dart';
// import 'package:tipitaka_myanmar/services/repositories/recent_repo.dart';
// import 'package:tipitaka_myanmar/ui/screens/reader/widgets/goto_dialog.dart';
// import 'package:tipitaka_myanmar/utils/mm_number.dart';
// import 'package:tipitaka_myanmar/utils/shared_preferences_provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// const pageSplitPattern = '--';

// class Reader extends StatefulWidget {
//   final Book _book;
//   Reader(this._book);

//   @override
//   _ReaderState createState() => _ReaderState(_book);
// }

// class _ReaderState extends State<Reader> {
//   final Book _book;
//   static const _assetPath = "assets/books";
//   final String _fontAssetPath = 'assets/fonts/NotoSansMyanmar-Regular.otf';
//   final String _cssAssetPath = 'assets/web/style_unicode.css';
//   final String _fontMineType = 'font/truetype';
//   List<Pitaka.Page> pages = [];
//   List<Toc> tocs = [];
//   Map paraPageMap;
//   int firstParagraph;
//   int lastParagraph;
//   String cssFont;
//   String cssStyle;
//   int fontSize;
//   int currentPage = 10;
//   PageController _pageController;
//   BuildContext _context;
//   _ReaderState(this._book);

//   @override
//   void initState() {
//     super.initState();
//     print('book name: ${_book.name}');
//     _loadPages(join(_assetPath, '${_book.id}.html'), _fontAssetPath,
//             _fontMineType, _cssAssetPath)
//         .then((value) {
//       setState(() {
//         pages = value;
//         _pageController = PageController(initialPage: currentPage - 1);
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _context = context;

//     return SafeArea(
//       child: Scaffold(
//         appBar: buildAppBar(context),
//         body: pages.isEmpty
//             ? Center(child: CircularProgressIndicator())
//             : PageView.builder(
//                 controller: _pageController,
//                 itemCount: pages.length,
//                 itemBuilder: (context, index) {
//                   print('building page ${index + 1}');
//                   final uri = _uriFromString(buildPage(
//                       pages[index].pageContent, pages[index].pageNumber));
//                   return WebView(
//                     initialUrl: uri.toString(),
//                   );
//                 },
//                 onPageChanged: _onPageChanged,
//               ),
//         bottomNavigationBar: controlBar(),
//       ),
//     );
//   }

//   AppBar buildAppBar(BuildContext context) {
//     return AppBar(
//       title: Text(_book.name),
//       actions: [
//         IconButton(
//             icon: Icon(Icons.add_circle_outline), onPressed: increaseFontSize),
//         IconButton(
//             icon: Icon(Icons.remove_circle_outline),
//             onPressed: decreaseFontSize),
//         IconButton(
//             icon: Icon(Icons.bookmark_outline),
//             onPressed: () async {
//               final texts = await showTextInputDialog(
//                   context: context,
//                   title: 'စာမှတ်',
//                   textFields: const [
//                     DialogTextField(hintText: 'မှတ်လိုသောစာသား ထည့်ပါ')
//                   ],
//                   okLabel: 'မှတ်သားမယ်',
//                   cancelLabel: 'မမှတ်တော့ဘူး');
//               if (texts != null) {
//                 final bookmark = Bookmark(_book.id, currentPage, texts[0]);
//                 BookmarkDatabaseRepository(DatabaseProvider()).insert(bookmark);
//               }
//             })
//       ],
//     );
//   }

//   Widget controlBar() {
//     return Container(
//       height: 56.0,
//       child: Row(
//         children: [
//           IconButton(
//               icon: Icon(Icons.arrow_forward), onPressed: _openGotoDialog),
//           Expanded(child: buildSlider()),
//           IconButton(icon: Icon(Icons.toc), onPressed: _openTocDialog)
//         ],
//       ),
//     );
//   }

//   buildSlider() {
//     var themeData = ThemeProvider.themeOf(_context).data;
//     return SliderTheme(
//       data: SliderThemeData(
//           activeTrackColor: themeData.accentColor,
//           inactiveTrackColor: Colors.grey,
//           thumbColor: themeData.accentColor,
//           trackHeight: 2.0,
//           valueIndicatorColor: themeData.accentColor,
//           valueIndicatorTextStyle: themeData.accentTextTheme.bodyText1),
//       child: Slider(
//         value: currentPage.toDouble(),
//         min: _book.firstPage.toDouble(),
//         max: _book.lastPage.toDouble(),
//         label: currentPage.toString(),
//         divisions: (_book.lastPage - _book.firstPage) + 1,
//         onChanged: (value) {
//           setState(() {
//             currentPage = value.toInt();
//           });
//         },
//         // onChangeStart: null,
//         onChangeEnd: _onSliderChanged,
//       ),
//     );
//   }

//   Uri _uriFromString(String content) {
//     return Uri.dataFromString(content,
//         mimeType: 'text/html', encoding: Encoding.getByName('utf-8'));
//   }

//   String getFontUri(ByteData data, String mime) {
//     final buffer = data.buffer;
//     return Uri.dataFromBytes(
//             buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
//             mimeType: mime)
//         .toString();
//   }

//   Future<List<Pitaka.Page>> _loadPages(String bookAssetPath,
//       String fontAssetPath, String fontMineType, String cssAssetPath) async {
//     final rawHtmlData = await rootBundle.loadString(bookAssetPath);
//     final fontData = await rootBundle.load(fontAssetPath);
//     final fontUri = getFontUri(fontData, fontMineType).toString();
//     fontSize = await SharedPrefProvider.getInt(key: 'font-size');
//     final rawHtmlPages = rawHtmlData.split(pageSplitPattern);
//     cssFont =
//         '@font-face { font-family: NotoSansMyanmar; src: url($fontUri); }';
//     cssStyle = await rootBundle.loadString(cssAssetPath);
//     List<Pitaka.Page> pages = [];
//     for (int i = 0; i < rawHtmlPages.length; i++) {
//       pages.add(Pitaka.Page(i + 1, rawHtmlPages[i]));
//     }

//     // print(paragraphs.last.paragraphNumber);
//     return pages;
//   }

//   String buildPage(String html, int pageNumber) {
//     return '''
//     <!DOCTYPE html>
//           <html>
//           <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
//           <style>
//           html {font-size: $fontSize%}
//           $cssFont
//           $cssStyle
//           </style>
//           <body>
//           <p>${MmNumber.get(pageNumber)}</p>
//           $html
//           </body>
//           </html>
//     ''';
//   }

//   increaseFontSize() {
//     setState(() {
//       fontSize += 5;
//       SharedPrefProvider.setInt(key: 'font-size', value: fontSize);
//     });
//   }

//   decreaseFontSize() {
//     setState(() {
//       fontSize -= 5;
//       SharedPrefProvider.setInt(key: 'font-size', value: fontSize);
//     });
//   }

//   _onPageChanged(int pageIndex) {
//     final int pageNumber = pageIndex + 1;
//     _changePage(pageNumber);
//   }

//   _onSliderChanged(double value) {
//     final int pageNumber = value.toInt();
//     _changePage(pageNumber);
//   }

//   _changePage(int pageNumber) {
//     setState(() {
//       _pageController.jumpToPage(pageNumber - 1);
//       currentPage = pageNumber;
//     });
//     RecentDatabaseRepository(DatabaseProvider())
//         .insertOrUpdate(Recent(_book.id, currentPage));
//   }

//   void _openGotoDialog() async {
//     if (paraPageMap == null) {
//       paraPageMap = await DatabaseProvider().getParagraphs(_book.id);
//       print('para count:${paraPageMap.length}');

//       firstParagraph = paraPageMap.keys.toList().first;
//       lastParagraph = paraPageMap.keys.toList().last;
//       print('first paragraph: $firstParagraph');
//       print('last paragraph: $lastParagraph');
//     }
//     showDialog(
//       context: _context,
//       builder: (BuildContext context) => GotoDialog(
//         firstPage: _book.firstPage,
//         lastPage: _book.lastPage,
//         firstParagraph: firstParagraph,
//         lastParagraph: lastParagraph,
//         onSubmit: onSubmit,
//       ),
//     );
//   }

//   void _openTocDialog() async {
//     if (tocs.isEmpty) {
//       tocs = await DatabaseProvider().getTOC(_book.id);
//     }
//     showMaterialModalBottomSheet(
//       context: _context,
//       builder: (context, scrollController) => ListView(children: [
//         Text('မာတိကာ'),
//         Divider(),
//         GestureDetector(
//           child: ExpandablePanel(
//             header: Text('heading'),
//             expanded: Padding(
//               padding: const EdgeInsets.only(left: 16.0),
//               child: Text('subhead'),
//             ),
//             theme: ExpandableThemeData(tapHeaderToExpand: false),
//           ),
//           onTap: () => print('hell'),
//         ),
//       ]),
//     );
//   }

//   void onSubmit(int value, Goto type) {
//     if (type == Goto.paragraph) {
//       value = paraPageMap[value];
//     }
//     _pageController.jumpToPage(value - 1);
//   }
// }
