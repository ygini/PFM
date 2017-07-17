//
//  PFMSettingsRepresenation.h
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PFMPreferenceManifest.h"

@class PFMSettingsItem;

@interface PFMSettingsRepresentation : NSObject

@property NSMutableArray *children;
@property PFMPreferenceManifest *manifest;

- (void)updateAccordingToMandatorySettings;
- (void)addChild:(PFMSettingsItem*)child;
- (void)removeChild:(PFMSettingsItem*)child;
- (NSArray*)availableChlidren;

@end
