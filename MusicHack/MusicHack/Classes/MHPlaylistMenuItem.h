//
//  MHPlaylistMenuItem.h
//  Grabbr
//
//  Created by Theo LUBERT on 5/29/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MHNibLoader.h"
#import "MHMenuItem.h"

@interface MHPlaylistMenuItem : MHMenuItem

@property (nonatomic, strong) IBOutlet NSView       *separator;
@property (nonatomic, strong) IBOutlet NSImageView  *picture;
@property (nonatomic, strong) IBOutlet NSTextField  *titleLabel;
@property (nonatomic, strong) IBOutlet NSTextField  *detailsLabel;

- (void)setPlaylist:(NSDictionary *)data atIndex:(NSInteger)index;

+ (MHPlaylistMenuItem *)playlist:(NSDictionary *)data atIndex:(NSInteger)index;

@end
