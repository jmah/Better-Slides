//
//  BSPDFView.h
//  Better Slides
//
//  Created by Jonathon Mah on 2007-05-16.
//  Copyright 2007 Playhaus. All rights reserved.
//  License information is contained in the 'LICENSE.txt' file.
//

#import <Cocoa/Cocoa.h>
#import "PVPDFView.h"


@interface BSPDFView : PVPDFView
{
}


#pragma mark Discovering if the document size matches a presentation
- (void)_BS_discoverPresentationState;
- (BOOL)_BS_isPresentation;

@end
