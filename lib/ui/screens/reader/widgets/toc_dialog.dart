import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tipitaka_myanmar/business_logic/models/toc.dart';
import 'package:tipitaka_myanmar/business_logic/models/toc_entry.dart';

class TocDialog extends StatelessWidget {
  final List<Toc> tocs;

  const TocDialog(this.tocs);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  List<TocEntry> _buildTocEntryList() {
    List<TocEntry> tocEntries = [];
    int index = 0;
    int length = tocs.length;
    while (index < length) {
      List<Toc> children = _getChildren(index, tocs.sublist(index));
      tocEntries.add(_buildTocEntry(tocs[index], children));
      index = index + children.length;
    }

    return tocEntries;
  }

  TocEntry _buildTocEntry(Toc parentToc, List<Toc> childern) {
    if (childern.isEmpty) {
      return TocEntry(parentToc);
    } else {
      return TocEntry(
          parentToc,
          childern.map(
              (toc) => _buildTocEntry(childern.first, childern.sublist(1))).toList());
    }
  }

  List<Toc> _getChildren(int index, List<Toc> tocs) {
    int parentTocType = tocs[index].type;
    List<Toc> childern = [];
    index += 1;
    while (index < tocs.length) {
      if (tocs[index].type == parentTocType) {
        break;
      } else {
        childern.add(tocs[index]);
        index += 1;
      }
    }
    return childern;
  }
}
