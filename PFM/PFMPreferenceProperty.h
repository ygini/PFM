//
//  PFMItem.h
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PFMPreferencePropertyTarget) {
    PFMPreferencePropertyTargetUser,
    PFMPreferencePropertyTargetManagedUser,
    PFMPreferencePropertyTargetManagedSystem,
};

typedef NS_ENUM(NSUInteger, PFMPreferencePropertyType) {
    PFMPreferencePropertyTypeUnspecified,
    PFMPreferencePropertyTypeArray,
    PFMPreferencePropertyTypeBoolean,
    PFMPreferencePropertyTypeDate,
    PFMPreferencePropertyTypeData,
    PFMPreferencePropertyTypeDictionary,
    PFMPreferencePropertyTypeInteger,
    PFMPreferencePropertyTypeReal,
    PFMPreferencePropertyTypeString,
    PFMPreferencePropertyTypeURL,
};

@interface PFMPreferenceProperty : NSObject

// Mandatory keys
@property NSString *pfm_name;
@property NSString *pfm_title;
@property PFMPreferencePropertyType pfm_type;
@property NSString *pfm_default;
@property NSString *pfm_description;
@property NSArray *pfm_targets;
@property NSArray *pfm_subkeys;

// Optional content

@property NSArray *pfm_range_list;

@property id pfm_range_max; //Same as the data type specified by the pfm_type key.
@property id pfm_range_min;

@property NSInteger pfm_repetition_max;
@property NSInteger pfm_repetition_min;

// Read and write values for preference creation

@property id user_value;

// Object lifecycle

- (instancetype)initWithInfos:(NSDictionary*)initialInformations;

- (NSString*)stringForDescriptionOfLevel:(NSInteger)descriptionLevel;
- (NSString*)descriptionForTarget:(PFMPreferencePropertyTarget)type;
- (NSString*)descriptionForType:(PFMPreferencePropertyType)type;

@end
