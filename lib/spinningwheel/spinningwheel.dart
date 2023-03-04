import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


import '../apicall/api.dart';
import '../apicall/custom_alert_dialog.dart';
import '../apicall/custom_alert_dialog_widget.dart';
import '../constant.dart';
import '../provider/adsProvider.dart';
import '../provider/networkProvider.dart';
import 'roll_button.dart';
import 'spinningmodel.dart';

class Spinningwheel extends StatefulHookWidget {
  final String token;
  const Spinningwheel({super.key, required this.token});

  // StreamController<int> selected = StreamController<int>();


  @override
  _SpinningwheelState createState() => _SpinningwheelState();
}

class _SpinningwheelState extends State<Spinningwheel> {

  var selected;
  var selectedIndex;
  var isAnimating;

  var items = [].obs;


  final _formKey = GlobalKey<FormState>();
  TextEditingController recipientController = TextEditingController();
  var spined = false.obs;
  var numberplayed = 0.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FetchDetails();
    Get.find<AdsProvider>().showads();
  }
  var prefs = GetStorage();
  void handleRoll() {
    debugPrint("prefs.read('numberplayed')");
    debugPrint(prefs.read('numberplayed'));
    if (gm_advt.value < 3) {
      gm_advt.value += 1;
      handleRoll1();
    } else {
      gm_advt.value = 0;
      if (prefs.read('numberplayed')== 5) {
        CustomAlertDialogloader(
            title: "Opps",
            message: "Kindly try again",
            negativeBtnText: 'Continue');
      }else {
        selected.add(
          roll(items.length),
        );
        spined.value = true;
        numberplayed.value = prefs.read('numberplayed') ?? 0;
        numberplayed.value += 1;
        prefs.write('numberplayed', numberplayed.value);
        prefs.write('timeplayed', DateTime.now());
      }
    }

  }

  var gm_advt = 0.obs;
  void handleRoll1() {
    if (spined.isTrue) {
      spined.value = false;
      if (!isAnimating.value && items[selectedIndex].type != "empty") {
        CustomAlertDialogWidgetloader(
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                items[selectedIndex].name,
                style: TextStyle(color: primarycolour.value, fontSize: 16),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Recipient *",
                style: TextStyle(color: primarycolour.value, fontSize: 16),
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: _formKey,
                child: Container(
                  margin: const EdgeInsets.only(right: 5, left: 5),
                  child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      // color: scafoldcolour,
                      child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.digitsOnly,
                          //   new LengthLimitingTextInputFormatter(12),
                          // ],
                          decoration: const InputDecoration(
                            hintText: "e.g 081660",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                          controller: recipientController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {

                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This field can't be empty";
                            } else
                            if (recipientController.text.length != 11) {
                              // CustomAlertDialogloader(
                              //     title: "Opps !",
                              //     message: "Nigeria phone number must be 11",
                              //     negativeBtnText: 'Retry');
                              // if (widget.country == "NG") {
                              return "Nigeria phone number must be 11";
                              // }
                            }
                            return null;
                          },
                        ),
                      )),
                ),
              ),
              const SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            // foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              backgroundColor,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  // side: BorderSide(color: Colors.red)
                                ))),
                        onPressed: Get.back,
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
                  const SizedBox(width: 30,),
                  Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            // foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              backgroundColor,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  // side: BorderSide(color: Colors.red)
                                ))),
                        onPressed: () async {
                          Get.back();
                          if (_formKey.currentState!.validate()) {
                            CustomAlertDialogWidgetloader(widget: const SizedBox(height: 40,child: CircularProgressIndicator(value: 20,)));
                            var body = {
                              "id": items[selectedIndex].id.toString(),
                              "number": recipientController.text};
                            var response = await apicontroller.posttokendetail(
                                "${apicontroller.utilityurl.value}spinwin-continue",body,widget.token);
                            Get.back();
                            apicontroller.loginprogress(response, success: (v) async {
                              CustomAlertDialogloader(
                                  title: "Reward claimed",
                                  message: v["message"],
                                  negativeBtnText: 'ok',);
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "Use",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
                ],
              )
            ],
          ),
        );
      } else {
        CustomAlertDialogloader(
          title: "You are not lucky",
          message:
          "Try again",
          negativeBtnText: 'ok',
        );
      }
    }  else {
      Get.find<AdsProvider>().showreawardads(handleRoll);
    }
  }


  @override
  Widget build(BuildContext context) {
    selected = useStreamController<int>();
    selectedIndex = useStream(selected.stream, initialData: 0).data ?? 0;
    isAnimating = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spin & Win'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(25),
              child: const Text("Welcome to SPIN & WIN. \n\nYou only have 5 chances every 5 Hours. For every chances there is 3 advert video then you will be able to claim reward if your spin pointer rest on a gift.",
                style: TextStyle(fontSize: 18),
              )),
          Expanded(
            child: Obx(() {
              return items.isEmpty? const SizedBox(height: 40, child: CircularProgressIndicator( value: 30,)):FortuneWheel(
                animateFirst: false,
                selected: selected.stream,
                indicators: const <FortuneIndicator>[
                  FortuneIndicator(
                    alignment: Alignment.topCenter,
                    // <-- changing the position of the indicator
                    child: TriangleIndicator(
                      color: Colors
                          .red, // <-- changing the color of the indicator
                    ),
                  ),
                ],
                items: [
                  for (var it in items) FortuneItem(child: Text("${it.name}  ${it.type != "empty"? "(${it.qty})":""}")),
                ],
                // onFling: handleRoll,
                onAnimationStart: () => isAnimating.value = true,
                onAnimationEnd: () => isAnimating.value = false,
              );
            }),
          ),
          Obx(()=> items.isEmpty? const SizedBox.shrink(): spined.isFalse? RollButtonWithPreview(
              isAnimating: isAnimating.value,
              selected: selectedIndex,
              items: items,
              onPressed: isAnimating.value ? null : handleRoll1,
            ):ElevatedButton(
                onPressed: handleRoll1,
                child: const Text('claim reward'),
              ),
          ),
          const SizedBox(height: 30),
          Platform.isAndroid||Platform.isIOS && Get.find<NetworkProvider>().isonline.isTrue
              // ? Obx(() => Get.find<AdsProvider>().banner())
              ?  Get.find<AdsProvider>().banner()
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  var apicontroller = Get.put(ApiProvider());

  Future<void> FetchDetails() async {
    // loader();
    var response = await apicontroller.gettokendetail(
        "${apicontroller.utilityurl.value}spinwin-fetch",widget.token);
    // Get.back();
    apicontroller.loginprogress(response, success: (v) async {
      items.value = spinningmodelFromJson(jsonEncode(v["data"]));
    });
  }
}