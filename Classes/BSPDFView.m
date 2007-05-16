//
//  BSPDFView.m
//  Better Slides
//
//  Created by Jonathon Mah on 2007-05-16.
//  Copyright 2007 Playhaus. All rights reserved.
//  License information is contained in the 'LICENSE.txt' file.
//

#import "BSPDFView.h"


@implementation BSPDFView


- (void)setDisplayMode:(PDFDisplayMode)mode
{
	[super setDisplayMode:mode];
	NSLog(@"Asked to set display mode to %d", mode);
}


@end
