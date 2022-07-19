//
//  SKZSeason.h
//  Skillz
//
//  Created by Ramya Adattiri on 04/11/21.
//  Copyright © 2021 Skillz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKZSeason : NSObject

/**
 * Unique identifier for the season
 */
@property (readonly, nonnull) NSString *id;

/**
 * A DateTime object representing the start time of the season
 */
@property (readonly, nullable) NSDate *startTime;

/**
 * A DateTime object representing the end time of the season
 */
@property (readonly, nullable) NSDate *endTime;

/**
 * The developer defined name for the season
 */
@property (readonly, nullable) NSString *name;

/**
 * The developer defined description of the seasons
 */
@property (readonly, nullable) NSString *seasonDescription;

/**
 * Whether or not the season is currently active
 */
@property (readonly) BOOL isActive;

/**
 * Custom params defined by the game developers parsed into a dictionary of Strings. This is parse from the season_params array
 */
@property (readonly, nullable) NSDictionary *seasonParams;

/**
 * The relative position of this season to the current active season.
 * E.g. -1 means the prior season, -2 means 2 seasons ago, 1 means next, and 2 means 2 seasons from now
 */
@property (readonly) NSInteger index;

/**
 * The json string of season object for the Unity bridge
 */
@property (readonly, nullable) NSString *seasonJson;

@end

NS_ASSUME_NONNULL_END
