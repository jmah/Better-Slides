//
//  BSPlugin.h
//  Better Slides
//
//  Created by Jonathon Mah on 2007-05-16.
//  Copyright 2007 Playhaus. All rights reserved.
//  License information is contained in the 'LICENSE.txt' file.
//

#import <Cocoa/Cocoa.h>


@interface BSPlugin : NSObject
{
}


#pragma mark Installing the SIMBL plugin
+ (void)install;

#pragma mark Getting the bundle identifier
+ (NSString *)bundleIdentifier;

#pragma mark Managing defaults
+ (NSMutableDictionary *)defaults;
+ (NSArray *)ratios;

@end
