import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:tipitaka_myanmar/business_logic/models/search_result.dart';
import 'package:tipitaka_myanmar/utils/mm_number.dart';

class SearchListTile extends StatelessWidget {
  final SearchResult result;
  final String textToHighlight;

  const SearchListTile({Key key, this.result, this.textToHighlight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${result.book.name}၊ နှာ - ${MmNumber.get(result.pageNumber)}',
            textAlign: TextAlign.left,
            style:
                TextStyle(fontSize: 16, color: Theme.of(context).accentColor),
          ),
          SubstringHighlight(
            text: result.description,
            textStyle: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyText2.color),
            term: textToHighlight,
            textStyleHighlight:
                TextStyle(fontSize: 18, color: Theme.of(context).accentColor),
          )
        ],
      ),
    );
  }
}
