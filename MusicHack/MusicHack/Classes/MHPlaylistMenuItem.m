//
//  MHPlaylistMenuItem.m
//  Grabbr
//
//  Created by Theo LUBERT on 5/29/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHPlaylistMenuItem.h"

@implementation MHPlaylistMenuItem

+ (MHPlaylistMenuItem *)playlist:(NSDictionary *)data atIndex:(NSInteger)index {
    MHPlaylistMenuItem *item = (MHPlaylistMenuItem *)[MHNibLoader view:@"MHPlaylistMenuItemView"];
    if (item) {
        [item setPlaylist:data atIndex:index];
    }
    return item;
}

- (void)loadImage:(NSString *)url {
    NSURL *imageURL = [NSURL URLWithString:url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    NSImage *img = [[NSImage alloc] initWithData:imageData];
    
    [self.picture setImage:img];
    [self setNeedsDisplay:YES];
}

- (void)setPlaylist:(NSDictionary *)data atIndex:(NSInteger)index {
    [self performSelectorInBackground:@selector(loadImage:) withObject:data[@"picture"]];
    
    [self.titleLabel setStringValue:data[@"title"]];
    [self.detailsLabel setStringValue:[NSString stringWithFormat:@"%@ titles", data[@"nb_tracks"]]];
    
    if (index == 0) {
        [self.separator setHidden:YES];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect fullBounds = [self bounds];
    
    // Then do your drawing, for example...
    if ([[self enclosingMenuItem] isHighlighted]) {
        self.titleLabel.textColor = [NSColor whiteColor];
        self.detailsLabel.textColor = [[NSColor whiteColor] colorWithAlphaComponent:0.7];
        [[NSColor colorWithDeviceRed:(25.0/255.0)
                               green:(144.0/255.0)
                                blue:(219.0/255.0)
                               alpha:0.9] set];
    } else {
        self.titleLabel.textColor = [NSColor blackColor];
        self.detailsLabel.textColor = [NSColor grayColor];
    }
    NSRectFill( fullBounds );
}

@end
