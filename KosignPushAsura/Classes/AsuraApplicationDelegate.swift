//
//  AsuraNotification.swift
//  KosignPushAsura
//
//  Created by Vansa Pha on 9/4/18.
//

import Foundation
import UserNotifications

open class AsuraApplicationDelegate: UIResponder, UIApplicationDelegate {

    private(set) var appId: String?
    let deviceTypeIdentify = "2"
    
    open func registerAsura(withAppId appUUID: String) {
        self.appId = appUUID
        registerForPushNotifications()
    }
    
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            #if DEBUG
            print("Permission granted: ", granted)
            #endif
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    private func register(withDeviceToken token: Data, completion: @escaping (NSError?) -> Void) {
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
    
    private func anyToAnyObject(userInfo: [AnyHashable : Any]) -> [String: AnyObject] {
        if let userinfo = userInfo["aps"] as? NSDictionary {
            return userinfo["alert"] as? Dictionary<String, AnyObject> ?? [:]
        }
        return [:]
    }
    
    private func getTokenFromData(deviceToken: Data) -> String {
        var deviceTokenString = String(format:"%@", deviceToken as CVarArg)
        deviceTokenString = deviceTokenString.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
        deviceTokenString = deviceTokenString.replacingOccurrences(of: " ", with: "")
        return deviceTokenString
    }
    
    /* =========================== Notification delegate =============================== */
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.register(withDeviceToken: deviceToken) { (error) in
            #if DEBUG
            if error == nil {
                print("Asura: Success")
            }else {
                print("Asura: Fail")
            }
            #endif
        }
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        didFailRegisterAsuraNotification(error: error)
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let dic = anyToAnyObject(userInfo: userInfo)
        didReceiveAsuraNotifcation(userInfo: dic)
    }
    
    /* --------------------------- for client implementation ------------------------------------ */
    open func didReceiveAsuraNotifcation(userInfo: [String : AnyObject]) {}
    open func didFailRegisterAsuraNotification(error: Error){}
}

extension AsuraApplicationDelegate: UNUserNotificationCenterDelegate{
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge,.alert,.sound])
    }
    
    
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}













