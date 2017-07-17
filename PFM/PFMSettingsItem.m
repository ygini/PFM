//
//  PFMSettingsItem.m
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import "PFMSettingsItem.h"



@implementation PFMSettingsItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.children = [NSMutableArray new];
    }
    return self;
}


- (void)updateAccordingToMandatorySettings {
    if ([self.propertyManifest.pfm_subkeys count] > 0) {
        for (PFMPreferenceProperty *property in self.propertyManifest.pfm_subkeys) {
            for (int i = 0; i < property.pfm_repetition_min ; i++) {
                PFMSettingsItem *item = [PFMSettingsItem new];
                item.propertyManifest = property;
                [item updateAccordingToMandatorySettings];
                [self addChild:item];
            }
        }
        self.isLeaf = NO;
    } else {
        self.isLeaf = YES;
    }
    
}

- (void)addChild:(PFMSettingsItem*)child {
    child.parent = self;
    [self.children addObject:child];
}

- (void)removeChild:(PFMSettingsItem*)child {
    [self.children removeObject:child];
    child.parent = nil;
}

- (NSArray*)availableChlidren {
    NSMutableDictionary *reamingChildren = [NSMutableDictionary new];
    NSMutableArray *availableChildren = [NSMutableArray new];
    for (PFMPreferenceProperty *childProperty in self.propertyManifest.pfm_subkeys) {
        NSInteger max = childProperty.pfm_repetition_max;
        if (max == -1) {
            max = NSIntegerMax;
        }
        [reamingChildren setObject:[NSNumber numberWithInteger:max]
                            forKey:childProperty.pfm_name];
    }
    
    for (PFMSettingsItem *child in self.children) {
        NSNumber *counter = [reamingChildren objectForKey:child.propertyManifest.pfm_name];
        if (counter) {
            [reamingChildren setObject:[NSNumber numberWithInteger:[counter integerValue] - 1]
                                forKey:child.propertyManifest.pfm_name];
        }
    }
    
    for (PFMPreferenceProperty *childProperty in self.propertyManifest.pfm_subkeys) {
        NSNumber *reamingAmount = [reamingChildren objectForKey:childProperty.pfm_name];
        
        if ([reamingAmount integerValue] > 0) {
            [availableChildren addObject:childProperty];
        }
    }
    
    [availableChildren sortUsingSelector:@selector(compare:)];
    
    return [NSArray arrayWithArray:availableChildren];
}

-(NSString *)description {
    return [self stringForDescriptionOfLevel:0];
}

- (NSString*)stringForDescriptionOfLevel:(NSInteger)descriptionLevel {
    NSMutableString *spaces = [NSMutableString new];
    for (int i = 0; i < descriptionLevel; i++) {
        [spaces appendString:@"\t\t"];
    }
    
    NSMutableString *description = [NSMutableString new];
    
    if (self.isLeaf) {
        [description appendFormat:@"%@<%@ key:%@, value:\"%@\">", spaces, self.className, self.propertyManifest.pfm_name, self.value];
    } else {
        [description appendFormat:@"%@<%@ key:%@, children:", spaces, self.className, self.propertyManifest.pfm_name];
        
        for (PFMSettingsItem *property  in self.children) {
            [description appendString:[property stringForDescriptionOfLevel:descriptionLevel+1]];
            [description appendString:@"\n"];
        }
        
        [description appendFormat:@">"];
    }
    
    return description;
    
}



@end
