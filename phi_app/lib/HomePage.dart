import 'package:flutter/material.dart';
import 'pages/EventsPage.dart';
import 'pages/ProfilePage.dart';
class HomePage extends StatefulWidget{
  //create a state for our homepage, since its reactive
  @override
  _HomePage createState() => new _HomePage ();

}

class _HomePage extends State <HomePage> with SingleTickerProviderStateMixin{


  //tab controller so we can switch tabs
  TabController _tabController;

  @override
  void initState(){
    super.initState();
    //we make the 'initial index' this specific page and have 2 tabs.
    _tabController = new TabController(vsync: this,initialIndex: 1,length: 2);

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        //new app bar
        title: new Text("PHI App"),
        elevation: 0.7,
        //tab bar for pages
        bottom: new TabBar(
          //control with variable of tab controller called in initState
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            //the tabs (need 2 if defined 2)
            new Tab(text:"Events"),
            new Tab(text: "Profile"),
          ],
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new EventsPage(),
          new ProfilePage()
        ],
      ),
    );
  }

}