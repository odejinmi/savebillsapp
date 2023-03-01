

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'api.dart';

// class AuthapiProvider extends GetConnect implements GetxService {
//   // final String appBaseUrl;
//   // ApiProvider({required this.appBaseUrl});
//   final url = "https://auth.mcd.5starcompany.com.ng/api/v1/";
//
//   var prefs = GetStorage();
//   var dynamic = false.obs;
//
//   var apicontroller = Get.put(ApiProvider());
//
//   void movin(){
//     var controller = Get.put(HomepageController());
//     controller.initState();
//     if (tfa) {
//       Get.offAll(() => TwoFAcode());
//     } else {
//       Get.offAll(() => LandingPage());
//     }
//   }
//  void Biometriclogin()async{
//    loader();
//    var response = await apicontroller.gettokendetail(url+"biometriclogin");
//    Get.back();
//    apicontroller.loginprogress(response, success: (serverdata){
//      Get.find<SavedetailsController>().token.value = serverdata['token'];
//      prefs.write('token', serverdata['token'] ?? "user");
//      prefs.write('transaction_service', serverdata['transaction_service'] ?? "user");
//      prefs.write('ultility_service', serverdata['ultility_service'] ?? "user");
//      prefs.write('wallet', serverdata['balance'] ?? "user");
//      Get.find<SavedetailsController>().wallet.value = serverdata['balance'];
//      movin();
//    });
//
//  }
//
//  void login(Map body)async{
//     loader();
//    var response = await apicontroller.postdetail(url+"login",body);
//     Get.back();
//     apicontroller.loginprogress(response,success:(serverdata){
//      Get.find<SavedetailsController>().token.value = serverdata['token'];
//      prefs.write('token', serverdata['token'] ?? "user");
//      prefs.write('transaction_service', serverdata['transaction_service'] ?? "user");
//      prefs.write('ultility_service', serverdata['ultility_service'] ?? "user");
//      prefs.write('wallet', serverdata['balance'] ?? "user");
//      Get.find<SavedetailsController>().wallet.value = serverdata['balance'];
//    if (dynamic.isTrue) {
//    Get.back(result: true);
//    } else {
//    movin();
//    }});
//  }
//  void forgetpassword(Map body)async{
//     loader();
//    var response = await apicontroller.postdetail(url+"resetpassword",body);
//     Get.back();
//     apicontroller.loginprogress(response, success: (v){
//       CustomAlertDialogloader(
//         title: "Password Recovery",
//         message: "New password has been sent to your email",
//         onPostivePressed: () {
//           Get.back();
//           Get.offAll(() => UserLoginActivity());
//         },
//         positiveBtnText: "OK",
//       );
//     });
//  }
//  void sociallogin(Map body)async{
//     loader();
//    var response = await apicontroller.postdetail(url+"sociallogin",body);
//     Get.back();
//     apicontroller.loginprogress(response,success:(v){Get.find<SavedetailsController>().wallet.value =
//     v["balance"];
//     Get.find<SavedetailsController>().token.value =
//         v["token"] ?? "user";
//     prefs.write('token', v["token"] ?? "user");
//     if (dynamic.isTrue) {
//       Get.back(result: true);
//     } else {
//       movin();
//     }});
//  }
// void newdevice(Map body)async{
//     loader();
//    var response = await apicontroller.postdetail(url+"newdevice",body);
//     Get.back();
//     apicontroller.loginprogress(response, success: (serverdata){
//       Get.find<SavedetailsController>().token.value =
//           serverdata ?? "user";
//       prefs.write('token', serverdata ?? "user");
//       prefs.write("verifynewdevice", false);
//       Gohome();
//     });
//
//  }
//
// void sendcode(Map body)async{
//     // loader();
//    var response = await apicontroller.postdetail(url+"sendcode",body);
//     // Get.back();
//    apicontroller.loginprogress(response, success: (serverdata){
//
//
//       // Get.find<SavedetailsController>().token.value =
//       //     serverdata ?? "user";
//       // prefs.write('token', serverdata ?? "user");
//       // prefs.write("verifynewdevice", false);
//       // Gohome();
//     });
//
//  }
// void register(Map body)async{
//     loader();
//    var response = await apicontroller.postdetail(url+"signup",body);
//     Get.back();
//     apicontroller.loginprogress(response, success: (serverdata){
//       Get.offAll(()=>UserLoginActivity());
//     });
//
//  }
//
//   var code = false.obs;
// void emailverification(Map body)async{
//     loader();
//     var endpoint = "".obs;
//     if (code.isFalse) {
//       endpoint.value = "email-verification";
//     } else{
//       endpoint.value = "email-verification-continue";
//     }
//    var response = await apicontroller.posttokendetail(url+endpoint.value,body);
//     Get.back();
//     apicontroller.loginprogress(response, success: (serverdata){
//       if (code.isFalse) {
//         code.value = true;
//       }else {
//         Get.back();
//         CustomAlertDialogloader(
//             title: "Email Validation",
//             message: serverdata["message"],
//             negativeBtnText: "Continue",
//         );
//       }
//     });
//
//  }
// void pinauth(Map body)async{
//     loader();
//    var response = await apicontroller.postdetail(url+"pinauth",body);
//     Get.back();
//     apicontroller.loginprogress(response, endpoint: "pinauth",success: (serverdata){
//       Get.find<SavedetailsController>().token.value = serverdata['data'];
//       prefs.write('token', serverdata['data'] ?? "user");
//       prefs.write('transaction_service', serverdata['transaction_service'] ?? "user");
//       prefs.write('ultility_service', serverdata['ultility_service'] ?? "user");
//       prefs.write('wallet', serverdata['balance'] ?? "user");
//       Get.find<SavedetailsController>().wallet.value = serverdata['balance'];
//       Gohome();
//     });
//
//  }
//
// }
