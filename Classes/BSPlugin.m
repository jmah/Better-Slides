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


@implementation BSPlugin

+ (void)install
{
	[BSPDFView poseAsClass:[PVPDFView class]];
}

@end
