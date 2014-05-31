//
//  MHAddToPlaylistItemView.m
//  Grabbr
//
//  Created by Theo LUBERT on 5/29/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHAddToPlaylistItem.h"

@implementation MHAddToPlaylistItem

+ (MHAddToPlaylistItem *)addTo:(NSString *)service {
    MHAddToPlaylistItem *item = (MHAddToPlaylistItem *)[MHNibLoader view:@"MHAddToPlaylistItemView"];
    if (item) {
        [item.textLabel setStringValue:@"Add to a playlist"];
    }
    return item;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect fullBounds = [self bounds];
    
    // Then do your drawing, for example...
    [[NSColor blackColor] set];
    NSRectFill( fullBounds );
}

@end
