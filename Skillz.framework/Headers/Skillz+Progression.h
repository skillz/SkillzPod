//
//  Skillz+Progression.h
//  Skillz
//
//  Created by Tyler Gier on 2/24/21.
//  Copyright © 2021 Skillz. All rights reserved.
//

#import "SkillzInstance.h"
#import "SKZSeason.h"

/**
 * The default progression data namespace. This is READ ONLY and contains information
 * tracked and maintained by Skillz.
 */
static const NSString* _Nonnull ProgressionNamespaceDefaultPlayerData = @"DefaultPlayerData";
/**
 * The namespace for all Player Data keys configured and tracked by the
 * game developer.
 */
static const NSString* _Nonnull ProgressionNamespacePlayerData = @"PlayerData";
/**
 * The namespace for all In Game Items keys configured and tracked by the
 * game developer.
 */
static const NSString* _Nonnull ProgressionNamespaceInGameItems = @"InGameItems";

@interface Skillz (Progression)

/**
 * Call this function to fetch user data for the given keys from the Skillz servers.
 *
 * @param progressionNamespace The name of the progression data set to fetch
 * @param userDataKeys A list of the keys to fetch the player progression data for
 * @param successCompletion A completion function that is called when the data has been successfully retrieved. It is called
 *          with a dictionary containing the key-value pairs for the requested data.
 * @param failureCompletion A completion function that is called when the data retrieval has failed.
 */
- (void)getUserDataForNamespace:(NSString *)progressionNamespace
                       withKeys:(NSMutableArray *)userDataKeys
                    withSuccess:(void (^_Nonnull)(NSDictionary * userData))successCompletion
                    withFailure:(void (^_Nonnull)(NSString * error))failureCompletion;

/**
 * Call this function to update user data with the given data. This function can only update 25 elements at a time.
 *
 * @param progressionNamespace The name of the progression data set to fetch
 * @param userDataUpdates A list of the keys to fetch the player progression data for
 * @param successCompletion A completion function that is called when the data has been successfully retrieved. It is called
 *          with a dictionary containing the key-value pairs for the requested data.
 * @param failureCompletion A completion function that is called when the data retrieval has failed.
 */
- (void)updateUserDataForNamespace:(NSString *)progressionNamespace
                      withUserData:(NSDictionary *)userDataUpdates
                       withSuccess:(void (^_Nonnull)(NSDictionary * userData))successCompletion
                       withFailure:(void (^_Nonnull)(NSString * error))failureCompletion;

/**
 * This method fetches and returns the current active season. If no season is active, it returns null.
 *
 * @param successCallback A completion function that is invoked when the current season (or null) is successfully retrieved.
 * @param failureCallback A completion function invoked with an error string if the current season could not be fetched.
*/

-(void)getCurrentSeason:(void (^_Nonnull)(SKZSeason *season))successCallback
                       withFailure:(void (^_Nonnull)(NSString *error))failureCallback;

/**
 * This method returns an array of the next seasons in chronological order. If no future seasons are available it returns an empty array.
 *
 * @param count The amount of seasons returned is up to the given count argument. The requested count must be at least 1.
 * @param successCallback A completion function that is invoked when the season's array is successfully retrieved
 * @param failureCallback A completion function invoked with an error string if  upcoming seasons could not be fetched
*/

-(void)getNextSeasons:(int)count
          withSuccess: (void (^_Nonnull)(NSArray *seasons))successCallback
          withFailure:(void (^_Nonnull)(NSString *error))failureCallback;

/**
 * This method returns an array of previous seasons in chronological order. If no previous seasons are available it returns an empty array.
 *
 * @param count The amount of seasons returned is up to the given count argument. The requested count must be at least 1
 * @param successCallback A completion function that is invoked when the previous season's array is successfully retrieved
 * @param failureCallback A completion function invoked with an error string if previous seasons could not be fetched
*/

-(void)getPreviousSeasons:(int)count
              withSuccess: (void (^_Nonnull)(NSArray *seasons))successCallback
              withFailure:(void (^_Nonnull)(NSString *error))failureCallback;

- (void)launchProgressionRoom;

@end
