//
//  PFMSettingsItem.h
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PFMPreferenceProperty.h"

@interface PFMSettingsItem : NSObject

@property NSMutableArray *children;
@property BOOL isLeaf;
@property PFMPreferenceProperty *propertyManifest;
@property NSString *customKey;
@property PFMPreferencePropertyType customType;
@property id value;
@property (weak) PFMSettingsItem *parent;

- (void)updateAccordingToMandatorySettings;
- (NSString*)stringForDescriptionOfLevel:(NSInteger)descriptionLevel;
- (void)addChild:(PFMSettingsItem*)child;
- (void)removeChild:(PFMSettingsItem*)child;
- (NSArray*)availableChlidren;

@end
