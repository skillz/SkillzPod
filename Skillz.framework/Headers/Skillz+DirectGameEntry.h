//
//  Skillz+DirectGameEntry.h
//  SkillzSDK-iOS
//
//  Copyright © 2026 Skillz. All rights reserved.
//

// Resolves both when compiled inside the SDK and when imported from the built framework.
#if __has_include(<Skillz/Skillz.h>)
    #import <Skillz/Skillz.h>
    #import <Skillz/SKZDGELandingConfig.h>
#else
    #import "Skillz.h"
    #import "SKZDGELandingConfig.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 * Direct Game Entry: first-run landing screen and practice-match preparation.
 *
 * The landing screen itself belongs to the game, not the SDK. The SDK's job is to decide
 * whether it should be shown and to publish that decision; the host renders it and calls
 * back at the two moments that matter during the practice match.
 */
@interface Skillz (DirectGameEntry)

/**
 * Whether DGE is enabled, combining the server-pushed client property with the local
 * development override. Every call site must read this rather than either input, so that
 * the branch taken and the decision recorded cannot disagree.
 */
- (BOOL)isDGELandingEnabled;

/**
 * Resolve the landing configuration as of right now, without waiting.
 *
 * Always non-nil. When DGE is not being shown, the returned config still carries the
 * reason via `decision` — including `Unresolved`, meaning the settings call has not
 * come back yet and the host should render what it renders today.
 *
 * Resolution alone emits no telemetry — call `notifyLandingScreenDidRenderWithConfig:`
 * when the screen actually appears.
 */
- (SKZDGELandingConfig *)dgeLandingConfig;

/**
 * Resolve the landing configuration, waiting for settings if it has not arrived yet.
 *
 * The completion is called exactly once, on the main queue:
 *   - immediately, if the decision can already be made;
 *   - when settings lands, if it cannot;
 *   - with the `Unresolved` config after `timeout` seconds, whichever comes first.
 *
 * Use this to drive a disabled/spinner state on the landing buttons rather than
 * blocking. Pass a timeout you are willing to make the player wait — on expiry you get
 * `Unresolved` and should render today's experience rather than keep waiting.
 */
- (void)resolveDGELandingConfigWithTimeout:(NSTimeInterval)timeout
                                completion:(void (^)(SKZDGELandingConfig *config))completion;

/**
 * Called by the host once the landing screen is on screen.
 *
 * Exposure is logged here, at render time, rather than when the decision was resolved —
 * otherwise users who never saw the screen are counted as having been exposed to it.
 */
- (void)notifyLandingScreenDidRenderWithConfig:(SKZDGELandingConfig *)config;

/**
 * Whether automatic prewarm is on, from the server-pushed `dge.prewarm.enabled` client
 * property. There is deliberately no local force-on override: the development simulation
 * injects into the settings response instead, so nothing can override the server.
 *
 * With this off the SDK behaves exactly as production does today: no prewarm from any
 * entry point. It is the kill switch for titles we do not control -- starting the
 * JavaScript runtime early costs memory in a window the host may also be using, so a
 * regression can be reverted server-side rather than by an SDK release.
 */
- (BOOL)isAutomaticPrewarmEnabled;

/**
 * Start prewarming regardless of which path the player takes.
 *
 * Called by the SDK when background preloading completes -- not tied to any button, so
 * Launch Skillz and Play Cash benefit as much as the practice path. Returns immediately;
 * safe to call repeatedly, and a no-op when the flag is off or prewarm already ran.
 */
- (void)skz_prewarmForLaunchIfEnabled;

/**
 * Called by the host once the practice match is running and has rendered its first frame.
 *
 * Now a secondary trigger: prewarm normally starts by itself when background preloading
 * completes (see `skz_prewarmForLaunchIfEnabled`), so this only has an effect when the
 * practice match reaches its first frame before preloading has finished. Whichever
 * arrives first wins; the other is a no-op.
 *
 * Subject to the same `dge.prewarm.enabled` gate — with the flag off this does nothing.
 *
 * Returns immediately; all work is asynchronous. Safe to call more than once.
 */
- (void)notifyPracticeMatchDidRenderFirstFrame;

/** How far the practice match got with launch preparation, as of right now. */
typedef NS_ENUM(NSInteger, SKZDGELaunchReadiness) {
    /** Prewarm never ran, or ran and failed — the loading screen behaves exactly as today. */
    SKZDGELaunchReadinessNotPrepared = 0,
    /** Prewarm is still running: work is under way but no milestone is confirmed. */
    SKZDGELaunchReadinessPartial,
    /** JavaScript is confirmed loaded — only launch data remains. */
    SKZDGELaunchReadinessReady
};

/**
 * How ready the JavaScript runtime is right now.
 *
 * Three states rather than a yes/no because the middle one is the common case and is
 * worth distinguishing: folding it into "not ready" throws away everything the practice
 * match achieved and restarts the progress bar at zero, while folding it into "ready"
 * hands the lobby a runtime that has not finished starting.
 *
 * This reports the runtime only. Whether a lobby can actually be shown also needs a
 * user, which is tracked separately — see `notifyPracticeMatchDidEnd`.
 */
- (SKZDGELaunchReadiness)launchReadiness;

/**
 * Whether the next launch may skip the loading screen, clearing the flag as it reads it.
 *
 * Set when a practice match finishes with preparation complete. Consumed rather than
 * merely read so that a subsequent un-prewarmed launch cannot inherit it and end up
 * rendering a lobby that is not ready.
 */
- (BOOL)consumeSkipLoadingScreenForDirectGameEntry;

/**
 * Launch into the lobby following a Direct Game Entry practice match.
 *
 * A separate entry point rather than a flag on `launchSkillz`, so that the existing
 * launch is provably untouched: everything reached from `launchSkillz` -- the Play Cash
 * button included -- behaves exactly as it does in production today, and no reviewer has
 * to reason about whether a new branch can leak into it.
 *
 * Differs from `launchSkillz` in exactly two ways, both scoped to this launch only:
 *   - profile creation (FTUE) is skipped, always;
 *   - the loading screen is skipped when preparation completed, and otherwise shown
 *     resumed from the progress the practice match earned.
 */
- (void)launchSkillzAfterPracticeMatch;

/**
 * Whether the launch currently in progress came from `launchSkillzAfterPracticeMatch`.
 *
 * Armed for one launch and consumed by the next `launchSkillz`, so a later plain launch
 * cannot inherit it. Read when assembling the React initial properties, which is why it
 * cannot simply be consumed at the start of launching -- the props are built later.
 */
- (BOOL)isDirectGameEntryLaunch;

/**
 * Called at the top of `launchSkillz` to transfer the armed flag onto this launch.
 * Every launch consumes the arming, so only the launch immediately following
 * `launchSkillzAfterPracticeMatch` is treated as a Direct Game Entry launch.
 */
- (void)skz_beginLaunchConsumingDirectGameEntryArming;

/**
 * Called by the host when the practice match ends.
 *
 * Returns immediately. If preparation has not finished, this does not wait for it: the
 * player falls back to the existing loading screen. Never abort preparation, only defer
 * it — a half-prepared SDK must degrade to today's behaviour, not fail.
 */
- (void)notifyPracticeMatchDidEnd;

#pragma mark - SDK-internal (not part of the host contract)

/**
 * Called by the settings layer once a response has been applied, so callers waiting on
 * `resolveDGELandingConfigWithTimeout:completion:` can be answered.
 */
- (void)skz_notifyDGESettingsDidArrive;

/**
 * SKZ_DGE_POC_REMOVE_ME
 *
 * Temporary scaffolding: the settings endpoint does not serve `dge.landing.enabled` yet,
 * so this rewrites the response as though it did. Returns the response unchanged unless
 * a simulation is configured in Skillz+DirectGameEntry.m.
 *
 * Injecting into the response — rather than writing NSUserDefaults directly — means the
 * parsing chain, storage, decision and telemetry all run exactly as they will once the
 * server serves the key. Only the origin of the value differs.
 *
 * To remove when the server is ready: `grep -rn SKZ_DGE_POC_REMOVE_ME` and delete every
 * hit, plus the SKZDGESimulatedSetting enum and its constant.
 */
+ (id)responseByInjectingSimulatedDGESettings:(id)responseObject;

@end

NS_ASSUME_NONNULL_END
