import 'package:flutter/cupertino.dart';
import 'package:thirteen/screens/discover.dart';

class ThirteenPage extends StatefulWidget {
  ThirteenPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  _ThirteenPageState createState() => _ThirteenPageState();
}

class _ThirteenPageState extends State<ThirteenPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SafeArea(
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(const IconData(0xf449,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage)),
                activeIcon: Icon(const IconData(0xf44a,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage)),
                title: Text('Discover')),
            BottomNavigationBarItem(
              icon: Icon(const IconData(0xf465,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage)),
              activeIcon: Icon(const IconData(0xf465,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage)),
              title: Text('Video'),
            ),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search), title: Text('Search')),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                activeIcon: Icon(CupertinoIcons.person_solid),
                title: Text('Account')),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              {
                return DiscoverScreen();
              }
            default:
              {
                return DiscoverScreen();
              }
          }
        },
      ),
    );
  }
}
