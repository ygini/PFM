//
//  PFMOutlineViewController.m
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import "PFMOutlineViewController.h"

#import "PFMPreferenceManifest.h"

@implementation PFMOutlineViewController

#pragma mark - Child management 

-(BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(PFMProperty*)item {
    return item.pfm_subkeys != nil;
}

-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(PFMProperty*)item {
    if (!item) {
        return [self.preferenceManifest.pfm_subkeys count];
    } else {
        return [item.pfm_subkeys count];
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(PFMProperty*)item {
    if (!item) {
        return [self.preferenceManifest.pfm_subkeys objectAtIndex:index];
    } else {
        return [item.pfm_subkeys objectAtIndex:index];
    }
}

#pragma mark - Content management

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(PFMProperty*)item {
    return [item valueForKey:tableColumn.identifier];
}

@end
