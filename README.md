# KosignPushAsura

<img src="KOSIGN.png" style="max-width:100%">

[![CI Status](https://img.shields.io/travis/vs.lov.rs@gmail.com/KosignPushAsura.svg?style=flat)](https://travis-ci.org/vs.lov.rs@gmail.com/KosignPushAsura)
[![Version](https://img.shields.io/cocoapods/v/KosignPushAsura.svg?style=flat)](https://cocoapods.org/pods/KosignPushAsura)
[![License](https://img.shields.io/cocoapods/l/KosignPushAsura.svg?style=flat)](https://cocoapods.org/pods/KosignPushAsura)
[![Platform](https://img.shields.io/cocoapods/p/KosignPushAsura.svg?style=flat)](https://cocoapods.org/pods/KosignPushAsura)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first. (Now beta version test in internal company only)

## Requirements

<ul>
<li>iOS 11.0+/ macOS 10.13+</li>
<li>XCode 9.0+</li>
<li>Swift 4.0+</li>
</ul>

## Installation

KosignPushAsura is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KosignPushAsura'
```

In AppDelegate.swift has 3 steps to configure.
- Step 1:
```swift
import KosignPushAsura
```
- Step 2:
Implement in didFinishLaunchingWithOptions.
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    AsuraNotification.notification.registerAppId(withAppId: "your_app_id_here", application: application)

    return true
}
```
- Step 3:
Implement in didRegisterForRemoteNotificationsWithDeviceToken.
```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    AsuraNotification.notification.register(withDeviceToken: deviceToken) { (error) in
        if error == nil { //register to KosignAsuraPush successfully
          //do something here when success
        }else { //fail
          //do something here when fail
        }

    }
}
```

## Author

Vansa Pha, vansapha.biz@gmail.com

## License

KosignPushAsura is available under the MIT license. See the LICENSE file for more info.
