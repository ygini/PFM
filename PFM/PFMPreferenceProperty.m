//
//  PFMItem.m
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import "PFMPreferenceProperty.h"
#import "PFMConstants.h"

@implementation PFMPreferenceProperty

- (instancetype)initWithInfos:(NSDictionary*)initialInformations
{
    self = [super init];
    if (self) {
        NSString *typeString = [initialInformations objectForKey:kPFMType];
        
        if ([kPFMTypeArray isEqualToString:typeString]) {
            self.pfm_type = PFMPreferencePropertyTypeArray;
        } else if ([kPFMTypeBoolean isEqualToString:typeString]) {
            self.pfm_type = PFMPreferencePropertyTypeBoolean;
        } else if ([kPFMTypeDate isEqualToString:typeString]) {
            self.pfm_type = PFMPreferencePropertyTypeDate;
        } else if ([kPFMTypeData isEqualToString:typeString]) {
            self.pfm_type = PFMPreferencePropertyTypeData;
        } else if ([kPFMTypeDictionary isEqualToString:typeString]) {
            self.pfm_type = PFMPreferencePropertyTypeDictionary;
        } else if ([kPFMTypeInteger isEqualToString:typeString]) {
            self.pfm_type = PFMPreferencePropertyTypeInteger;
        } else if ([kPFMTypeReal isEqualToString:typeString]) {
            self.pfm_type = PFMPreferencePropertyTypeReal;
        } else if ([kPFMTypeString isEqualToString:typeString]) {
            self.pfm_type = PFMPreferencePropertyTypeString;
        } else if ([kPFMTypeURL isEqualToString:typeString]) {
            self.pfm_type = PFMPreferencePropertyTypeURL;
        } else {
            self.pfm_type = PFMPreferencePropertyTypeUnspecified;
        }
        
        if (self.pfm_type == PFMPreferencePropertyTypeUnspecified) {
            return nil;
        }
        
        self.pfm_name = [initialInformations objectForKey:kPFMName];
        self.pfm_title = [initialInformations objectForKey:kPFMTitle];
        
        self.pfm_default = [initialInformations objectForKey:kPFMDefault];
        self.pfm_description = [initialInformations objectForKey:kPFMDescription];
        
        NSMutableArray *targets = [NSMutableArray new];
        for (NSString *targetString in [initialInformations objectForKey:kPFMTargets]) {
            if ([kPFMTargetUser isEqualToString:targetString]) {
                [targets addObject:[NSNumber numberWithUnsignedInteger:PFMPreferencePropertyTargetUser]];
            } else if ([kPFMTargetManagedUser isEqualToString:targetString]) {
                [targets addObject:[NSNumber numberWithUnsignedInteger:PFMPreferencePropertyTargetManagedUser]];
            } else if ([kPFMTargetManagedSystem isEqualToString:targetString]) {
                [targets addObject:[NSNumber numberWithUnsignedInteger:PFMPreferencePropertyTargetManagedSystem]];
            } else {
                // TODO: Manage unkown target error
            }
        }
        self.pfm_targets = [NSArray arrayWithArray:targets];
        
        if ([initialInformations objectForKey:kPFMSubkeys]) {
            NSMutableArray *nestedProperties = [NSMutableArray new];
            
            for (NSDictionary *nestedInformations in [initialInformations objectForKey:kPFMSubkeys]) {
                PFMPreferenceProperty *nestedProperty = [[PFMPreferenceProperty alloc] initWithInfos:nestedInformations];
                if (nestedProperty) {
                    [nestedProperties addObject:nestedProperty];
                } else {
                    // TODO: Manage property loading error
                }
            }
            
            self.pfm_subkeys = [NSArray arrayWithArray:nestedProperties];
        }
        
        self.pfm_range_max = [initialInformations objectForKey:kPFMRangeMax];
        self.pfm_range_min = [initialInformations objectForKey:kPFMRangeMin];
        
        self.pfm_range_list = [initialInformations objectForKey:kPFMRangeList];
        
        NSNumber *aNumber = [initialInformations objectForKey:kPFMRepetitionMax];
        
        if (aNumber) {
            self.pfm_repetition_max = [aNumber integerValue];
        } else {
            self.pfm_repetition_max = -1;
        }
        
        aNumber = [initialInformations objectForKey:kPFMRepetitionMin];
        
        if (aNumber) {
            self.pfm_repetition_min = [aNumber integerValue];
        } else {
            self.pfm_repetition_min = 0;
        }
        
    }
    return self;
}

-(NSString *)description {
    return [self stringForDescriptionOfLevel:0];
}

- (NSString*)descriptionForType:(PFMPreferencePropertyType)type {
    switch (type) {
        case PFMPreferencePropertyTypeArray:
            return kPFMTypeArray;
            break;
        case PFMPreferencePropertyTypeBoolean:
            return kPFMTypeBoolean;
            break;
        case PFMPreferencePropertyTypeDate:
            return kPFMTypeDate;
            break;
        case PFMPreferencePropertyTypeData:
            return kPFMTypeData;
            break;
        case PFMPreferencePropertyTypeDictionary:
            return kPFMTypeDictionary;
            break;
        case PFMPreferencePropertyTypeInteger:
            return kPFMTypeInteger;
            break;
        case PFMPreferencePropertyTypeReal:
            return kPFMTypeReal;
            break;
        case PFMPreferencePropertyTypeString:
            return kPFMTypeString;
            break;
        case PFMPreferencePropertyTypeURL:
            return kPFMTypeURL;
            break;
            
        default:
            return @"unkown";
            break;
    }
}

- (NSString*)descriptionForTarget:(PFMPreferencePropertyTarget)type {
    switch (type) {
        case PFMPreferencePropertyTargetUser:
            return kPFMTargetUser;
            break;
        case PFMPreferencePropertyTargetManagedUser:
            return kPFMTargetManagedUser;
            break;
        case PFMPreferencePropertyTargetManagedSystem:
            return kPFMTargetManagedSystem;
            break;
        default:
            return @"unkown";
            break;
    }
}

- (NSString*)stringForDescriptionOfLevel:(NSInteger)descriptionLevel {
    NSMutableString *spaces = [NSMutableString new];
    for (int i = 0; i < descriptionLevel; i++) {
        [spaces appendString:@"\t\t"];
    }
    
    NSMutableString *description = [NSMutableString new];
    
    [description appendFormat:@"%@<%@ key:%@, type:%@, title:\"%@\", description:\"%@\"", spaces, self.className, self.pfm_name, [self descriptionForType:self.pfm_type], self.pfm_title, self.pfm_description];
    
    if ([self.pfm_range_list count] > 0) {
        [description appendFormat:@"\n%@+ range_list:\n", spaces];
        
        for (id acceptableValue  in self.pfm_range_list) {
            [description appendFormat:@"%@\t- ", spaces];
            [description appendString:[acceptableValue description]];
            [description appendString:@";\n"];
        }
        [description appendFormat:@"%@", spaces];
    }
    
    if ([self.pfm_targets count] > 0) {
        [description appendFormat:@"\n%@+ targets:\n", spaces];
        
        for (NSNumber *targetValue  in self.pfm_targets) {
            [description appendFormat:@"%@\t- ", spaces];
            [description appendString:[self descriptionForTarget:[targetValue unsignedIntegerValue]]];
            [description appendString:@"\n"];
        }
        [description appendFormat:@"%@", spaces];
    }
    
    if (self.pfm_subkeys) {
        [description appendFormat:@"\n%@+ subkeys:\n", spaces];
        
        for (PFMPreferenceProperty *property  in self.pfm_subkeys) {
            [description appendString:[property stringForDescriptionOfLevel:descriptionLevel+1]];
            [description appendString:@"\n"];
        }
        [description appendFormat:@"%@", spaces];
    }
    
    [description appendFormat:@">"];
    
    return description;

}

@end
