//
//  PFMSettingsRepresenation.m
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import "PFMSettingsRepresentation.h"
#import "PFMSettingsItem.h"

@implementation PFMSettingsRepresentation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.children = [NSMutableArray new];
    }
    return self;
}

- (void)updateAccordingToMandatorySettings {
    for (PFMPreferenceProperty *property in self.manifest.pfm_subkeys) {
        for (int i = 0; i < property.pfm_repetition_min ; i++) {
            PFMSettingsItem *item = [PFMSettingsItem new];
            item.propertyManifest = property;
            [item updateAccordingToMandatorySettings];
            [self addChild:item];
        }
    }
}

-(NSString *)description {
    NSMutableString *description = [NSMutableString new];
    
    [description appendFormat:@"<%@ domain:%@, keys:\n", self.className, self.manifest.pfm_domain];
    for (PFMSettingsItem *item  in self.children) {
        [description appendString:[item stringForDescriptionOfLevel:1]];
        [description appendString:@"\n"];
    }
    [description appendFormat:@">"];
    
    return description;
}

- (void)addChild:(PFMSettingsItem*)child {
    [self.children addObject:child];
}

- (void)removeChild:(PFMSettingsItem*)child {
    [self.children removeObject:child];
}

- (NSArray*)availableChlidren {
    NSMutableDictionary *reamingChildren = [NSMutableDictionary new];
    NSMutableArray *availableChildren = [NSMutableArray new];
    for (PFMPreferenceProperty *childProperty in self.manifest.pfm_subkeys) {
        NSInteger max = childProperty.pfm_repetition_max;
        if (max == -1) {
            max = NSIntegerMax;
        }
        [reamingChildren setObject:[NSNumber numberWithInteger:max]
                        forKey:childProperty.pfm_name];
    }
    
    for (PFMSettingsItem *child in self.children) {
        if (child.propertyManifest) {
            NSNumber *counter = [reamingChildren objectForKey:child.propertyManifest.pfm_name];
            [reamingChildren setObject:[NSNumber numberWithInteger:[counter integerValue] - 1]
                                forKey:child.propertyManifest.pfm_name];
        }
    }
    
    for (PFMPreferenceProperty *childProperty in self.manifest.pfm_subkeys) {
        NSNumber *reamingAmount = [reamingChildren objectForKey:childProperty.pfm_name];
        
        if ([reamingAmount integerValue] > 0) {
            [availableChildren addObject:childProperty];
        }
    }
    
    [availableChildren sortUsingSelector:@selector(compare:)];
    
    return [NSArray arrayWithArray:availableChildren];
}

@end
