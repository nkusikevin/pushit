## Pushit

A Flutter application demonstrating local push notifications implementation.


### Android Setup

1. Add permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
</manifest>
```

### iOS Setup

1. Enable push notifications in Xcode Capabilities
2. Add the following to `ios/Runner/Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
<string>fetch</string>
<string>remote-notification</string>
</array>
```


3. Upload your APNs authentication key to Firebase Console
4. Place your `GoogleService-Info.plist` file in `ios/Runner/`


```swift
if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
``` 


### Features

- Foreground message handling
- Background message handling
- Notification permissions handling
- Custom notification channels (Android)
- Rich notifications support





### Dependencies
```yaml
- flutter_local_notifications: ^18.0.1
- timezone: ^0.10.0
```





### Contributing

Feel free to submit issues and enhancement requests.

### License

This project is licensed under the MIT License - see the LICENSE file for details.

Made with ❤️ by [@KevinNKUSI](https://github.com/nkusikevin)