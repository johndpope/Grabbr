//
//  MHSongItem.m
//  Grabbr
//
//  Created by Theo LUBERT on 5/30/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHSongItem.h"

@implementation MHSongItem

+ (MHSongItem *)song:(NSDictionary *)song {
    MHSongItem *item = (MHSongItem *)[MHNibLoader view:@"MHSongItemView"];
    if (item) {
        [item setSong:song];
    }
    return item;
}

- (void)loadImage:(NSString *)url {
    if ([url rangeOfString:@"?"].location == NSNotFound) {
        url = [url stringByAppendingString:@"?size=big"];
    } else {
        url = [url stringByAppendingString:@"&size=big"];
    }
    
    NSURL *imageURL = [NSURL URLWithString:url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    
    self.picture = [[NSImage alloc] initWithData:imageData];
    [self.picture setFlipped:NO];
    [self setNeedsDisplay:YES];
}

- (void)setSong:(NSDictionary *)song {
    if (song[@"album"][@"cover"]) {
        [self performSelectorInBackground:@selector(loadImage:) withObject:song[@"album"][@"cover"]];
    } else {
        self.picture = nil;
    }
    if (song[@"title"]) {
        [self.titleLabel setStringValue:song[@"title"]];
    } else if (song[@"song"][@"title"]) {
            [self.titleLabel setStringValue:song[@"song"][@"title"]];
        } else {
        [self.titleLabel setStringValue:@""];
    }
    if (song[@"artist"][@"name"]) {
        [self.artistLabel setStringValue:song[@"artist"][@"name"]];
    } else {
        [self.artistLabel setStringValue:@""];
    }
    [self setNeedsDisplay:YES];
}

- (void)drawImage:(NSImage *)img inRect:(NSRect)rect {
    [img drawInRect:rect fromRect:(CGRect) {
        .origin = (CGPoint) {
            .x = 0,
            .y = (img.size.height / 2) - (60 * (img.size.width / 250))
        },
        .size = (CGSize) {
            .width = img.size.width,
            .height = 60 * (img.size.width / 250)
        }
    } operation:NSCompositeSourceOver fraction:1];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect fullBounds = [self bounds];
    fullBounds.size.height += 4;
    [[NSBezierPath bezierPathWithRect:fullBounds] setClip];
    
    NSImage *img = [NSImage imageNamed:@"cover.png"];
    if (self.picture) {
        img = self.picture;
    }
    [self drawImage:img inRect:(CGRect) {
        .origin = (CGPoint) {
            .x = 0,
            .y = 0
        },
        .size = (CGSize) {
            .width = 250,
            .height = 64
        }
    }];
    
    // Draw the shadow
    [[NSImage imageNamed:@"shadow.png"] drawInRect:(CGRect) {
        .origin = (CGPoint) {
            .x = 0,
            .y = 0
        },
        .size = (CGSize) {
            .width = 250,
            .height = 64
        }
    } fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

@end
