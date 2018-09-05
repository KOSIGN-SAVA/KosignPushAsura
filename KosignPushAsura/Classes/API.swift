//
//  REQUEST.swift
//  K_PUSH
//
//  Created by         TuyNuy         on 8/16/18.
//  Copyright © 2018 TuyNuy. All rights reserved. xd
//

import Foundation
import UIKit

public enum ResponseCompletion {
    case success([String: AnyObject])
    case error(NSError)
}

public class API {
    
    // MARK: - Singleton
    public static let shared = API()
    private init() {}
    
    // MARK: - Request Timer
    let timeOutDuration : TimeInterval = 115.0
    var timer           : Timer?
    var isTimeout       = false
    
    //MARK: Api id
    let registerNotificationApi = "http://192.168.178.133:8080/api/registernotification/"
    
    private func request(urlString: String , body: [String: AnyObject]) -> URLRequest  {
        let requestBody     = self.printPrettyBody(body: body) ?? ""
        
        guard let url       = URL(string: urlString) else { fatalError("CAN'T CREATE URL") }
        var request         = URLRequest(url: url)
        request.httpMethod  = "POST"
        request.httpBody    = requestBody.data(using: .utf8)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        #if DEBUG
        print("\n✂︎----------------------------------------------------------")
        print("From API URL: \(request.url!.absoluteString)")
        print("Request Body: \(requestBody)")
        print("----------------------------------------------------------✂︎\n")
        #endif
        
        return request
    }
    
    public func fetchData(urlString: String, body: [String: AnyObject], completion: @escaping (ResponseCompletion) -> Void ) {
        // MARK: Timeout Configuration
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest  = 120.0
        sessionConfig.timeoutIntervalForResource = 120.0
        
        let session = URLSession(configuration: sessionConfig)
        timer = Timer.scheduledTimer(timeInterval: timeOutDuration, target: self, selector: #selector(onTimeOut), userInfo: nil, repeats: false)
        //** loading view
        
        let request = self.request(urlString: urlString, body: body)
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let `self` = self else { return }
            //** loading view
            self.timer?.invalidate()
            
            // MARK: Check if Timeout
            guard self.isTimeout == false else {
                self.isTimeout = false
                let timeoutError = NSError(domain: "Timeout Error", code: 1004, userInfo: [NSLocalizedDescriptionKey : "Connection Timeout."])
                DispatchQueue.main.async {
                    completion(.error(timeoutError))
                }
                return
            }
            
            // MARK: Data is nil
            guard let data = data else {
                let internetError = NSError(domain: "Client Error", code: -1, userInfo: [NSLocalizedDescriptionKey : "Client Error."])
                DispatchQueue.main.async {
                    completion(.error(internetError))
                }
                return
            }
            
            guard let dataString = String(data: data, encoding: .utf8) else { return }
            print("data: String: ", dataString)
            
            if let data = dataString.data(using: .utf8) {
                #if DEBUG
                print("\n✂︎----------------------------------------------------------")
                print("From API URL: \(request.url!)")
                print("Response Data:\n\(String(describing: self.JSONStringify(value: try! self.jsonToDic(data), prettyPrinted: true)))")
                print("✂︎----------------------------------------------------------\n")
                #endif
                
                do {
                    let response = try self.jsonToDic(data)
                    
                    #if DEBUG
                    print("Request successfully!")
                    #endif
                    
                    DispatchQueue.main.async {
                        completion(.success(response as! [String : AnyObject]))
                    }
                } catch let error as NSError {
                    #if DEBUG
                    print("Error request: ", error.description)
                    #endif
                    
                    let decodeError = NSError(domain: "Developer Error", code: 168, userInfo: [NSLocalizedDescriptionKey : error.description])
                    DispatchQueue.main.async {
                        completion(.error(decodeError))
                    }
                }
            }
            }.resume()
    }
    
    @objc private func onTimeOut() {
        isTimeout = true
    }
}

extension API {
    
    private func printPrettyBody(body: [String: AnyObject]) -> String? {
        return self.JSONStringify(
            value           : body,
            prettyPrinted   : true
        )
    }
    
    private func encode(_ string: String) -> String? {
        let allowedCharacterSets = (NSCharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSets.removeCharacters(in: "!@#$%^&*()-_+=~`:;\"'<,>.?/")
        
        guard let encodeString = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSets as CharacterSet) else{
            return nil
        }
        
        return encodeString
    }
    
    private func JSONStringify(value: Any, prettyPrinted: Bool = false) -> String {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : nil
        
        if JSONSerialization.isValidJSONObject(value) {
            if let data = try? JSONSerialization.data(withJSONObject: value, options: options!) {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }
        }
        
        return ""
    }
    
    private func jsonToDic(_ data: Data) throws -> NSDictionary{
        enum JSONError: Error {
            case serializedJSONError // dic -> JSON
            case deserializedJSONError
        }
        
        guard let dic: NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else{
            throw JSONError.deserializedJSONError
        }
        
        return dic
    }
    
    private func dicToJSONString(_ dic: [String:AnyObject]) throws -> String{
        guard let data:Data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0)) else{
            throw JSONError.serializedJSONError
        }
        guard let jsonString: String = String(data: data, encoding: String.Encoding.utf8) else{
            throw DataError.invalidEncodingData
        }
        return jsonString
    }
    
    private func jsonStringToDic(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

enum JSONError: Error {
    case serializedJSONError
    case deserializedJSONError
}
enum DataError: Error {
    case invalidEncodingData
}
