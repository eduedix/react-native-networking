# react-native-networking
A react-native module to download and upload files on iOS and Android.

# Installation
## Installation (iOS)
You should have `pod` installed.
```
$ sudo gem install cocoapods
$ pod setup
```
1. Open Terminal and `cd` to your project folder.

2. Install react-native-networking with npm and AFNetworking with pods:

```
npm install react-native-networking --save && cd node_modules/react-native-networking && pod install && open RNNetworkingManager.xcworkspace
```
3. Add necessary linking to RNNetworkingManager following these steps:
 1. Select `RNNetworkingManager` target
 2. Go to `Build Phases`, select `Link Binary with Libraries`
 3. Remove `libPods-AFNetworking` and add `libAFNetworking.a` using + and - signs.
 4. Close `RNNetworkingManager` workspace.
4. Add and link libraries
 1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`.
 2. Go to `node_modules` ➜ `react-native-networking` and add `RNNetworkingManager.xcodeproj`.
 3. Again, right click `Libraries` ➜ `Add Files to [your project's name]`.
 4. Go to `node_modules/react-native-networking/Pods` and add `Pods.xcodeproj`.
 5. In XCode, in the project navigator, select your project. Add `libRNNetworkingManager.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
 6. Click `RNNetworkingManager.xcodeproj` in the project navigator and go the `Build Settings` tab. Make sure 'All' is toggled on (instead of 'Basic'). Look for `Header Search Paths` and make sure it contains both `$(SRCROOT)/../react-native/React` and `$(SRCROOT)/../../React` - mark both as `recursive`.

4. Run your project (`Cmd+R`)

## Installation (Android)

* In `android/setting.gradle`

```gradle
...
include ':RNNetworkingManager', ':app'
project(':RNNetworkingManager').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-networking/android')
```

* In `android/app/build.gradle`

```gradle
...
dependencies {
    ...
    compile project(':RNNetworkingManager')
}
```

* register module (in MainActivity.java)

```java
import com.learnium.RNNetworkingManager.*;  // <--- import

public class MainActivity extends Activity implements DefaultHardwareBackBtnHandler {
  ......

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    mReactRootView = new ReactRootView(this);

    mReactInstanceManager = ReactInstanceManager.builder()
      .setApplication(getApplication())
      .setBundleAssetName("index.android.bundle")
      .setJSMainModuleName("index.android")
      .addPackage(new MainReactPackage())
      .addPackage(new RNNetworkingManagerModule())              // <------ add here
      .setUseDeveloperSupport(BuildConfig.DEBUG)
      .setInitialLifecycleState(LifecycleState.RESUMED)
      .build();

    mReactRootView.startReactApplication(mReactInstanceManager, "ExampleRN", null);

    setContentView(mReactRootView);
  }

  ......

}
```

(Thanks to @chirag04 for writing the instructions)

### Android Limitations

Android currently only supports downloading at the moment.

# Usage
In your react-native project, require the module:
```javascript

var RNNetworkingManager = require('react-native-networking');
var url = 'localhost:3000';

// Example GET request, (download)
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
The GET request automatically downloads the file to the `Documents/` in your app. Similarly, the POST request automatically uploads from `Documents/` of your app.

---

Please feel free to open issues and contribute.
