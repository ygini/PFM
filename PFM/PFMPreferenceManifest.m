//
//  PFMDomain.m
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import "PFMPreferenceManifest.h"
#import "PFMConstants.h"
#import "PFMProperty.h"

@implementation PFMPreferenceManifest

- (instancetype)initWithContentOfFile:(NSString*)filePath {
    return [self initWithPreferencesManifest:[NSDictionary dictionaryWithContentsOfFile:filePath]];
}

- (instancetype)initWithContentOfURL:(NSURL*)fileURL {
    return [self initWithPreferencesManifest:[NSDictionary dictionaryWithContentsOfURL:fileURL]];
}

- (instancetype)initWithPreferencesManifest:(NSDictionary*)preferenceManifest
{
    self = [super init];
    if (self) {
        self.pfm_format_version = [preferenceManifest objectForKey:kPFMFormatVersion];
        
        if ([self.pfm_format_version floatValue] != 1.0) {
            return nil;
        }
        
        self.pfm_version = [preferenceManifest objectForKey:kPFMVersion];
        self.pfm_domain = [preferenceManifest objectForKey:kPFMDomain];
        self.pfm_title = [preferenceManifest objectForKey:kPFMTitle];
        
        self.pfm_description = [preferenceManifest objectForKey:kPFMDescription];
        
        NSMutableArray *nestedProperties = [NSMutableArray new];
        
        for (NSDictionary *nestedInformations in [preferenceManifest objectForKey:kPFMSubkeys]) {
            PFMProperty *nestedProperty = [[PFMProperty alloc] initWithInfos:nestedInformations];
            if (nestedProperty) {
                [nestedProperties addObject:nestedProperty];
            } else {
                // TODO: Manage property loading error
            }
        }
        
        self.pfm_subkeys = [NSArray arrayWithArray:nestedProperties];
    }
    return self;
}

-(NSString *)description {
    NSMutableString *description = [NSMutableString new];
    
    [description appendFormat:@"<PFMDomain domain:%@, version:%@, title:\"%@\", description:\"%@\", subkeys:\n", self.pfm_domain, self.pfm_version, self.pfm_title, self.pfm_description];
    for (PFMProperty *property  in self.pfm_subkeys) {
        [description appendString:[property stringForDescriptionOfLevel:1]];
        [description appendString:@"\n"];
    }
    [description appendFormat:@">"];

    return description;
}

@end
