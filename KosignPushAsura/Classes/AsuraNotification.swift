//
//  AsuraNotification.swift
//  KosignPushAsura
//
//  Created by Vansa Pha on 9/4/18.
//

import Foundation
import UserNotifications

class AsuraNotification {
    private init(){}
    static let notification = AsuraNotification()
    private(set) var appId: String?
    let deviceTypeIdentify = "2"
    typealias completionHandler = (Dictionary<String, AnyObject>?, NSError?) -> Void
    
    public func registerAppId(withAppId appUUID: String) {
        self.appId = appUUID
    }
    
    public func register(withDeviceToken token: String, completion: @escaping completionHandler) {
        guard let appUUID = appId else {
            let errorMessage = "Get problem with your AppId, please check it again."
            #if DEBUG
            print(errorMessage)
            #endif
            let appUUIDError = NSError(domain: "App Id error", code: 1001, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            return completion(nil, appUUIDError)
        }
        
        let registerDeviceInfo = [
            "device_model"  : getDeviceModel(),
            "device_type"   : deviceTypeIdentify,
            "app_version"   : getVersion(),
            "language"      : getLanguage(),
            "token"         : token,
            "app_uuid"      : appUUID
        ] as Dictionary<String, AnyObject>
        
        //request
        API.shared.fetchData(urlString: API.shared.registerNotificationApi, body: registerDeviceInfo) { (response) in
            switch response {
            case .success(let data):
                #if DEBUG
                print(data)
                #endif
                completion(data, nil)
            case .error(let error):
                #if DEBUG
                print(error)
                #endif
                completion(nil, error)
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
        return "\(version) build \(build)"
    }
    
    private func getLanguage() -> String {
        return Locale.current.languageCode ?? "Unknown"
    }
}













