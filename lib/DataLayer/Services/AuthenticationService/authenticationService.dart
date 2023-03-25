// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, unnecessary_null_comparison, prefer_if_null_operators

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ts_app_development/Generic/APIConstant/apiConstant.dart';
import '../../../Generic/Functions/functions.dart';
import '../../Models/ApiError/apiError.dart';
import '../../Models/ApiResponse/ApiResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../genericService.dart';

class AuthenticationService {
  Future<ApiResponse> authenticateUser(BuildContext context, String username,
      String password, String appKey) async {
    ApiResponse apiResponse = ApiResponse();
    //begin: get api url
    try {
      String apiUrl = "";
      String apiUrl2 = '';
      String url = "";
      String tsAuthSign = "";
      var tsUrl = Uri.parse(
          '${ApiConstant.clientAPIs['tssys']!['baseURLLocal']}TSBE/User/Xe1xk556');
      try {
        final response = await http.get(tsUrl, headers: {
          'TS-AppKey': appKey,
          'TS-AuthSign':
              'e09f00dd-30eb-4917-827d-c11e5e93409e-e2abac1e-8f6b-4696-a711-ecc19d6909fc'
        });
        switch (response.statusCode) {
          case 200:
            //  apiUrl = jsonDecode(response.body)['ApiUrl'];
            final responseData = json.decode(response.body);
            apiUrl = responseData['ApiUrl'];
            url = responseData['Url'];
            tsAuthSign = responseData['TSAuthSign'];

            final prefs = await SharedPreferences.getInstance();
            prefs.setString('AppKeyForTechnosys',
                ApiConstant.clientAPIs['tssys']!['baseURLLocal']);
            print(response.body);

            break;
          case 201:
            print('201');
            break;
          // case 400:
          // case 401:
          //unauthorize
          case 500:
          case 501:
          case 502:
          case 523:
            var tsUrl = Uri.parse(
                '${ApiConstant.clientAPIs['tssys2']!['baseURLLocal']}TSBE/User/Xe1xk556');
            final response = await http.get(tsUrl, headers: {
              'TS-AppKey': appKey,
              'TS-AuthSign':
                  'e09f00dd-30eb-4917-827d-c11e5e93409e-e2abac1e-8f6b-4696-a711-ecc19d6909fc'
            });
            switch (response.statusCode) {
              case 200:
              case 201:
                final responseData = json.decode(response.body);
                apiUrl = responseData['ApiUrl'];
                url = responseData['Url'];
                tsAuthSign = responseData['TSAuthSign'];
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('AppKeyForTechnosys',
                    ApiConstant.clientAPIs['tssys2']!['baseURLLocal']);

                break;
            }
        }
      } on SocketException {
        //no internet
      } on HttpException {
//no response, try backup uri

        var tsUrl = Uri.parse(
            '${ApiConstant.clientAPIs['tssys2']!['baseURLLocal']}TSBE/User/Xe1xk556');
        final response = await http.get(tsUrl, headers: {
          'TS-AppKey': appKey,
          'TS-AuthSign':
              'e09f00dd-30eb-4917-827d-c11e5e93409e-e2abac1e-8f6b-4696-a711-ecc19d6909fc'
        });
        switch (response.statusCode) {
          case 200:
            final responseData = json.decode(response.body);
            apiUrl = responseData['ApiUrl'];
            url = responseData['Url'];
            tsAuthSign = responseData['TSAuthSign'];
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('AppKeyForTechnosys',
                ApiConstant.clientAPIs['tssys2']!['baseURLLocal']);
            break;
          case 201:
        }
      }
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('ApiUrl', apiUrl);
      prefs.setString('Url', url);
      prefs.setString('TSAuthSign', tsAuthSign);
//end: get api url
      print('apiurl ${prefs.getString('ApiUrl')}');
      print(
          'AppKeyForTechnosys ${ApiConstant.clientAPIs['tssys2']!['baseURLLocal']}');

      // Encrypting
      String basicAuth = encryptBase64Credentials(username, password);
      // Headers HashMap
      Map<String, String> hashMapHeader = setHeaderData(basicAuth, appKey);
      // body HashMap
      Map<String, String> hashMapBody = setBodyData();
      var dataURL =
          Uri.parse('${prefs.getString('ApiUrl')}/TSBE/User/FSigninMobileApp');
      final response =
          await http.post(dataURL, headers: hashMapHeader, body: hashMapBody);

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = response.body;
          print(response.body);
          // obtain shared preferences
          final prefs = await SharedPreferences.getInstance();
          // // set value
          await prefs.setString('user', apiResponse.Data.toString());
          await prefs.setString('appKey', appKey);

          final user = prefs.getString('user') ?? '';
          Map<String, dynamic> userMap = jsonDecode(user);
          await prefs.setString('UserId', userMap['LoginId']);
          await prefs.setString('appKeyForLogin', appKey);
          print('LoginId Login: ${userMap['LoginId']}');
          print('AppKey Login: ${appKey}');

          print('Login Successfully');

          break;
        case 401:
          apiResponse.ApiError = {
            'StatusCode': response.statusCode,
          };
          break;
        default:
          apiResponse.ApiError = {
            'StatusCode': response.statusCode,
          };
          break;
      }
    } catch (e) {
      apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return apiResponse;
  }

  Future<ApiResponse> logoutUser(
      String userId, String token, String appKey) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final prefs = await SharedPreferences.getInstance();
      // Headers HashMap
      var hashMapHeader = <String, String>{"UserId": userId, "token": token};
      var dataURL =
          Uri.parse('${prefs.getString('ApiUrl')}/TSBE/User/UserLogOut');
      final response = await http.post(dataURL, headers: hashMapHeader);

      switch (response.statusCode) {
        case 200:
          // obtain shared preferences
          final prefs = await SharedPreferences.getInstance();
          // set value

          // final user = prefs.getString('user') ?? '';
          // Map<String, dynamic> userMap = jsonDecode(user);
          // await prefs.setString('UserId', userMap['UserId']);
          // await prefs.setString('appKeyForLogin', appKey);

          await prefs.remove('user');
          await prefs.remove('appKey');

          apiResponse.Data = json.decode(response.body);
          break;
        case 401:
          apiResponse.ApiError = {
            'StatusCode': response.statusCode,
          };
          break;
        default:
          apiResponse.ApiError = {
            'StatusCode': response.statusCode,
          };
          break;
      }
    } catch (e) {
      apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return apiResponse;
  }

  // Password Change
  Future<ApiResponse> changePassword(Map<String, String> hashMapBody) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      // Headers HashMap
      final prefs = await SharedPreferences.getInstance();
      // Try reading data from the counter key. If it doesn't exist, return 0.
      final user = prefs.getString('user') ?? '';
      final appKey = prefs.getString('appKey') ?? '';
      var userMap = Functions.jsonStringToMap(user);
      var hashMapHeader = <String, String>{
        "UserId": "${userMap['UserId']}",
        "token": "${userMap['GUID']}",
      };

      hashMapBody['ContactNumber'] = userMap['LoginId'].toString();
      hashMapBody['tc'] = appKey;
      var dataURL = Uri(
          scheme: 'http',
          host: ApiConstant.baseHost,
          port: ApiConstant.baseHostPort,
          path: 'TSBE/User/UpdatePassword',
          queryParameters: hashMapBody);
      final response =
          await http.post(dataURL, headers: hashMapHeader, body: hashMapBody);

      switch (response.statusCode) {
        case 200:
          apiResponse.Data = json.decode(response.body);
          break;
        case 401:
          apiResponse.ApiError = {
            'StatusCode': response.statusCode,
          };
          break;
        default:
          apiResponse.ApiError = {
            'StatusCode': response.statusCode,
          };
          break;
      }
    } catch (e) {
      apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return apiResponse;
  }

  // Get Roles Details
  static Future<ApiResponse> getRolesDetails(
      Map<String, dynamic> filtersList) async {
    final response = await GenericService.getData(
        url: "TSBE/User/getUserMenuForMobile",
        hashMapBody: filtersList,
        request: 'GET');
    return response;
  }

  // Header Maker
  Map<String, String> setHeaderData(String auth, String appKey) {
    var hashMapHeader = <String, String>{
      "ts": appKey,
      "app": "6289",
      "Authorization": "Basic $auth"
    };
    return hashMapHeader;
  }

  // Encoder
  String encryptBase64Credentials(String username, String password) {
    String credentials = '$username:$password';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    return encoded;
  }

  Map<String, String> setBodyData() {
    var bodyHashMap = <String, String>{
      "WebUserLogId": "asdas",
      "IPAddress": "asdas",
      "IsMobile": "asdas",
      "IsMobile": "asdas",
      "IsMobile": "asdas",
      "SessionId": "asdas"
    };
    return bodyHashMap;
  }
}
