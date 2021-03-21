//
//  EventManager.swift
//  AWSKinesisTrial
//
//  Created by Apple on 25/07/18.
//  Copyright © 2018 Kishor. All rights reserved.
//

import Foundation
import AWSKinesis

class EventManager {
    
    func sendToDataStream() {//(event: AWSEvents) {
        
        let event = AWSEvents()
        event.chapterName = "Kishor"
        event.eventName = "AnyEventName"
        event.eventType = "ABC"
        event.opfPath = "Path"
        
        let kinesisRecorder = AWSEvents().getAWSKinesisRecorder()
        
        // Create an array to store a batch of objects.
        var tasks = Array<AWSTask<AnyObject>>()
        let jsonDataString = AWSEvents().getKinesisDataStreamForEvent(event: event)
        
        for i in 0..<1 {
            tasks.append(kinesisRecorder.saveRecord(String(format: jsonDataString!, i).data(using: .utf8), streamName: "YourStreamName")!)
        }
        
        AWSTask(forCompletionOfAllTasks: tasks).continueOnSuccessWith(block: { (task:AWSTask<AnyObject>) -> AWSTask<AnyObject>? in
            return kinesisRecorder.submitAllRecords()
        }).continueWith(block: { (task:AWSTask<AnyObject>) -> Any? in
            if let error = task.error as NSError? {
                print("Error: \(error)")
            }
            return nil
        })
    }
    
    func sendAWSEvent() {//(event: AWSEvents) {
        
        let event = AWSEvents()
        event.chapterName = "Kishor"
        event.eventName = "bookOpen"
        event.eventType = "Reader"
        event.opfPath = "Path"
        
        if event.eventName != nil {
            
        }
        
        let eventClient = AWSEvents().getAWSMobileAnalyticsEventWithName(eventName: event.eventName!)//[AWSEvents getAWSMobileAnalyticsEventWithName:event.eventName];
        let levelEvent = eventClient?.createEvent(withEventType: event.eventName)
        
        levelEvent?.addAttribute("Reader", forKey: "type")
        levelEvent?.addMetric(0, forKey: "BookTime")
        
        eventClient?.record(levelEvent)
        eventClient?.submitEvents()
    }
    
    /*
    
    [levelEvent addAttribute:event.screenName forKey:@"screenName"];
    [levelEvent addAttribute:event.opfPath forKey:@"contentUrl"];
    [levelEvent addAttribute:event.contentUrlFragment forKey:@"contentUrlFragment"];
    [levelEvent addAttribute:event.chapterName forKey:@"chapterName"];
    [levelEvent addAttribute:event.contentSectionName forKey:@"contentSectionName"];
    [levelEvent addAttribute:event.linkURL forKey:@"linkURL"];
    [levelEvent addAttribute:event.highlights forKey:@"highlights"];
    [levelEvent addAttribute:event.notes forKey:@"notes"];
    [levelEvent addAttribute:event.fontSize forKey:@"fontSize"];
    [levelEvent addAttribute:event.fontType forKey:@"fontType"];
    [levelEvent addAttribute:event.themeName forKey:@"themeName"];
    [levelEvent addAttribute:event.brightness forKey:@"brightness"];
    [levelEvent addAttribute:event.pageNumber forKey:@"pageNumber"];
    [levelEvent addAttribute:event.pdfDisplayPageNumber forKey:@"displayPageNumber"];
    
    if(event.sortOrder)
    [levelEvent addAttribute:[event findSortType:[event.sortOrder integerValue]] forKey:@"sortOrder"];
    
    [levelEvent addMetric:[NSNumber aws_numberFromString:event.numberOfSearchResults] forKey:@"totalSearchResults"];
    [levelEvent addMetric:event.bookDownloadTime forKey:@"bookDownloadTime"];
    
    levelEvent = [self addCommonAttributesAndMatrix:levelEvent forEvent:event];
    
    if (isInsightsEnabledPublisher || isFrameworkLevelEvent) {
    
    NSLog(@"AWS Event :  %@ %@ ..%@",[levelEvent eventType],[levelEvent allAttributes],[levelEvent allMetrics]);
    
    [eventClient recordEvent:levelEvent];
    
    if([Utils checkHostReachableWithAlert:NO])
    [eventClient submitEvents];
    }
    }
    }*/
}
