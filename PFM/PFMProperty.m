//
//  PFMItem.m
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import "PFMProperty.h"
#import "PFMConstants.h"

@implementation PFMProperty

- (instancetype)initWithInfos:(NSDictionary*)initialInformations
{
    self = [super init];
    if (self) {
        NSString *typeString = [initialInformations objectForKey:kPFMType];
        
        if ([kPFMTypeArray isEqualToString:typeString]) {
            self.pfm_type = PFMPropertyTypeArray;
        } else if ([kPFMTypeBoolean isEqualToString:typeString]) {
            self.pfm_type = PFMPropertyTypeBoolean;
        } else if ([kPFMTypeDate isEqualToString:typeString]) {
            self.pfm_type = PFMPropertyTypeDate;
        } else if ([kPFMTypeData isEqualToString:typeString]) {
            self.pfm_type = PFMPropertyTypeData;
        } else if ([kPFMTypeDictionary isEqualToString:typeString]) {
            self.pfm_type = PFMPropertyTypeDictionary;
        } else if ([kPFMTypeInteger isEqualToString:typeString]) {
            self.pfm_type = PFMPropertyTypeInteger;
        } else if ([kPFMTypeReal isEqualToString:typeString]) {
            self.pfm_type = PFMPropertyTypeReal;
        } else if ([kPFMTypeString isEqualToString:typeString]) {
            self.pfm_type = PFMPropertyTypeString;
        } else if ([kPFMTypeURL isEqualToString:typeString]) {
            self.pfm_type = PFMPropertyTypeURL;
        } else {
            self.pfm_type = PFMPropertyTypeUnspecified;
        }
        
        if (self.pfm_type == PFMPropertyTypeUnspecified) {
            return nil;
        }
        
        self.pfm_name = [initialInformations objectForKey:kPFMName];
        self.pfm_title = [initialInformations objectForKey:kPFMTitle];
        
        self.pfm_default = [initialInformations objectForKey:kPFMDefault];
        self.pfm_description = [initialInformations objectForKey:kPFMDescription];
        
        NSMutableArray *targets = [NSMutableArray new];
        for (NSString *targetString in [initialInformations objectForKey:kPFMTargets]) {
            if ([kPFMTargetUser isEqualToString:targetString]) {
                [targets addObject:[NSNumber numberWithUnsignedInteger:PFMPropertyTargetUser]];
            } else if ([kPFMTargetManagedUser isEqualToString:targetString]) {
                [targets addObject:[NSNumber numberWithUnsignedInteger:PFMPropertyTargetManagedUser]];
            } else if ([kPFMTargetManagedSystem isEqualToString:targetString]) {
                [targets addObject:[NSNumber numberWithUnsignedInteger:PFMPropertyTargetManagedSystem]];
            } else {
                // TODO: Manage unkown target error
            }
        }
        self.pfm_targets = [NSArray arrayWithArray:targets];
        
        if ([initialInformations objectForKey:kPFMSubkeys]) {
            NSMutableArray *nestedProperties = [NSMutableArray new];
            
            for (NSDictionary *nestedInformations in [initialInformations objectForKey:kPFMSubkeys]) {
                PFMProperty *nestedProperty = [[PFMProperty alloc] initWithInfos:nestedInformations];
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

- (NSString*)descriptionForType:(PFMPropertyType)type {
    switch (type) {
        case PFMPropertyTypeArray:
            return kPFMTypeArray;
            break;
        case PFMPropertyTypeBoolean:
            return kPFMTypeBoolean;
            break;
        case PFMPropertyTypeDate:
            return kPFMTypeDate;
            break;
        case PFMPropertyTypeData:
            return kPFMTypeData;
            break;
        case PFMPropertyTypeDictionary:
            return kPFMTypeDictionary;
            break;
        case PFMPropertyTypeInteger:
            return kPFMTypeInteger;
            break;
        case PFMPropertyTypeReal:
            return kPFMTypeReal;
            break;
        case PFMPropertyTypeString:
            return kPFMTypeString;
            break;
        case PFMPropertyTypeURL:
            return kPFMTypeURL;
            break;
            
        default:
            return @"unkown";
            break;
    }
}

- (NSString*)descriptionForTarget:(PFMPropertyTarget)type {
    switch (type) {
        case PFMPropertyTargetUser:
            return kPFMTargetUser;
            break;
        case PFMPropertyTargetManagedUser:
            return kPFMTargetManagedUser;
            break;
        case PFMPropertyTargetManagedSystem:
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
    
    [description appendFormat:@"%@<PFMProperty key:%@, type:%@, title:\"%@\", description:\"%@\"", spaces, self.pfm_name, [self descriptionForType:self.pfm_type], self.pfm_title, self.pfm_description];
    
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
        
        for (PFMProperty *property  in self.pfm_subkeys) {
            [description appendString:[property stringForDescriptionOfLevel:descriptionLevel+1]];
            [description appendString:@"\n"];
        }
        [description appendFormat:@"%@", spaces];
    }
    
    [description appendFormat:@">"];
    
    return description;

}

@end
