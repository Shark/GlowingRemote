//
//  ComplicationDataSource.swift
//  GlowingRemote
//
//  Created by Felix Seidel on 08.10.15.
//  Copyright © 2015 Felix Seidel. All rights reserved.
//

import ClockKit

class ComplicationController : NSObject, CLKComplicationDataSource {
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(CLKComplicationPrivacyBehavior.ShowOnLockScreen)
    }
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimelineEntry?) -> Void) {
        var template : CLKComplicationTemplate? = nil
        switch complication.family {
        case .ModularSmall:
            let modularTemplate = CLKComplicationTemplateModularSmallSimpleImage()
            modularTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "complication_icon")!)
            template = modularTemplate
        case .ModularLarge:
            template = nil
        case .UtilitarianSmall:
            let utilitarianTemplate = CLKComplicationTemplateUtilitarianSmallSquare()
            utilitarianTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "complication_icon")!)
            template = utilitarianTemplate
        case .UtilitarianLarge:
            template = nil
        case .CircularSmall:
            let circularTemplate = CLKComplicationTemplateCircularSmallSimpleImage()
            circularTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "complication_icon")!)
            template = circularTemplate
        }
        
        if(template != nil) {
            let timelineEntry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template!)
            handler(timelineEntry)
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: ([CLKComplicationTimelineEntry]?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: ([CLKComplicationTimelineEntry]?) -> Void) {
        handler([])
    }
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([CLKComplicationTimeTravelDirections.None])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate())
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate())
    }
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication,
        withHandler handler: (CLKComplicationTemplate?) -> Void) {
            var template: CLKComplicationTemplate? = nil
            switch complication.family {
            case .ModularSmall:
                let modularTemplate = CLKComplicationTemplateModularSmallSimpleImage()
                modularTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "complication_icon")!)
                template = modularTemplate
            case .ModularLarge:
                template = nil
            case .UtilitarianSmall:
                let utilitarianTemplate = CLKComplicationTemplateUtilitarianSmallSquare()
                utilitarianTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "complication_icon")!)
                template = utilitarianTemplate
            case .UtilitarianLarge:
                template = nil
            case .CircularSmall:
                let circularTemplate = CLKComplicationTemplateCircularSmallSimpleImage()
                circularTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "complication_icon")!)
                template = circularTemplate
            }
            handler(template)
    }
}
