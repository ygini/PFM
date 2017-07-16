//
//  PFMOutlineViewController.h
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PFMPreferenceManifest;

@interface PFMOutlineViewController : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property PFMPreferenceManifest *preferenceManifest;
@property IBOutlet NSOutlineView *outlineView;
@property NSMutableDictionary *representedSettings;

- (void)manifestSelectionIsDone;
- (void)manifestSelectionCancelled;

- (void)triggerActionPannelToSelectPreferenceManifest;

- (IBAction)addPropertyToTheSameLevel:(id)sender;
- (IBAction)addNestedProperty:(id)sender;
- (IBAction)removeSelectedProperties:(id)sender;

@end
