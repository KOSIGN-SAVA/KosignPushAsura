//
//  AsuraNotification.swift
//  KosignPushAsura
//
//  Created by Vansa Pha on 9/4/18.
//

import Foundation
import UserNotifications

open class AsuraNotification {
    private init(){}
    open static let notification = AsuraNotification()
    private(set) var appId: String?
    let deviceTypeIdentify = "2"
    public typealias completionHandler = (NSError?) -> Void
    
    open func registerAppId(withAppId appUUID: String, application: UIApplication) {
        self.appId = appUUID
        registerForPushNotifications(application: application)
    }
    
    open func register(withDeviceToken token: Data, completion: @escaping completionHandler) {
        let deviceTokenString = token.hexString
        guard let appUUID = appId else {
            let errorMessage = "Get problem with your AppId, please check it again."
            #if DEBUG
            print(errorMessage)
            #endif
            let appUUIDError = NSError(domain: "App Id error", code: 1001, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            return completion(appUUIDError)
        }
        
        let registerDeviceInfo = [
            "device_model"  : getDeviceModel(),
            "device_type"   : deviceTypeIdentify,
            "app_version"   : getVersion(),
            "language"      : getLanguage(),
            "token"         : deviceTokenString
        ] as Dictionary<String, AnyObject>
        
        //request
        let apiName = API.shared.registerNotificationApi + appUUID
        API.shared.fetchData(urlString: apiName, body: registerDeviceInfo) { (response) in
            switch response {
            case .success(_):
                completion(nil)
            case .error(let error):
                completion(error)
            }
        }
    }
    
    private func getDeviceModel() -> String {
        return UIDevice.current.name
    }
    
    private func getVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version).\(build)"
    }
    
    private func getLanguage() -> String {
        guard let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String else { return "Unknown" }
        return countryCode
    }
    
    private func getTokenFromData(deviceToken: Data) -> String {
        var deviceTokenString = String(format:"%@", deviceToken as CVarArg)
        deviceTokenString = deviceTokenString.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
        deviceTokenString = deviceTokenString.replacingOccurrences(of: " ", with: "")
        return deviceTokenString
    }
    
    func registerForPushNotifications(application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            #if DEBUG
            print("Permission granted: ", granted)
            #endif
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}













