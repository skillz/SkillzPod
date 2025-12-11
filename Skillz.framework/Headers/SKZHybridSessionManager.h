#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const SKZHybridSessionReadyNotification;
FOUNDATION_EXPORT NSString * const SKZHybridSessionFailedNotification;
FOUNDATION_EXPORT NSString * const SKZHybridSessionErrorUserInfoKey;

@interface SKZHybridSessionManager : NSObject

+ (void)initializeWithGrantJSON:(NSString * _Nullable)grantJSON
                      timestamp:(long long)timestamp
                     autoLaunch:(BOOL)autoLaunch;

@end

NS_ASSUME_NONNULL_END
