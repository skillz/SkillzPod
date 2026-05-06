//
//  SKZTelemetryFanOut.h
//  SkillzSDK-iOS
//
//  Single chokepoint for routing Unity-originated game telemetry to
//  Datadog RUM, Firebase Crashlytics, and the EventIngestionService.
//  Gated behind unity_telemetry_enabled.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SKZTelemetrySeverity) {
    SKZTelemetrySeverityInfo  = 0,
    SKZTelemetrySeverityWarn  = 1,
    SKZTelemetrySeverityError = 2,
};

@interface SKZTelemetryFanOut : NSObject

/// Record a telemetry event. No-op when unity_telemetry_enabled is false
/// or the event name is in the disabled-events list. Each sink branch is
/// independently isolated — a failure in one does not block the others.
+ (void)recordEvent:(NSString *)eventName
         attributes:(nullable NSDictionary<NSString *, NSString *> *)attributes
           severity:(SKZTelemetrySeverity)severity;

/// Bridge-friendly overload: takes JSON-encoded attributes and a severity
/// string ("info" | "warn" | "error"). Used by the Unity bridge externs in
/// Skillz+Unity.mm so they can pass through C strings without dictionary
/// marshaling.
+ (void)recordEventWithName:(const char *)name
             attributesJson:(nullable const char *)attrsJson
                   severity:(nullable const char *)severity;

@end

NS_ASSUME_NONNULL_END
