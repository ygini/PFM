//
//  PFMOutlineViewController.m
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import "PFMOutlineViewController.h"

#import "PFMPreferenceManifest.h"
#import "PFMManifestProvider.h"

@implementation PFMOutlineViewController

#pragma mark - NSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewDidAppear {
    [super viewDidAppear];
    
    if (!self.preferenceManifest) {
        [self triggerActionPannelToSelectPreferenceManifest];
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
}

- (void)manifestSelectionIsDone {
    [self.outlineView reloadItem:nil];
}

- (void)manifestSelectionCancelled {
    [self.view.window close];
}

- (void)triggerActionPannelToSelectPreferenceManifest {
    
}

#pragma mark - Actions

- (IBAction)addPropertyToTheSameLevel:(id)sender {
    
}

- (IBAction)addNestedProperty:(id)sender {
    
}

- (IBAction)removeSelectedProperties:(id)sender {
    
}

#pragma mark - NSOutlineView
#pragma mark Child management

-(BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(PFMPreferenceProperty*)item {
    return item.pfm_subkeys != nil;
}

-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(PFMPreferenceProperty*)item {
    if (!item) {
        return [self.preferenceManifest.pfm_subkeys count];
    } else {
        return [item.pfm_subkeys count];
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(PFMPreferenceProperty*)item {
    if (!item) {
        return [self.preferenceManifest.pfm_subkeys objectAtIndex:index];
    } else {
        return [item.pfm_subkeys objectAtIndex:index];
    }
}

#pragma mark Content management

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(PFMPreferenceProperty*)item {
    return [item valueForKey:tableColumn.identifier];
}

@end
