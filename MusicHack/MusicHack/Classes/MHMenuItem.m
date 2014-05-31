//
//  MHMenuItem.m
//  Grabbr
//
//  Created by Theo LUBERT on 5/30/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHMenuItem.h"

@implementation MHMenuItem

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect fullBounds = [self bounds];
    
    // Then do your drawing, for example...
    [[NSColor colorWithDeviceRed:(248.0/255.0)
                           green:(248.0/255.0)
                            blue:(248.0/255.0)
                           alpha:0.9] set];
    NSRectFill( fullBounds );
}

@end
