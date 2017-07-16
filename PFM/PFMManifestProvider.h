//
//  PFMManifestProvider.h
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFMManifestProvider : NSObject

@property NSDictionary *manifestsPerSourceAndDomain;
@property NSDictionary *globalManifestsPerSourceAndName;

+ (instancetype)sharedInstance;
- (void)reloadManifests;

@end
