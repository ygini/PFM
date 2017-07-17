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

#import "PFMSettingsRepresentation.h"
#import "PFMSettingsItem.h"

@implementation PFMOutlineViewController

#pragma mark - NSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.outlineView.delegate = self;
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

- (void)loadRepresentedSettingsAccordingToManifestFile {
    self.representedSettings = [PFMSettingsRepresentation new];
    self.representedSettings.manifest = self.preferenceManifest;
    [self.representedSettings updateAccordingToMandatorySettings];
}

- (void)manifestSelectionIsDone {
    [self loadRepresentedSettingsAccordingToManifestFile];
    [self.outlineView reloadData];
}

- (void)manifestSelectionCancelled {
    [self.view.window close];
}

- (void)triggerActionPannelToSelectPreferenceManifest {
    
}

#pragma mark - Actions

- (IBAction)addPropertyToTheSameLevel:(id)sender {
    PFMSettingsItem *selectedItem = [self.outlineView itemAtRow:self.outlineView.selectedRow];
    PFMSettingsItem *parentItem = selectedItem.parent;
    
    PFMSettingsItem *newItem = [PFMSettingsItem new];
    
    if (parentItem) {
        [parentItem addChild:newItem];
    } else {
        [self.representedSettings addChild:newItem];
    }
    
    [self.outlineView reloadItem:parentItem reloadChildren:YES];
    [self.outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:[self.outlineView rowForItem:newItem]] byExtendingSelection:NO];
}

- (IBAction)addNestedProperty:(id)sender {
    PFMSettingsItem *selectedItem = [self.outlineView itemAtRow:self.outlineView.selectedRow];
    if (!selectedItem.isLeaf) {
        PFMSettingsItem *newItem = [PFMSettingsItem new];
        [selectedItem addChild:newItem];
        [self.outlineView reloadItem:selectedItem reloadChildren:YES];
        [self.outlineView expandItem:selectedItem];
        [self.outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:[self.outlineView rowForItem:newItem]] byExtendingSelection:NO];
    }
}

- (IBAction)removeSelectedProperties:(id)sender {
    PFMSettingsItem *selectedItem = [self.outlineView itemAtRow:self.outlineView.selectedRow];
    
    if (selectedItem.parent) {
        [selectedItem.parent removeChild:selectedItem];
        [self.outlineView reloadItem:selectedItem.parent reloadChildren:YES];
    } else {
        [self.representedSettings removeChild:selectedItem];
        [self.outlineView reloadItem:nil reloadChildren:YES];
    }
}

#pragma mark - NSOutlineView
#pragma mark Child management

-(BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(PFMSettingsItem*)item {
    switch (item.propertyManifest.pfm_type) {
        case PFMPreferencePropertyTypeDictionary:
        case PFMPreferencePropertyTypeArray:
            return YES;
            break;
            
        default:
            return NO;
            break;
    }
}

-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(PFMSettingsItem*)item {
    if (!item) {
        return [self.representedSettings.children count];
    } else {
        return [item.children count];
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(PFMSettingsItem*)item {
    if (!item) {
        return [self.representedSettings.children objectAtIndex:index];
    } else {
        return [item.children objectAtIndex:index];
    }
}

#pragma mark Content management

- (NSNumber*)numberRepresentationInOutlineViewForPropertyType:(PFMPreferencePropertyType)type {
    return [NSNumber numberWithInt:type-1];
}

- (PFMPreferencePropertyType)propertyTypeRepresentationInOutlineViewForNumber:(NSNumber*)number {
    return [number unsignedIntegerValue]+1;
}

-(id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(PFMSettingsItem*)item {
    if (item.propertyManifest) {
        if ([@"pfm_title" isEqualToString:tableColumn.identifier]) {
            return item.propertyManifest.pfm_title;
        } else if ([@"pfm_name" isEqualToString:tableColumn.identifier]) {
            return item.propertyManifest.pfm_name;
        } else if ([@"pfm_type" isEqualToString:tableColumn.identifier]) {
            return [self numberRepresentationInOutlineViewForPropertyType:item.propertyManifest.pfm_type];
        } else if ([@"user_value" isEqualToString:tableColumn.identifier]) {
            return item.value;
        }

    } else {
        if ([@"pfm_title" isEqualToString:tableColumn.identifier]) {
            return @"";
        } else if ([@"pfm_name" isEqualToString:tableColumn.identifier]) {
            return item.customKey;
        } else if ([@"pfm_type" isEqualToString:tableColumn.identifier]) {
            return [self numberRepresentationInOutlineViewForPropertyType:item.customType];
        } else if ([@"user_value" isEqualToString:tableColumn.identifier]) {
            return item.value;
        }

    }
    
    
    return @"COLUMN ID ERROR";
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(nullable NSTableColumn *)tableColumn item:(PFMSettingsItem*)item {
    if (!item.propertyManifest) {
        if ([@"pfm_title" isEqualToString:tableColumn.identifier]) {
            return YES;
        } else if ([@"pfm_name" isEqualToString:tableColumn.identifier]) {
            return YES;
        } else if ([@"pfm_type" isEqualToString:tableColumn.identifier]) {
            return YES;
        } else if ([@"user_value" isEqualToString:tableColumn.identifier]) {
            return YES;
        }
    } else {
        if ([@"pfm_title" isEqualToString:tableColumn.identifier]) {
            return NO;
        } else if ([@"pfm_name" isEqualToString:tableColumn.identifier]) {
            return NO;
        } else if ([@"pfm_type" isEqualToString:tableColumn.identifier]) {
            return NO;
        } else if ([@"user_value" isEqualToString:tableColumn.identifier]) {
            if (item.isLeaf) {
                return YES;
            } else {
                return NO;
            }
        }
    }
    return YES;
}

-(void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(PFMSettingsItem*)item {
    if ([@"pfm_title" isEqualToString:tableColumn.identifier]) {
        NSArray *availableChlidren = nil;
        
        if (item.parent) {
            availableChlidren = [item.parent availableChlidren];
        } else {
            availableChlidren = [self.representedSettings availableChlidren];
        }
        
        for (PFMPreferenceProperty *property in availableChlidren) {
            if ([[NSString stringWithFormat:@"%@ (%@)", property.pfm_title, property.pfm_name] isEqualToString:object]) {
                item.propertyManifest = property;
                break;
            }
        }
        
        [self.outlineView reloadItem:item];
        
        return ;

    } else if ([@"pfm_name" isEqualToString:tableColumn.identifier]) {
        item.customKey = object;
    } else if ([@"pfm_type" isEqualToString:tableColumn.identifier]) {
        item.customType = [self propertyTypeRepresentationInOutlineViewForNumber:object];
    } else if ([@"user_value" isEqualToString:tableColumn.identifier]) {
        item.value = object;
    }
}

#pragma mark - NSComboBoxCellDataSource

- (NSInteger)numberOfItemsInComboBoxCell:(NSComboBoxCell *)comboBoxCell {
    PFMSettingsItem *selectedItem = [self.outlineView itemAtRow:self.outlineView.selectedRow];
    if (selectedItem.parent) {
        return [[selectedItem.parent availableChlidren] count];
    } else {
        return [[self.representedSettings availableChlidren] count];
    }
}

- (id)comboBoxCell:(NSComboBoxCell *)comboBoxCell objectValueForItemAtIndex:(NSInteger)index {
//    NSInteger * columnIndex = [self.outlineView columnIndexesInRect:comboBoxCell];
    
    PFMSettingsItem *selectedItem = [self.outlineView itemAtRow:self.outlineView.selectedRow];
    PFMPreferenceProperty *property = nil;
    if (selectedItem.parent) {
        property = [[selectedItem.parent availableChlidren] objectAtIndex:index];
    } else {
        property = [[self.representedSettings availableChlidren] objectAtIndex:index];
    }
    
    return [NSString stringWithFormat:@"%@ (%@)", property.pfm_title, property.pfm_name];
}

//- (NSUInteger)comboBoxCell:(NSComboBoxCell *)comboBoxCell indexOfItemWithStringValue:(NSString *)string {
//    
//}

//- (nullable NSString *)comboBoxCell:(NSComboBoxCell *)comboBoxCell completedString:(NSString *)uncompletedString {
//    
//}


@end
