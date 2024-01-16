import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../network/property.dart';
import '../utils/local_storage.dart';

class PropertyProvider extends ChangeNotifier {
  // final Map<String, dynamic> serverErrorResult = {
  //   'status': false,
  //   'message': 'Sorry, something went wrong. Contact the Admin',
  // };

  Future<Map<String, dynamic>> createProperty(dataobj) async {
    dynamic data;
    //dynamic dataz;
    //List<dynamic> data;
    notifyListeners();

    try {
      var responseData = await PropertyAPI.addProperty(dataobj);

      data = responseData;

      if (responseData['statusCode'] == 200) {
        notifyListeners();
        print(data);
        data;
      } else {
        data;
      }
    } catch (e) {
      notifyListeners();
      data = {'error': e};
    }
    return data;
  }  
  
  
  
  Future<Map<String, dynamic>> addTenantToUnit(dataobj) async {
    dynamic data;
    //dynamic dataz;
    //List<dynamic> data;
    notifyListeners();

    try {
      var responseData = await PropertyAPI.addTenant(dataobj);

      data = responseData;

      if (responseData['statusCode'] == 200) {
        notifyListeners();
        print(data);
        data;
      } else {
        data;
      }
    } catch (e) {
      notifyListeners();
      data = {'error': e};
    }
    return data;
  }

  
  Future<Map<String, dynamic>> addUnit(dataobj) async {
    dynamic data;
    //dynamic dataz;
    //List<dynamic> data;
    notifyListeners();

    try {
      var responseData = await PropertyAPI.addUnit(dataobj);

      data = responseData;

      if (responseData['statusCode'] == 200) {
        notifyListeners();
        print(data);
        data;
      } else {
        data;
      }
    } catch (e) {
      notifyListeners();
      data = {'error': e};
    }
    return data;
  }


}
