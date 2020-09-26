import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_myanmar/app.dart';
import 'package:tipitaka_myanmar/business_logic/models/list_item.dart';
import 'package:tipitaka_myanmar/business_logic/view_models/home_page_view_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('ပိဋကတ်သုံးပုံမြန်မာပြန်')),
        actions: [
          IconButton(
              icon: Icon(Icons.palette),
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) => ThemeConsumer(
                          child: ThemeDialog(
                        hasDescription: false,
                      )))),
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                _showAboutDialog(context);
              })
        ],
      ),
      body: FutureBuilder(
        future: HomePageViewModel().fecthItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final listItems = snapshot.data;
            return ListView.separated(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: ListTile(
                      title: listItems[index].build(context),
                    ),
                    onTap: () => _openBook(context, listItems[index]),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey,
                  );
                });
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _openBook(BuildContext context, ListItem listItem) {
    if (listItem.runtimeType == BookItem) {
      BookItem bookItem = listItem;
      print('book name: ${bookItem.book.name}');
      Navigator.pushNamed(context, ReaderRoute,
          arguments: {'book': bookItem.book});
    }
  }

  _showAboutDialog(BuildContext context) {
    showAboutDialog(context: context,
        applicationName: 'ပိဋကတ်သုံးပုံ ပါဠိတော် မြန်မာပြန်',
        applicationVersion: 'ဗားရှင်း။ ။ ၁.၁.၀',
        children: [
          Text('''
                  ကျမ်းစာများ
          အချို့သောပါဠိတော်ကျမ်းများအတွက် မြန်မာပြန်မရှိပါ။ ဥပမာ - ပဋ္ဌာန်းကျမ်းစသည်

                  စာမျက်နှာများ
          ပိဋကတ်မြန်မာပြန်ကျမ်းစာအုပ်များကို အကြိမ်များစွာ ထုတ်ဝေခဲ့ရာတွင် တကြိမ်နှင့်တကြိမ် စာမျက်နှာအရေအတွက် မတူပါ။ (တူသည့်အကြိမ်လည်း တူ) ထို့ကြောင့် ဆဋ္ဌမူပါဠိစာအုပ်တို့ကဲ့သို့ စာမျက်နှာကိုးကားရန် အဆင်မပြေနိုင်ကြောင်း အသိပေးပါသည်။
          နောင်အလျဉ်းသင့်က ၂၀၁၁ မူနှင့် စာမျက်နှာ တူညီအောင် ပြုလုပ်ဘို့ ကြံထားပါသည်။

                  စာရှာ
          ယူနီကုဒ်အသုံးပြု၍ ရှာနိုင်ပါသည်။
          ''')
        ]);
  }

}
