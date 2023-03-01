import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';
import 'custom_alert_dialog.dart';



class ApiProvider extends GetxController {
  // final String appBaseUrl;
  // ApiProvider({required this.appBaseUrl});

  var authurl = "".obs;
  var transactionurl = "https://transaction.mcd.5starcompany.com.ng/api/v1/".obs;
  var utilityurl = "https://utility.mcd.5starcompany.com.ng/api/v1/".obs;

  var prefs = GetStorage();

  geturls(){
    transactionurl.value = prefs.read("transaction_service")??
        "https://transaction.mcd.5starcompany.com.ng/api/v1/";
    utilityurl.value = prefs.read("ultility_service")??
        "https://utility.mcd.5starcompany.com.ng/api/v1/";

  }

  Future<http.Response> getdetail(url) async {
    geturls();
    print(url);
    var response = await http.get(Uri.parse(url),
        headers: {
          "version": "$versionapp",
          "device": "$deviceDetail",
          "Access-Control-Allow-Origin": "*",
          "Connection": "Keep-Alive",
          "Keep-Alive": "timeout=5, max=5000",
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.connectionHeader: "keep-alive"
        });
    print(response.body);
    return response;
    // if (response.status.hasError) {
    //   return Future.error(response.statusText!);
    // } else {
    //   return response.body['result'];
    // }
  }
  Future<http.Response> gettokendetail(url,token) async {
    geturls();
    print(url);
    var response = await http.get(Uri.parse(url), headers: {
      "version": "$versionapp",
      "device": "$deviceDetail",
      "Access-Control-Allow-Origin": "*",
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeout=5, max=5000",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader:
          "Bearer $token",
      HttpHeaders.connectionHeader: "keep-alive"
    });
    print(response.body);
    return response;
    // if (response.status.hasError) {
    //   return Future.error(response.statusText!);
    // } else {
    //   return response.body['result'];
    // }
  }

  Future<http.Response> postdetail(url, Map body) async {
    geturls();
    print(url);
    print(body);
    var response = await http.post(
        Uri.parse(url),
      body: body,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "version": "$versionapp",
        "device": "$deviceDetail",
        "Connection": "Keep-Alive",
        "Keep-Alive": "timeout=5, max=1000",
        HttpHeaders.connectionHeader: "keep-alive"
      },
    );
    print(jsonEncode(response.body));
    return response;
    // if (response.body == null || !response.body["success"]) {
    //   CustomAlertDialogloader(
    //       title: "Error",
    //       message: response.body == null
    //           ? "Check connection, Kindly connect to another network"
    //           : response.body["message"],
    //       // onPostivePressed: () {},
    //       // positiveBtnText: 'Continue',
    //       negativeBtnText: 'Continue');
    //   return Future.error(response.statusText!);
    // } else {
    //   return response.body;
    // }
  }

  Future<http.Response> posttokendetail(url, Map body, token) async {
    geturls();
    print(url);
    print(body);
    var response = await http.post(
        Uri.parse(url),
      body: body,
      headers: {
        "version": "$versionapp",
        "device": "$deviceDetail",
        "Access-Control-Allow-Origin": "*",
        "Connection": "Keep-Alive",
        "Keep-Alive": "timeout=5, max=1000",
        HttpHeaders.authorizationHeader:
            "Bearer $token",
        HttpHeaders.connectionHeader: "keep-alive"
      },
    );
    print(jsonEncode(response.body));
    return response;
    // if (response.body == null || !response.body["success"]) {
    //   CustomAlertDialogloader(
    //       title: "Error",
    //       message: response.body == null
    //           ? "Check connection, Kindly connect to another network"
    //           : response.body["message"],
    //       // onPostivePressed: () {},
    //       // positiveBtnText: 'Continue',
    //       negativeBtnText: 'Continue');
    //   return Future.error(response.statusText!);
    // } else {
    //   return response.body;
    // }
  }


  loginprogress(response,{String? endpoint, required Function success, Function? fail}) {
    if (response.statusCode == 200) {
      var cmddetails = jsonDecode(response.body);
      // serverdata = cmddetails['data'];
      servermessage = cmddetails['message'] ?? "user";
      if (cmddetails['success'] == 1) {
        success(cmddetails);
      } else {
        if (fail == null) {
          CustomAlertDialogloader(
              title: "Error",
              message: "Connection Error",
              // onPostivePressed: () {},
              // positiveBtnText: 'Continue',
              negativeBtnText: 'Continue');
        } else {
          fail();
        }
      }
    }
  }

}
