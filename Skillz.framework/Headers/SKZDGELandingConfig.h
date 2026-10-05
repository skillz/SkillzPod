//
//  SKZDGELandingConfig.h
//  SkillzSDK-iOS
//
//  Copyright © 2026 Skillz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Why the SDK did or did not ask the host to show the Direct Game Entry landing screen.
 *
 * This exists because four different situations all look identical from outside — the
 * host simply does not show DGE buttons — but they mean very different things, and we
 * cannot improve the feature without telling them apart.
 */
typedef NS_ENUM(NSInteger, SKZDGELandingDecision) {
    /**
     * The settings call has not returned yet. The host should render whatever it renders
     * today rather than a blank screen or a spinner.
     *
     * Users who land here are NOT controls: they are systematically the ones on slow
     * networks, so folding them into the control arm biases any experiment by device
     * quality and region. They belong in their own bucket.
     */
    SKZDGELandingDecisionUnresolved = 0,

    /** Flag on, no credentials yet: show the landing screen. */
    SKZDGELandingDecisionShown,

    /**
     * Settings returned, but carried no DGE key at all. This is a deployment or
     * coverage gap, not a decision about this user — worth distinguishing from an
     * explicit false.
     */
    SKZDGELandingDecisionSuppressedKeyAbsent,

    /** Settings carried the key, set to false. This user was deliberately excluded. */
    SKZDGELandingDecisionSuppressedFlagOff,

    /**
     * Flag on, but credentials already exist, so this is not a first run. Existing
     * behaviour by design: the player goes straight to the lobby.
     */
    SKZDGELandingDecisionSuppressedHasCredentials
};

/** Human-readable form of a decision, for logs and telemetry. */
FOUNDATION_EXPORT NSString *SKZStringFromDGELandingDecision(SKZDGELandingDecision decision);

/**
 * Posted when a settings response changes the landing decision after the host has
 * already rendered.
 *
 * The host is expected to paint immediately with whatever is known — on a first launch
 * that means today's experience, because no decision can be made until settings returns.
 * This is how it learns the answer afterwards and upgrades. The config is in
 * `userInfo[SKZDGELandingConfigKey]`.
 */
FOUNDATION_EXPORT NSString * const SKZDGELandingConfigDidUpdateNotification;
FOUNDATION_EXPORT NSString * const SKZDGELandingConfigKey;

/**
 * What the SDK tells the host game to render on the landing screen.
 *
 * Always non-nil so the host can read `decision` and know why it is being told to fall
 * back; `shouldShowLandingScreen` is the single question most hosts need answered.
 */
@interface SKZDGELandingConfig : NSObject

/** Why this configuration is what it is. */
@property (nonatomic, readonly) SKZDGELandingDecision decision;

/**
 * `decision` in readable form.
 *
 * Available as a method as well as the C function above because plain C symbols are not
 * exported from the framework by default, so hosts linking against the built framework
 * can reach this but not `SKZStringFromDGELandingDecision`.
 */
@property (nonatomic, readonly, copy) NSString *decisionName;

/** Convenience: YES only when decision == SKZDGELandingDecisionShown. */
@property (nonatomic, readonly) BOOL shouldShowLandingScreen;

@property (nonatomic, readonly) BOOL showPracticeButton;
@property (nonatomic, readonly) BOOL showCashButton;

/**
 * Consent copy, including the 18+ attestation.
 *
 * Supplied by the SDK rather than authored per game, so that independently-written
 * landing screens cannot quietly drop the age clause.
 */
@property (nonatomic, readonly, copy) NSString *consentString;

#pragma mark Raw inputs — kept so the decision is auditable rather than merely trusted

/** Whether the settings response carried the DGE key at all. */
@property (nonatomic, readonly) BOOL settingsKeyPresent;
/** The flag's value, if it was present. */
@property (nonatomic, readonly) BOOL flagValue;
/** Whether credentials already existed when the decision was made. */
@property (nonatomic, readonly) BOOL hasCredentials;

#pragma mark Notification names

/**
 * Accessors for the notification name and userInfo key.
 *
 * Class methods rather than only the C constants above, for the same reason
 * `decisionName` exists: plain C symbols are not exported from the built framework, so a
 * host linking against it can call these but cannot reference
 * `SKZDGELandingConfigDidUpdateNotification` directly.
 */
+ (NSString *)didUpdateNotificationName;
+ (NSString *)configUserInfoKey;

@end

NS_ASSUME_NONNULL_END
