//
//  BSPDFView.m
//  Better Slides
//
//  Created by Jonathon Mah on 2007-05-16.
//  Copyright 2007 Playhaus. All rights reserved.
//  License information is contained in the 'LICENSE.txt' file.
//

#import "BSPDFView.h"
#import "BSPlugin.h"


@implementation BSPDFView

#pragma mark Simulating instance variables

// Work-around because instance variable declarations cannot be made in posed classes
// Based on code from <http://www.omnigroup.com/mailman/archive/macosx-dev/2004-December/054976.html>
+ (NSMapTable *)_BS_posedInstanceVariables
{
	static NSMapTable *posedInstanceVariables = NULL;
	if (!posedInstanceVariables)
		posedInstanceVariables = NSCreateMapTable(NSNonRetainedObjectMapKeyCallBacks,
												  NSObjectMapValueCallBacks,
												  16);
	return posedInstanceVariables;
}


- (NSMutableDictionary *)_BS_instanceVariables
{
	NSMutableDictionary *instanceVariables = NSMapGet([[self class] _BS_posedInstanceVariables], self);
	if (!instanceVariables)
	{
		instanceVariables = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
			[NSNumber numberWithBool:NO], @"isPresentation",
			[NSNumber numberWithBool:NO], @"isPresentationStateDiscovered",
			[NSNumber numberWithBool:NO], @"displayModeSetOnce",
			[NSNumber numberWithBool:NO], @"pageBreaksSetOnce",
			nil];
		NSMapInsert([[self class] _BS_posedInstanceVariables], self, instanceVariables);
	}
	return instanceVariables;
}



#pragma mark Memory management

- (void)dealloc
{
	NSMapRemove([[self class] _BS_posedInstanceVariables], self);
	
	[super dealloc];
}



#pragma mark Resizing the window once loaded

- (void)awakeFromNib
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(windowDidUpdate:)
												 name:NSWindowDidUpdateNotification
											   object:[self window]];
}


- (void)windowDidUpdate:(NSNotification *)notification
{
	// Unregister for the notification the first time it's received
#warning This depends on all superclasses not registering for this notification
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSWindowDidUpdateNotification
												  object:[self window]];
	if ([[[self _BS_instanceVariables] valueForKey:@"isPresentation"] boolValue])
	{
		[[self window] zoom:self];
		[[self window] zoom:self];
	}
}



#pragma mark Managing the display mode

- (void)setDisplayMode:(PDFDisplayMode)mode // PDFView
{
	[self _BS_discoverPresentationState];
	BOOL overridePresentationDisplay = NO;
	
	if (![[[self _BS_instanceVariables] valueForKey:@"displayModeSetOnce"] boolValue])
	{
		/*
		 * The display mode has never been set before. This call is probably
		 * occurring from the window controller's initializtion code. Let's
		 * override its choice of display mode and force it to single-page if
		 * this is a presentation document.
		 */
		overridePresentationDisplay = [[[self _BS_instanceVariables] valueForKey:@"isPresentation"] boolValue];
		[[self _BS_instanceVariables] setValue:[NSNumber numberWithBool:YES]
										forKey:@"displayModeSetOnce"];
	}
	
	if (overridePresentationDisplay)
	{
		[super setDisplayMode:kPDFDisplaySinglePage];
		[super setDisplaysPageBreaks:NO];
	}
	else
		[super setDisplayMode:mode];
}


- (void)setDisplaysPageBreaks:(BOOL)displayPageBreaks // PDFView
{
	[self _BS_discoverPresentationState];
	BOOL overridePresentationDisplay = NO;
	
	if (![[[self _BS_instanceVariables] valueForKey:@"pageBreaksSetOnce"] boolValue])
	{
		overridePresentationDisplay = [[[self _BS_instanceVariables] valueForKey:@"isPresentation"] boolValue];
		[[self _BS_instanceVariables] setValue:[NSNumber numberWithBool:YES]
										forKey:@"pageBreaksSetOnce"];
	}
	
	if (overridePresentationDisplay)
		[super setDisplaysPageBreaks:NO];
	else
		[super setDisplaysPageBreaks:displayPageBreaks];
}



#pragma mark Discovering if the document size matches a presentation

- (void)_BS_discoverPresentationState
{
	if (![[[self _BS_instanceVariables] valueForKey:@"isPresentationStateDiscovered"] boolValue])
	{
		[[self _BS_instanceVariables] setValue:[NSNumber numberWithBool:[self _BS_isPresentation]]
										forKey:@"isPresentation"];
		[[self _BS_instanceVariables] setValue:[NSNumber numberWithBool:YES]
										forKey:@"isPresentationStateDiscovered"];
	}
}


- (BOOL)_BS_isPresentation
{
	BOOL isPresentation = NO;
	PDFDocument *document = [self document];
	if (document && ([document pageCount] > 0))
	{
		NSRect firstPageRect = [[document pageAtIndex:0] boundsForBox:kPDFDisplayBoxMediaBox];
		float sizeRatio = NSWidth(firstPageRect) / NSHeight(firstPageRect);
		float ratioTolerance = [[[BSPlugin defaults] valueForKey:@"ratioTolerance"] floatValue];
		
		NSEnumerator *ratiosEnum = [[BSPlugin ratios] objectEnumerator];
		NSNumber *currRatio;
		while ((currRatio = [ratiosEnum nextObject]) && !isPresentation)
			if (fabs(sizeRatio - [currRatio floatValue]) <= ratioTolerance)
				isPresentation = YES;
	}
	return isPresentation;
}


@end
