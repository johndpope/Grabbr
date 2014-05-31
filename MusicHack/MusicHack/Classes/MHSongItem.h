//
//  MHSongItem.h
//  Grabbr
//
//  Created by Theo LUBERT on 5/30/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MHNibLoader.h"
#import "MHMenuItem.h"

@interface MHSongItem : MHMenuItem

@property (nonatomic, strong) NSImage               *picture;

@property (nonatomic, strong) IBOutlet NSTextField  *titleLabel;
@property (nonatomic, strong) IBOutlet NSTextField  *artistLabel;

- (void)setSong:(NSDictionary *)song;

+ (MHSongItem *)song:(NSDictionary *)song;

@end
