#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKZHybridSessionState : NSObject

+ (void)addReactReadyBlock:(dispatch_block_t)block;
+ (void)markReactReady;
+ (void)markReactWarmupFailed:(NSError *)error;
+ (BOOL)isReactReady;
+ (NSError * _Nullable)reactWarmupError;

@end

NS_ASSUME_NONNULL_END
