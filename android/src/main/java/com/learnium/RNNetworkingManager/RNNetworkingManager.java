package com.learnium.RNNetworkingManager;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.bridge.Callback;

import android.app.DownloadManager;
import android.app.DownloadManager.Query;
import android.app.DownloadManager.Request;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.Cursor;
import android.util.Log;
import android.net.Uri;

import java.util.HashMap;
import java.util.Map;
import java.lang.Long;

public class RNNetworkingManager extends ReactContextBaseJavaModule {

  private String downloadCompleteIntentName = DownloadManager.ACTION_DOWNLOAD_COMPLETE;
  private IntentFilter downloadCompleteIntentFilter = new IntentFilter(downloadCompleteIntentName);
  private BroadcastReceiver downloadCompleteReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(Context context, Intent intent) {
        // Handle recieving the event
        Long id = intent.getLongExtra(DownloadManager.EXTRA_DOWNLOAD_ID, 0L);

        if(callbacks.containsKey(id)) {
          // Query the state of the download
          DownloadManager downloadManager = (DownloadManager) reactContext.getSystemService(Context.DOWNLOAD_SERVICE);
          DownloadManager.Query query = new DownloadManager.Query();
          query.setFilterById(id);
          Cursor cursor = downloadManager.query(query);

          // it shouldn't be empty, but just in case
          if (!cursor.moveToFirst()) {
            Log.e("react-native-networking", "Empty row");
            return;
          }

          // build the result
          WritableMap result = new WritableNativeMap();
          int statusIndex = cursor.getColumnIndex(DownloadManager.COLUMN_STATUS);
          if (DownloadManager.STATUS_SUCCESSFUL != cursor.getInt(statusIndex)) {
            Log.w("react-native-networking", "Download Failed");
            int reasonIndex = cursor.getColumnIndex(DownloadManager.COLUMN_REASON);
            int reasonString = cursor.getInt(reasonIndex);
            result.putInt("error", reasonString);
          } else {
            int uriIndex = cursor.getColumnIndex(DownloadManager.COLUMN_LOCAL_URI);
            String downloadedPackageUriString = cursor.getString(uriIndex);
            WritableMap successResult = new WritableNativeMap();
            successResult.putString("filePath", downloadedPackageUriString);
            result.putMap("success", successResult);
          }

          // call the callback
          callbacks.get(id).invoke(result);
        }
    }
  };

  ReactApplicationContext reactContext;
  HashMap<Long, Callback> callbacks;

  public RNNetworkingManager(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    this.callbacks = new HashMap<Long, Callback>();

    // Register the reciever
    reactContext.registerReceiver(downloadCompleteReceiver, downloadCompleteIntentFilter);
  }

  @Override
  public String getName() {
    return "RNNetworkingManager";
  }

  @ReactMethod
  public void requestFile(String url,  ReadableMap options, Callback successCallback) {
    Log.w("dm", options.getString("method"));
    if(options.getString("method") == "GET") {

    }
    this._downloadFile(url, successCallback);
    // successCallback.invoke(relativeX, relativeY, width, height);
  }

  private void _downloadFile(String url, Callback successCallback) {
    // Get an instance of DownloadManager
    DownloadManager downloadManager = (DownloadManager) this.reactContext.getSystemService(Context.DOWNLOAD_SERVICE);

    // Build a request
    DownloadManager.Request request = new DownloadManager.Request(Uri.parse(url));

    // Download it silently
    request.setVisibleInDownloadsUi(false);
    request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_HIDDEN);
    //request.setDestinationInExternalFilesDir(context, null, "large.zip");

    // Enqueue the request
    Long downloadID = downloadManager.enqueue(request);
    callbacks.put(downloadID, successCallback);
  }

}
