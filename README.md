### This module is deprecated. Use https://github.com/wkh237/react-native-fetch-blob or https://github.com/johanneslumpe/react-native-fs instead.

# react-native-networking
A react-native module to download and upload files on iOS and Android.

# Installation
## Installation (iOS)
Assuming you're using `cocoapods` to manage your iOS dependencies, add `react-native-networking` as a new dependency: 

```
# Podfile
pod 'react-native-networking', :path => '../node_modules/react-native-networking'
```

then run `pod install` and you're good to go!

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
