
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../constants/app_routes.dart';
import '../dashboard/dashboard.dart';
import '../notification/notification.dart';
import '../property/property.dart';
import '../search/search.dart';

class NavBar extends StatefulWidget {
  final Widget initialScreen;
  final int initialTab;
  NavBar({Key? key, required this.initialScreen, required this.initialTab})
      : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  //set current tab to starting index
  int currentTab = 0;

  //this is a list of all screents passed into a list that takes widget
  final List<Widget> screens = [
    Dashboard(),
  
  ];

//declaring pagestorage state
  final PageStorageBucket _bucket = PageStorageBucket();

  //Widget currentScreen = Dashboard();

  late Widget currentScreen;

  @override
  void initState() {
    super.initState();
    // Set the initial screen provided through the parameter
    currentScreen = widget.initialScreen;
    currentTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final _getSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Pallete.backgroundColor,
        body:
            //this page storage bucket helps to store each page state in memory
            PageStorage(bucket: _bucket, child: currentScreen),
        //set bottomnavbar
        bottomNavigationBar: BottomAppBar(
            //asign shape to navabr
            color: Pallete.whiteColor,
            shape: CircularNotchedRectangle(),
            //set shape to 10px round
            notchMargin: 2,
            child: Container(
              height: _getSize.height * 0.085,
              width: _getSize.width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MaterialButton(
                          minWidth: _getSize.width * 0.10,
                          onPressed: () {
                            setState(() {
                              currentScreen = Dashboard();
                              currentTab = 0;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              currentTab == 0
                                  ? Image.asset(
                                      AppImages.homefilled,
                                      color: Pallete.primaryColor,
                                      width: _getSize.width * 0.065,
                                    )
                                  : Image.asset(
                                      AppImages.home,
                                      color: Pallete.fade,
                                      width: _getSize.width * 0.06,
                                    ),
                              SizedBox(
                                height: 4,
                              ),
                              Text('Home',
                                  style: TextStyle(
                                    fontSize: _getSize.height * 0.012,
                                    fontWeight: currentTab == 0
                                        ? FontWeight.bold
                                        : null,
                                    color: currentTab == 0
                                        ? Color(0xC7171A1C)
                                        : Pallete.fade,
                                  )),
                            ],
                          ),
                        ),
                        MaterialButton(
                          minWidth: _getSize.width * 0.10,
                          onPressed: () {
                            setState(() {
                              currentScreen = Search();
                              currentTab = 1;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              currentTab == 1
                                  ? Image.asset(
                                      AppImages.search,
                                      color: Pallete.primaryColor,
                                      width: _getSize.width * 0.065,
                                    )
                                  : Image.asset(
                                      AppImages.search,
                                      color: Pallete.fade,
                                      width: _getSize.width * 0.06,
                                    ),
                              SizedBox(
                                height: 4,
                              ),
                              Text('Search',
                                  style: TextStyle(
                                    fontSize: _getSize.height * 0.012,
                                    fontWeight: currentTab == 1
                                        ? FontWeight.bold
                                        : null,
                                    color: currentTab == 1
                                        ? Color(0xC7171A1C)
                                        : Pallete.fade,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    MaterialButton(
                      minWidth: _getSize.width * 0.10,
                      onPressed: () {
                        setState(() {
                          currentScreen = Property();
                          currentTab = 5;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          currentTab == 5
                              ? Image.asset(
                                  AppImages.estatefilled,
                                  width: _getSize.width * 0.065,
                                )
                              : Image.asset(
                                  AppImages.estate,
                                  color: Pallete.fade,
                                  width: _getSize.width * 0.06,
                                ),
                          SizedBox(
                            height: 4,
                          ),
                          Text('Property',
                              style: TextStyle(
                                fontSize: _getSize.height * 0.012,
                                fontWeight:
                                    currentTab == 5 ? FontWeight.bold : null,
                                color: currentTab == 5
                                    ? Pallete.primaryColor
                                    : Pallete.fade,
                              )),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MaterialButton(
                          minWidth: _getSize.width * 0.10,
                          onPressed: () {
                            setState(() {
                              currentScreen = NotificationScreen();
                              currentTab = 2;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              currentTab == 2
                                  ? Image.asset(
                                      AppImages.notifyfilled,
                                      width: _getSize.width * 0.075,
                                    )
                                  : Image.asset(
                                      AppImages.notification,
                                      color: Pallete.fade,
                                      width: _getSize.width * 0.045,
                                    ),
                              SizedBox(
                                height: 4,
                              ),
                              Text('Notification',
                                  style: TextStyle(
                                    fontSize: _getSize.height * 0.012,
                                    fontWeight: currentTab == 2
                                        ? FontWeight.bold
                                        : null,
                                    color: currentTab == 2
                                        ? Color(0xC7171A1C)
                                        : Pallete.fade,
                                  )),
                            ],
                          ),
                        ),
                        MaterialButton(
                          minWidth: _getSize.width * 0.10,
                          onPressed: () {
                            setState(() {
                              currentScreen = Dashboard();
                              currentTab = 4;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.inbox,
                                color: currentTab == 4
                                    ? Color(0xC7171A1C)
                                    : Pallete.fade,
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text('Inbox',
                                  style: TextStyle(
                                    fontSize: _getSize.height * 0.012,
                                    fontWeight: currentTab == 4
                                        ? FontWeight.bold
                                        : null,
                                    color: currentTab == 4
                                        ? Color(0xC7171A1C)
                                        : Pallete.fade,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
            )));
  }
}
