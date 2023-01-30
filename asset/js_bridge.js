
window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
console.log("web2app ready to go");
 web2appInit({'status':true, 'message':'Ready!!'});
});

var web2app = {};

web2app={
    share: function (params){
          console.log("I am inside the bridge");
          console.log(params);
         return window.flutter_inappwebview.callHandler('share',params);
    },
    vibrate: function (params){
          console.log("I am inside the bridge");
          console.log(params);
         return window.flutter_inappwebview.callHandler('vibrate',params);
    },
    deviceInfo: function (myCallback){
          console.log("I am inside the bridge");
           window.flutter_inappwebview.callHandler('deviceInfo').then(
             (result) => {
                  console.log("inside js bridge callback");
                  console.log(JSON.stringify(result));
                  myCallback(result);
               });
    },
    scanQrCode: function (myCallback){
          console.log("I am inside the bridge");
           window.flutter_inappwebview.callHandler('scanQrCode').then(
             (result) => {
                  console.log("inside js bridge callback");
                  console.log(JSON.stringify(result));
                  myCallback(result);
               });
    },
    appReview: function (myCallback){
          console.log("I am inside the bridge");
           window.flutter_inappwebview.callHandler('appReview').then(
             (result) => {
                  console.log("inside js bridge callback");
                  console.log(JSON.stringify(result));
                  myCallback(result);
               });
    },
    geoLocation: function (myCallback){
          console.log("I am inside the bridge");
           window.flutter_inappwebview.callHandler('geoLocation').then(
             (result) => {
                  console.log("inside js bridge callback");
                  console.log(JSON.stringify(result));
                  myCallback(result);
               });
    },
    geoAddress: function (myCallback){
          console.log("I am inside the bridge");
           window.flutter_inappwebview.callHandler('geoAddress').then(
             (result) => {
                  console.log("inside js bridge callback");
                  console.log(JSON.stringify(result));
                  myCallback(result);
               });
    },
    takePicture: function (myCallback){
          console.log("I am inside the bridge");
           window.flutter_inappwebview.callHandler('takePicture').then(
             (result) => {
                  console.log("inside js bridge callback");
                  console.log(JSON.stringify(result));
                  myCallback(result);
               });
    },
    contacts: function (params){
          console.log("I am inside the bridge");
          console.log(params);
         return window.flutter_inappwebview.callHandler('contacts',params);
    },
    selectContact: function (myCallback){
          console.log("I am inside the bridge");
         window.flutter_inappwebview.callHandler('selectContact').then(
       (result) => {
            console.log("inside js bridge callback");
            console.log(JSON.stringify(result));
            myCallback(result);
         });
    },
    appSettings: function (){
          console.log("I am inside the bridge");
          console.log(params);
         return window.flutter_inappwebview.callHandler('appSettings');
    },
    wakelock:{
        start: function (params){
              console.log("I am inside the bridge");
             return window.flutter_inappwebview.callHandler('wakelock_start');
             },
        stop: function (params){
              console.log("I am inside the bridge");
             return window.flutter_inappwebview.callHandler('wakelock_stop');
             }
    },
    biometric:{
        available: function (myCallback){
              console.log("I am inside the bridge");
               window.flutter_inappwebview.callHandler('biometric_available',{"type":"finger"}).then(
                     (result) => {
                          console.log("inside js bridge callback");
                          console.log(JSON.stringify(result));
                          myCallback(result);
                       });
        },
        check: function (myCallback){
              console.log("I am inside the bridge");
               window.flutter_inappwebview.callHandler('biometric_check',{"type":"finger"}).then(
                     (result) => {
                          console.log("inside js bridge callback");
                          console.log(JSON.stringify(result));
                          myCallback(result);
                       });
        },
        saveauth: function (params){
              console.log("I am inside the bridge");
               window.flutter_inappwebview.callHandler('biometric_saveauth',params).then(
                     (result) => {
                          console.log("inside js bridge callback");
                          console.log(JSON.stringify(result));
//                          myCallback(result);
                       });
        },
        start: function (myCallback){
              console.log("I am inside the bridge");
               window.flutter_inappwebview.callHandler('biometric',{"type":"finger"}).then(
                     (result) => {
                          console.log("inside js bridge callback");
                          console.log(JSON.stringify(result));
                          myCallback(result);
                       });
        },
        stop: function (myCallback){
              console.log("I am inside the bridge");
               window.flutter_inappwebview.callHandler('biometric_stop',{"type":"finger"}).then(
                     (result) => {
                          console.log("inside js bridge callback");
                          console.log(JSON.stringify(result));
                          myCallback(result);
                       });
        }
    }
}


const controlBrightness = function(data) {
  window.flutter_inappwebview.callHandler('controlBrightness',data).then(
  (result) => {
       console.log("inside js bridge");
       console.log(result);
       myCallback(result);
    });
};
