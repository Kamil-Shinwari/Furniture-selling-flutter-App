import 'package:flutter/material.dart';
import 'package:market/settings.dart';
import 'package:market/wishlist.dart';
import 'package:provider/provider.dart';
import 'package:market/auth/auth.dart';
import 'package:market/blocks/auth_block.dart';
import 'package:market/cart.dart';
import 'package:market/categorise.dart';
import 'NavigationRoutes.dart';
import 'home/drawer.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthBlock>.value(value: AuthBlock()),
        ],
        child: MaterialApp(
          title: 'Market',
          darkTheme: ThemeData(
            primaryColor: Colors.deepOrange[500],
            accentColor: Colors.lightBlue[900],
          ),
         initialRoute: '/',
         routes: <String, WidgetBuilder>{
           '/': (BuildContext context) => Template(),
           '/auth': (BuildContext context) => Auth(),
          //  '/shop': (BuildContext context) => Shop(),
           '/categorise': (BuildContext context) => Categorise(),
           '/wishlist': (BuildContext context) => WishList(),
           '/cart': (BuildContext context) => CartList(),
           '/settings': (BuildContext context) => Settings(),
          //  '/products': (BuildContext context) => Products()
         },
          home: Template(),
        ));
  }
}

class Template extends StatefulWidget {
  @override
  _Template createState() => _Template();
}

class _Template extends State<Template> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  int _selectedIndex = 1;

  void _onNavigationBarItemTap(BuildContext context, int index) {
    setState(() {
      print("@@" + index.toString());
      _selectedIndex = index;
      print("@@"+_navigatorKey.toString());
      _navigatorKey.currentState.pushNamed(NavigationRoutes.getRouteAtIndex(index),arguments: _navigatorKey);
    });
  }

  Widget _customBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Category',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shop),
          label: 'Shop',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (int index) => _onNavigationBarItemTap(context, index),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: AppDrawer(_navigatorKey),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: WillPopScope(
          child: Navigator(
            key: _navigatorKey,
            initialRoute: '/',
            onGenerateRoute: NavigationRoutes.generateRoute,
          ),
          onWillPop: () async {


              setState(() {
              if (_navigatorKey.currentState.canPop()&&ModalRoute.of(_navigatorKey.currentContext).settings.name!='/product') {
                print("@@@@"+ModalRoute.of(_navigatorKey.currentContext).settings.name);
                _navigatorKey.currentState.pushNamed('/',arguments: _navigatorKey);
                _selectedIndex = 1;
              }
              });
              return false;

            return true;
          },
        ),
      ),
      bottomNavigationBar: _customBottomNavigationBar(context),
    );
  }
}
