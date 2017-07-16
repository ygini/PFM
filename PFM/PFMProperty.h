//
//  PFMItem.h
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PFMPropertyTarget) {
    PFMPropertyTargetUser,
    PFMPropertyTargetManagedUser,
    PFMPropertyTargetManagedSystem,
};

typedef NS_ENUM(NSUInteger, PFMPropertyType) {
    PFMPropertyTypeUnspecified,
    PFMPropertyTypeArray,
    PFMPropertyTypeBoolean,
    PFMPropertyTypeDate,
    PFMPropertyTypeData,
    PFMPropertyTypeDictionary,
    PFMPropertyTypeInteger,
    PFMPropertyTypeReal,
    PFMPropertyTypeString,
    PFMPropertyTypeURL,
};

@interface PFMProperty : NSObject

// Mandatory keys
@property NSString *pfm_name;
@property NSString *pfm_title;
@property PFMPropertyType pfm_type;
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

// Object lifecycle

- (instancetype)initWithInfos:(NSDictionary*)initialInformations;

- (NSString*)stringForDescriptionOfLevel:(NSInteger)descriptionLevel;

@end
