//
//  PFMManifestProvider.m
//  PFM
//
//  Created by Yoann Gini on 16/07/2017.
//  Copyright © 2017 Yoann Gini. All rights reserved.
//

#import "PFMManifestProvider.h"

#import "PFMConstants.h"
#import "PFMPreferenceManifest.h"

@implementation PFMManifestProvider

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (void)reloadManifests {
    NSMutableDictionary *manifestsPerSourceAndDomain = [NSMutableDictionary new];
    NSMutableDictionary *globalManifestsPerSourceAndName = [NSMutableDictionary new];
    
    NSRegularExpression *appleFileNameRegex = [NSRegularExpression regularExpressionWithPattern:@".+ manifest.plist"
                                                                                        options:NSRegularExpressionCaseInsensitive
                                                                                          error:nil];
    
    for (NSDictionary *sourceInfo in [[NSUserDefaults standardUserDefaults] arrayForKey:kPFMManifestsSources]) {
        NSMutableDictionary *manfiests = [NSMutableDictionary new];
        NSMutableDictionary *globalManfiests = [NSMutableDictionary new];
        
        NSString *sourcePath = [sourceInfo objectForKey:kPFMManifestsSourcePath];
        
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:sourcePath];
        
        NSString *filePath = nil;
        while ((filePath = [enumerator nextObject]) != nil){
            NSString *fileName = [filePath lastPathComponent];
            
            
            if ([appleFileNameRegex numberOfMatchesInString:fileName
                                                    options:0
                                                      range:NSMakeRange(0, [fileName length])] == 1) {
                
                NSString *fullPath = [sourcePath stringByAppendingPathComponent:filePath];
                PFMPreferenceManifest *pfm = [[PFMPreferenceManifest alloc] initWithContentOfFile:fullPath];
                
                if ([pfm.pfm_domain length] > 0) {
                    [manfiests setObject:pfm
                                  forKey:pfm.pfm_domain];

                } else {
                    [globalManfiests setObject:pfm
                                  forKey:pfm.pfm_title];
                }
            }
        }

        
        [manifestsPerSourceAndDomain setObject:manfiests forKey:[sourceInfo objectForKey:kPFMManifestsSourceName]];
        [globalManifestsPerSourceAndName setObject:globalManfiests forKey:[sourceInfo objectForKey:kPFMManifestsSourceName]];
    }
    
    self.manifestsPerSourceAndDomain = [NSDictionary dictionaryWithDictionary:manifestsPerSourceAndDomain];
    self.globalManifestsPerSourceAndName = [NSDictionary dictionaryWithDictionary:globalManifestsPerSourceAndName];
}

@end
