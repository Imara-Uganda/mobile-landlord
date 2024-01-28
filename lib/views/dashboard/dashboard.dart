import 'dart:convert';
import 'package:abjalandlord/constants/resources.dart';
import 'package:abjalandlord/network/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_fonts.dart';
import '../../constants/app_images.dart';
import '../../constants/app_routes.dart';
import '../../models/dashItem.dart';
import '../../models/pharm.dart';
import '../../provider/websocket_provider.dart';
import '../../utils/app_utils.dart';
import '../../utils/local_storage.dart';
import '../../utils/location.dart';
import '../../utils/permissions.dart';
import '../drawer_menu/sidebar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  var photo = photoHolder;

  bool loaded = false;

  var _serviceEnabled;

  var _permissionGranted;

  var fullAddress = 'fetching your location ...';
  getData() async {
    email = await showEmail();
    var mlocate =
        await getAddress(getUserLocation(_serviceEnabled, _permissionGranted));
 
    fullAddress = mlocate['fullAddress'].toString();
    await saveUserState(mlocate['state']);
    await saveCity(mlocate['city']);
    setState(() {
      email;
      fullAddress;
    });
  }

  String searchItem = '';

  static const alarmValueKey = ValueKey('Alarm');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<Key> valueNotifier = ValueNotifier<Key>(alarmValueKey);
  void toggleDrawer() {
    setState(() {
      if (_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState!.openEndDrawer();
      } else {
        _scaffoldKey.currentState!.openDrawer();
      }
    });
  }

  late WebSocketProvider webSocketProvider;
  bool isLoadingProperty = true;
    bool isLoadedPropertyData = true;
  List property = [];
  var allPropertiesInfo;
  getAllProperties() async {
    await Future.delayed(const Duration(seconds: 1));
    var res = await PropertyAPI.getAllProperty();

    var gotproperties = res['data'];
    await savePropertyItem(gotproperties);
    if (gotproperties.isNotEmpty) {
      setState(() {
        property = gotproperties;
        isLoadingProperty = false;
      });
    } else {
      setState(() {
        isLoadingProperty = false;
        property.length = 0;
      });
    }
  }

  getPropertiesName() async {
    var res = await PropertyAPI.getPropertyName();
    var gotproperties = res['data'];

    await savePropertyName(gotproperties);
  }

  getPropertiesData() async {
    var res = await PropertyAPI.getAllPropertiesData();
    allPropertiesInfo = res['data'];
    if (allPropertiesInfo!=null) {
       isLoadedPropertyData = false;
    } else {
      
    }
  }

  getPropertyItems() async {
    isLoadingProperty = true;
    var propertyString = await showPropertyItem();

    var getproperty =
        List<Map<String, dynamic>>.from(jsonDecode(propertyString));
    if (getproperty.isEmpty) {
      getAllProperties();
    } else {
      setState(() {
        property = getproperty;
        isLoadingProperty = false;
      });
    }
  }

  var fullname = "";
  var name = "";
  var surname = "";
  var email = "";
  getName() async {
    name = await showName();
    surname = await showSurname();
    photo = await showSelfie();
    setState(() {
      name;
      surname;
      photo;
      fullname = "$name $surname";
    });
  }

  _runFilter(value) {
    setState(() {
      searchItem = value;
    });
  }

  @override
  void initState() {
    getName();
    getData();
    getPropertyItems();
    getPropertiesData();
    getAllProperties();
    getPropertiesName();
    super.initState();
  }

  int many = 0;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // transparent status bar
        statusBarIconBrightness: Brightness.dark // dark text for status bar
        ));

    final _getSize = MediaQuery.of(context).size;

    webSocketProvider = Provider.of<WebSocketProvider>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideBar(
        email: email,
        fullname: fullname,
        photo: photo,
      ),
      backgroundColor: Pallete.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Container(
              width: _getSize.width,
              height: _getSize.height,
              child: Column(
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      toggleDrawer();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Image.asset("assets/icons/ham.png",width: 36,)
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Hello ',
                                              style: AppFonts.bodyText.copyWith(
                                                  color: Pallete.primaryColor,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              name,
                                              style: AppFonts.bodyText.copyWith(
                                                  color: Pallete.primaryColor,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              AppImages.location,
                                              height: 10,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              fullAddress,
                                              style: AppFonts.bodyThinColoured
                                                  .copyWith(
                                                      fontSize: 10,
                                                      color: Pallete.black),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                  onTap: () {
                                
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipOval(
                                      child: Image.network(
                                        photo,
                                        width: 46,
                                        height: 48,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: _getSize.height * 0.003,
                          ),
                          Container(
                            height: _getSize.height * 0.055,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: const Color(0xFF949494),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: TextField(
                                      onChanged: (value) => _runFilter(value),
                                      decoration: const InputDecoration(
                                        hintText: 'Search',
                                        border: InputBorder.none,
                                      ),
                                      style:
                                          AppFonts.body1.copyWith(fontSize: 14),
                                      // Add any necessary event handlers for text changes or submission.
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (searchItem.isEmpty) {
                                      AppUtils.showSnackBarMessage(
                                          'Enter an item to search for',
                                          context);
                                    } else {
                                      Navigator.of(context).pushNamed(
                                        AppRoutes.randomSearch,
                                        arguments: {
                                          'search': searchItem,
                                        },
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      AppImages.search,
                                      width: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _getSize.height * 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Properties',
                        style: AppFonts.boldText.copyWith(
                            fontSize: _getSize.height * 0.015,
                            fontWeight: FontWeight.w300,
                            color: Pallete.text),
                      ),
                      SizedBox(
                        height: _getSize.height * 0.01,
                      ),
                      isLoadingProperty
                          ? Container(
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF6F9F5),
                                  borderRadius: BorderRadius.circular(10)),
                              width: _getSize.width,
                              height: _getSize.height * 0.38,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SpinKitRing(
                                      size: 30,
                                      color: Pallete.primaryColor,
                                      lineWidth: 2.0,
                                    ),
                                    Text(
                                      "Looking for your property Listing",
                                      style: AppFonts.body1,
                                    ),
                                  ],
                                ),
                              ),
                            ) // Widget to show when many is 0
                          : Column(
                              children: [
                                property.isEmpty
                                    ? 
                                    
                                    
                                    Container(
                                        margin: EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFF6F9F5),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        width: _getSize.width,
                                        height: _getSize.height * 0.38,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Image.asset(
                                                AppImages.no_prop,
                                                width: _getSize.width * 0.6,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "You currently have no added property",
                                                    style: AppFonts.body1,
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        _getSize.height * 0.01,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(AppRoutes
                                                              .addProperty);
                                                    },
                                                    child: Container(
                                                      width:
                                                          _getSize.width * 0.4,
                                                      height: _getSize.height *
                                                          0.045,
                                                      decoration: BoxDecoration(
                                                          color: Pallete
                                                              .primaryColor,
                                                          border: Border.all(
                                                              width: 0.5,
                                                              color: Pallete
                                                                  .primaryColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Center(
                                                        child: Text(
                                                          "Add Property",
                                                          style: AppFonts
                                                              .smallWhiteBold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: _getSize.height * 0.01,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ) // Widget to show when many is 0
                                    : properties(
                                        getSize: _getSize, howMany: property),
                              ],
                            ), //

                     !isLoadedPropertyData ?  middle(
                          getSize: _getSize, propertyData: allPropertiesInfo):Text(''),
                      SizedBox(
                        height: _getSize.height * 0.035,
                      ),
                      bottom(getSize: _getSize)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class properties extends StatelessWidget {
  const properties({super.key, required Size getSize, required this.howMany})
      : _getSize = getSize;

  final Size _getSize;
  final List howMany;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: _getSize.width,
        height: _getSize.height * 0.40,
        child: ListView.builder(
            itemCount: howMany.length,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.propDetails,
                    arguments: {
                      'data': howMany[index]['propertyID'],
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(right: _getSize.width * 0.02),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            howMany[index]['photo'],
                            fit: BoxFit.fitWidth,
                            height: _getSize.height * 0.18,
                            width: _getSize.width * 0.5,
                          ),
                          Positioned(
                            left: _getSize.width * 0.03,
                            bottom: _getSize.height * 0.11,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(137, 246, 249, 245),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(113, 246, 249, 245),
                                      blurRadius: 11,
                                      spreadRadius: 1,
                                      offset: Offset(0, 5),
                                    )
                                  ],
                                  border: Border.all(
                                      width: 0.3, color: Pallete.fade),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3))),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: _getSize.height * 0.018),
                                child: Row(
                                  children: [
                                    Text(
                                  howMany[index]['structure']=="Standalone"?  "Standalone":  howMany[index]['unitData']
                                          .length
                                          .toString(),
                                      style: AppFonts.body1.copyWith(
                                        color: Pallete.primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: _getSize.height * 0.018,
                                      ),
                                    ),
                                    SizedBox(width: _getSize.width * 0.01),
                                    Text(howMany[index]['structure']=="Standalone"?"":"Unit",
                                        style: AppFonts.body1.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Pallete.primaryColor,
                                            fontSize: _getSize.height * 0.018))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _getSize.height * 0.01,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            howMany[index]['name'],
                            style: AppFonts.boldText.copyWith(
                                fontSize: _getSize.height * 0.016,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF333436)),
                          ),
                          SizedBox(
                            height: _getSize.height * 0.005,
                          ),
                          Row(
                            children: [
                              Image.asset(AppImages.estate,
                                  width: _getSize.width * 0.04),
                              SizedBox(
                                width: _getSize.width * 0.008,
                              ),
                              Text(
                                howMany[index]['type'],
                                style: AppFonts.body1.copyWith(
                                    color: Pallete.fade,
                                    fontSize: _getSize.height * 0.016),
                              )
                            ],
                          ),
                          SizedBox(
                            height: _getSize.height * 0.008,
                          ),
                          SizedBox(
                                height: _getSize.height*0.04,
                            child: Row(
                              children: [
                                Image.asset(AppImages.location,
                                    width: _getSize.width * 0.037),
                                SizedBox(
                                  width: _getSize.width * 0.008,
                                ),
                                SizedBox(
                                   width: _getSize.width * 0.4,
                               
                                  child: Text(
                                    howMany[index]['location'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: AppFonts.body1.copyWith(
                                        color: Pallete.fade,
                                        fontSize: _getSize.height * 0.0125),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: _getSize.height * 0.008,
                          ),
                          Text("Description",
                              style: AppFonts.boldText.copyWith(
                                  fontSize: _getSize.height * 0.016,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF333436))),
                          SizedBox(
                            height: _getSize.height * 0.0025,
                          ),
                          SizedBox(
                            width: _getSize.width * 0.5,
                            child: Text(
                              howMany[index]["description"],
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: AppFonts.body1
                                  .copyWith(fontSize: _getSize.height * 0.015),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _getSize.height * 0.01,
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}

class middle extends StatelessWidget {
  const middle({super.key, required Size getSize, required this.propertyData})
      : _getSize = getSize;

  final Size _getSize;
  final propertyData;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.propDetails);
          },
          child: Container(
            height: _getSize.height * 0.073,
            width: _getSize.width * 0.28,
            decoration: const BoxDecoration(
                color: Color.fromARGB(97, 29, 89, 103),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(68, 85, 80, 80),
                    blurRadius: 11,
                    spreadRadius: 1,
                    offset: Offset(0, 5),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(propertyData['totalProperties'].toString(),
                          style: AppFonts.boldText.copyWith(
                            fontSize: _getSize.height * 0.02,
                            color: const Color(0xFF1D5A67),
                          )),
                      Image.asset(
                        AppImages.estate,
                        width: 24,
                        height: _getSize.height * 0.02,
                        color: const Color(0xFF1D5A67),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: _getSize.width * 0.04,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Total",
                        style: AppFonts.body1.copyWith(
                            color: const Color(0xFF1D5A67),
                            fontSize: _getSize.height * 0.015,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Property",
                        style: AppFonts.body1.copyWith(
                            color: const Color(
                              0xFF1D5A67,
                            ),
                            fontSize: _getSize.height * 0.015,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.propDetails);
          },
          child: Container(
            height: _getSize.height * 0.073,
            width: _getSize.width * 0.28,
            decoration: const BoxDecoration(
                color: Color(0xFFFCDBB5),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(68, 85, 80, 80),
                    blurRadius: 11,
                    spreadRadius: 1,
                    offset: Offset(0, 5),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(propertyData['totalVacantProperties'].toString(),
                          style: AppFonts.boldText.copyWith(
                              fontSize: _getSize.height * 0.02,
                              color: Color(0xFFF58807))),
                      Image.asset(
                        AppImages.house,
                        height: _getSize.height * 0.02,
                        color: Color(0xFFF58807),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: _getSize.width * 0.04,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Vacant",
                        style: AppFonts.body1.copyWith(
                            color: Color(0xFFF58807),
                            fontSize: _getSize.height * 0.015,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Property",
                        style: AppFonts.body1.copyWith(
                            color: Color(
                              0xFFF58807,
                            ),
                            fontSize: _getSize.height * 0.015,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.tenants);
            },
            child: Container(
              height: _getSize.height * 0.073,
              width: _getSize.width * 0.28,
              decoration: const BoxDecoration(
                  color: Color(0xFFD6B5DE),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(68, 85, 80, 80),
                      blurRadius: 11,
                      spreadRadius: 1,
                      offset: Offset(0, 5),
                    )
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(propertyData['totalTenants'].toString(),
                            style: AppFonts.boldText.copyWith(
                                fontSize: _getSize.height * 0.02,
                                color: Color(0xFF750790))),
                        Image.asset(
                          AppImages.rent,
                          height: _getSize.height * 0.02,
                          color: Color(0xFF750790),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: _getSize.width * 0.04,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Total",
                          style: AppFonts.body1.copyWith(
                              color: Color(0xFF750790),
                              fontSize: _getSize.height * 0.017,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Tenant",
                          style: AppFonts.body1.copyWith(
                              color: Color(
                                0xFF750790,
                              ),
                              fontSize: _getSize.height * 0.017,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ))
      ],
    );
  }
}

class bottom extends StatelessWidget {
  const bottom({
    super.key,
    required Size getSize,
  }) : _getSize = getSize;

  final Size _getSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: _getSize.height * 0.25,
        width: _getSize.width,
        decoration: const BoxDecoration(
            color: Pallete.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(89, 113, 109, 109),
                blurRadius: 7,
                spreadRadius: 1,
                offset: Offset(1, 2),
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: _getSize.width,
              height: _getSize.height * 0.13,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 88, 108, 84),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Explore our different plans for ",
                    style: AppFonts.body1
                        .copyWith(fontSize: 20, color: Pallete.whiteColor),
                  ),
                  Text(
                    "advanced features and benefits!",
                    style: AppFonts.body1
                        .copyWith(fontSize: 20, color: Pallete.whiteColor),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Abja",
                style: AppFonts.boldText.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(49, 40, 54, 36)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
