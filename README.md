# react-native-networking
A react-native module to download and upload files with AFNetworking.

## Pre-requisites
You should have `pod` installed.
```
$ sudo gem install cocoapods
$ pod setup
```
## Install
1. Open Terminal and `cd` to your project folder.

2. Install react-native-networking with npm and AFNetworking with pod:

```npm install react-native-networking --save && cd node_modules/react-native-networking && pod install```

3. Add and link libraries
  1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
  2. Go to `node_modules` ➜ `react-native-networking` and add `RNNetworkingManager.xcodeproj`
  3. In XCode, in the project navigator, select your project. Add `libRNNetworkingManager.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
  4. Click `RNNetworkingManager.xcodeproj` in the project navigator and go the `Build Settings` tab. Make sure 'All' is toggled on (instead of 'Basic'). Look for `Header Search Paths` and make sure it contains both `$(SRCROOT)/../react-native/React` and `$(SRCROOT)/../../React` - mark both as `recursive`.

4. Run your project (`Cmd+R`)

## Usage
1. In your react-native project, require the module.
```javascript
var url = 'localhost:3000';

// Example GET request, (download)
var RNNetworkingManager = require('react-native-networking');
RNNetworkingManager.requestFile(url, {
    'method':'GET'
}, function(results) {
  console.log(results);
});

// Example POST request, (upload)
RNNetworkingManager.requestFile(url, {
    'method': 'POST',
    'data' : 'pathToYourFileHere'
}, function(results) {
    console.log(results);
});
```

2. The GET request automatically downloads the file to the `Documents/` in your app. Similarly, the POST request automatically uploads from `Documents/` of your app.

-------------------------------

Please feel free to open issues and contribute.
