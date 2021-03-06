# KosignPushAsura

<img src="https://kosignstore.wecambodia.com/storage/image/KOSIGN.png" style="max-width:100%">

[![CI Status](https://img.shields.io/travis/vs.lov.rs@gmail.com/KosignPushAsura.svg?style=flat)](https://travis-ci.org/vs.lov.rs@gmail.com/KosignPushAsura)
[![Version](https://img.shields.io/cocoapods/v/KosignPushAsura.svg?style=flat)](https://cocoapods.org/pods/KosignPushAsura)
[![License](https://img.shields.io/cocoapods/l/KosignPushAsura.svg?style=flat)](https://cocoapods.org/pods/KosignPushAsura)
[![Platform](https://img.shields.io/cocoapods/p/KosignPushAsura.svg?style=flat)](https://cocoapods.org/pods/KosignPushAsura)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first. (Now beta version test in internal company only). If run error try `pod update` .

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
replace superclass from (UIResponder, UIApplicationDelegate) to AsuraApplicationDelegate
```swift
class AppDelegate: AsuraApplicationDelegate {
    ...
}
```

- Step 3:
Implement in didFinishLaunchingWithOptions.
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    self.registerAsura(withAppId: "<input_app_id_here>")

    return true
}
```

- Optional
You can implement when receive notification or error handling below.
```swift
override func didReceiveAsuraNotifcation(userInfo: [String : AnyObject]) {
//do something here
}

override func didFailRegisterAsuraNotification(error: Error) {
//do something here
}
```

## Author

Asura team (iOS)

## License

KosignPushAsura is available under the MIT license. See the LICENSE file for more info.
