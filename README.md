# KosignPushAsura

[![CI Status](https://img.shields.io/travis/vs.lov.rs@gmail.com/KosignPushAsura.svg?style=flat)](https://travis-ci.org/vs.lov.rs@gmail.com/KosignPushAsura)
[![Version](https://img.shields.io/cocoapods/v/KosignPushAsura.svg?style=flat)](https://cocoapods.org/pods/KosignPushAsura)
[![License](https://img.shields.io/cocoapods/l/KosignPushAsura.svg?style=flat)](https://cocoapods.org/pods/KosignPushAsura)
[![Platform](https://img.shields.io/cocoapods/p/KosignPushAsura.svg?style=flat)](https://cocoapods.org/pods/KosignPushAsura)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

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
        
        /* ----- STEP2: Register notification with your app id from Asura Kosign Push ----- */
        AsuraNotification.notification.registerAppId(withAppId: "your_app_id_here", application: application)
        
        return true
    }
```
- Step 3:
Implement in didRegisterForRemoteNotificationsWithDeviceToken.
```swift
/* ----- STEP3: Start register notification after granted ----- */
        AsuraNotification.notification.register(withDeviceToken: deviceToken) { (error) in
            
            if error == nil { //register to KosignAsuraPush successfully
              //do something here when success
            }else { //fail
              //do something here when fail
            }
            
        }
```

## Author

vs.lov.rs@gmail.com, vs.lov.rs@gmail.com

## License

KosignPushAsura is available under the MIT license. See the LICENSE file for more info.
