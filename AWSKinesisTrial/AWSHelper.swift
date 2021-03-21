//
//  AWSHelper.swift
//  AWSKinesisTrial
//
//  Created by Apple on 25/07/18.
//  Copyright © 2018 Kishor. All rights reserved.
//

import Foundation
import AWSKinesis
import AWSMobileAnalytics

//#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]

let timeStamp = "\(Date().timeIntervalSince1970 * 1000)"

extension AWSEvents {
    
    func getAWSKinesisRecorder() -> AWSKinesisRecorder {
        
        let credentialsProvider = AWSCognitoCredentialsProvider.init(regionType: .USEast1, identityPoolId: "pool-ID") //us-east-1:12622b45-8737-4d71-a8b9-eb1979f7fb1f
        let defaultServiceConfiguration = AWSServiceConfiguration.init(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = defaultServiceConfiguration
        
        let kinesisRecorder = AWSKinesisRecorder.default()
        kinesisRecorder.diskAgeLimit = TimeInterval(30 * 24 * 60 * 60); // 30 days
        kinesisRecorder.diskByteLimit = UInt(10 * 1024 * 1024); // 10MB
        kinesisRecorder.notificationByteThreshold = UInt(5 * 1024 * 1024); // 5MB
    
        return kinesisRecorder
    }
    
    
    func getKinesisDataStreamForEvent(event: AWSEvents) -> String? {
        
        let dataStreamDict = ["event_type": event.eventName ?? "",
                              "event_timestamp": timeStamp,
                              "event_version": "3.0",
                              "session":"SessionTest",
                              "device": self.getDeviceDictionary(),
                              "attributes": "Attributes",
                              "metrics": "Metrics"] as [String : Any]
        
        var jsonStr: String?
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dataStreamDict, options: .prettyPrinted)
            jsonStr = String.init(data: jsonData, encoding: .utf8)
        }
        
        catch {
            print(error.localizedDescription)
        }
        
        return jsonStr
    }
    
    func getAWSMobileAnalyticsEventWithName(eventName: String) -> AWSMobileAnalyticsEventClient? {
        
        let credentialsProvider = AWSCognitoCredentialsProvider.init(regionType: .USEast1, identityPoolId: "pool-ID") //us-east-1:12622b45-8737-4d71-a8b9-eb1979f7fb1f
        let defaultServiceConfiguration = AWSServiceConfiguration.init(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = defaultServiceConfiguration
        
        
        //let ana = AWSMobileAnalytics.init(forAppId: "app-ID", identityPoolId: "pool-ID")
        
        let awsMobileAnalyticsConfg = AWSMobileAnalyticsConfiguration.init()
        //awsMobileAnalyticsConfg.
        let analytics = AWSMobileAnalytics.init(forAppId: "App-ID", configuration: awsMobileAnalyticsConfg)
        
        //AWSMobileAnalytics *analytics = [AWSMobileAnalytics mobileAnalyticsForAppId:@"a3748c1a14344c30977659437f2230fc" identityPoolId: @"us-east-1:12622b45-8737-4d71-a8b9-eb1979f7fb1f"];
        
        let eventClient = analytics?.eventClient
        return eventClient
    }
    
    func getDeviceDictionary() -> [String : Any] {
        
        /*if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
        }*/
        
        let language = Bundle.main.preferredLocalizations[0]
        let locale = Locale.current
        let countryCode = locale.regionCode
        let country = countryName(countryCode: countryCode!)
        
        let localeDictionary = ["code": countryCode, "country": country, "language": language]
        
        let platformName = UIDevice.current.systemName
        let platformVersion = UIDevice.current.systemVersion
        
        let platformDictionary = ["name": platformName, "version": platformVersion]
        
        let deviceDictionary = ["locale": localeDictionary, "make": "Apple", "model": UIDevice.current.model, "platform": platformDictionary] as [String : Any]
        
        return deviceDictionary
    }
    
    func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode) ?? nil
    }
}
