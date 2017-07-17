//
//  PFMOutlineViewController.h
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PFMPreferenceManifest, PFMSettingsRepresentation, PFMSettingsItem;

@interface PFMOutlineViewController : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate, NSComboBoxCellDataSource>

@property PFMPreferenceManifest *preferenceManifest;
@property PFMSettingsRepresentation *representedSettings;
@property IBOutlet NSOutlineView *outlineView;

- (void)manifestSelectionIsDone;
- (void)manifestSelectionCancelled;

- (void)triggerActionPannelToSelectPreferenceManifest;

- (IBAction)addPropertyToTheSameLevel:(id)sender;
- (IBAction)addNestedProperty:(id)sender;
- (IBAction)removeSelectedProperties:(id)sender;

@end
