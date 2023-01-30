import 'package:flutter/material.dart';
import 'constant.dart';
import 'web_view_container.dart';

class No_Internet extends StatelessWidget {
  bool shouldPop = false;

  No_Internet({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => WebViewContainer(lasturl.toString())));
    return true;
    },
      child: Scaffold(
        appBar: AppBar(
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            // Row(
            //   children: [
            //     Spacer(),
            //     GestureDetector(
            //       onTap: () {
            //         Navigator.of(context).pop();
            //       },
            //       child: Image(
            //         height: 26,
            //         width: 26,
            //         image: AssetImage("assets/images/Icon material-cancel.png"),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //   ],
            // ),
            const Center(
              child: Image(
                image: AssetImage("asset/nointernet.gif"),
                height: 234,
                width: 312,
              ),
            ),
            const SizedBox(height: 25),
            const Center(
              child: Text(
                "No internet connection!",
                style: TextStyle(
                  color: Color(0xff3d00ab),
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 60, right: 60, top: 20),
              child: GestureDetector(
                onTap: () {
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => Invoice()));
                },
                child: const Text(
                  "Please check your internet connection and try again.",
                  style: TextStyle(
                    color: Color(0xff3d00ab),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

}
