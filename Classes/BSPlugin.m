//
//  BSPlugin.m
//  Better Slides
//
//  Created by Jonathon Mah on 2007-05-16.
//  Copyright 2007 Playhaus. All rights reserved.
//  License information is contained in the 'LICENSE.txt' file.
//

#import "BSPlugin.h"
#import "PVPDFView.h"
#import "BSPDFView.h"


static NSMutableDictionary *BSDefaults = nil;


@implementation BSPlugin

#pragma mark Installing the SIMBL plugin

+ (void)install
{
	[BSPDFView poseAsClass:[PVPDFView class]];
	[[NSNotificationCenter defaultCenter] addObserver:[self class]
											 selector:@selector(applicationWillTerminate:)
												 name:NSApplicationWillTerminateNotification
											   object:nil];
	
	NSString *registrationDefaultsPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"RegistrationDefaults" ofType:@"plist"];
	if (registrationDefaultsPath)
		BSDefaults = [[NSMutableDictionary alloc] initWithContentsOfFile:registrationDefaultsPath];
	else
		BSDefaults = [[NSMutableDictionary alloc] init];
	[BSDefaults addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] persistentDomainForName:[self bundleIdentifier]]];
}



#pragma mark Getting the bundle identifier

+ (NSString *)bundleIdentifier
{
	return [[NSBundle bundleForClass:[self class]] bundleIdentifier];
}



#pragma mark Managing defaults

+ (NSMutableDictionary *)defaults
{
	return BSDefaults;
}


+ (NSArray *)ratios
{
	NSArray *ratioStrings = [[self defaults] valueForKey:@"presentationRatios"];
	NSMutableArray *ratioNumbers = [NSMutableArray arrayWithCapacity:[ratioStrings count]];
	
	NSEnumerator *ratioStringsEnum = [ratioStrings objectEnumerator];
	NSString *ratioString;
	while ((ratioString = [ratioStringsEnum nextObject]))
	{
		float width, height;
		BOOL valid = YES;
		NSScanner *scanner = [NSScanner scannerWithString:ratioString];
		valid = valid && [scanner scanFloat:&width];
		valid = valid && [scanner scanString:@":" intoString:NULL];
		valid = valid && [scanner scanFloat:&height];
		
		if (valid)
			[ratioNumbers addObject:[NSNumber numberWithFloat:(width / height)]];
	}
	
	return ratioNumbers;
}



#pragma mark NSApplication notifications

+ (void)applicationWillTerminate:(NSNotification *)notification
{
	// Save defaults
	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[self bundleIdentifier]];
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[self defaults] forName:[self bundleIdentifier]];
}

@end
