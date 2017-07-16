//
//  PFMDomain.h
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFMProperty.h"

@interface PFMPreferenceManifest : NSObject

@property NSString *pfm_description;
@property NSString *pfm_title;
@property NSNumber *pfm_format_version;
@property NSNumber *pfm_version;
@property NSString *pfm_domain;
@property NSArray *pfm_subkeys;

- (instancetype)initWithContentOfFile:(NSString*)filePath;
- (instancetype)initWithContentOfURL:(NSURL*)fileURL;
- (instancetype)initWithPreferencesManifest:(NSDictionary*)preferenceManifest;

@end
