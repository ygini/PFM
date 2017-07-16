//
//  PFMOutlineViewController.h
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PFMPreferenceManifest;

@interface PFMOutlineViewController : NSObject <NSOutlineViewDataSource>

@property PFMPreferenceManifest *preferenceManifest;

@property NSOutlineView *outlineView;

@property NSMutableDictionary *representedSettings;

@end
