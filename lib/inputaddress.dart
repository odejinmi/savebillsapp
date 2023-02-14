import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pagecontroller.dart';

class Inputaddress extends StatelessWidget {
  Inputaddress({super.key});
    var pagecontroller = Get.put(Pagecontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Send a message",
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Color(edittextbodercolour)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Color(edittextbodercolour)),
                  ),
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (pagecontroller.istext.isTrue) {
                          pagecontroller.handleSubmitted(pagecontroller.textController.value.text);
                        }
                      })),
              controller: pagecontroller.textController.value,
              onFieldSubmitted: pagecontroller.handleSubmitted,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  pagecontroller.istext.value = true;
                } else {
                  pagecontroller.istext.value = false;
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "This field can't be empty";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    ),
        ),
    );
  }
}