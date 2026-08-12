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

/// Set the observability correlation context (session_id, journey_run_id,
/// schema_version, ...) that gets merged into every fan-out envelope. Pushed
/// from JS via SkillzModule.setObservabilityContext so Unity-originated events
/// share the same funnel correlation as the JS observability stream.
+ (void)setObservabilityContext:(nullable NSDictionary<NSString *, NSString *> *)context;

/// The current observability correlation context, or nil if JS has not pushed
/// one yet. Read by SKZEventPayloadBuilder so natively-assembled EventIngestion
/// events (which never pass through the JS telemetry layer) can be stamped with
/// the same session_id / journey_id correlation.
+ (nullable NSDictionary<NSString *, NSString *> *)observabilityContextSnapshot;

/// The process-stable observability session id, minted once on first access —
/// which happens during native bootstrap, before the JS bundle loads. This is the
/// SINGLE source of truth for session_id: native events stamp it directly and JS
/// reads it via SkillzModule.constantsToExport, so native-originated bootstrap
/// events and the JS observability stream share ONE session. Never nil.
+ (NSString *)observabilitySessionId;

/// The per-launch observability journey_run_id (the app_launch run), minted once.
/// Used as journey_run_id for events that fire before JS pushes a flow run, so the
/// every-event envelope always carries a run correlation key. Never nil.
+ (NSString *)observabilityLaunchRunId;

@end

NS_ASSUME_NONNULL_END
