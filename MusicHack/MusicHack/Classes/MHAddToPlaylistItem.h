//
//  MHAddToPlaylistItem.h
//  Grabbr
//
//  Created by Theo LUBERT on 5/29/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MHNibLoader.h"
#import "MHMenuItem.h"

@interface MHAddToPlaylistItem : MHMenuItem

@property (nonatomic, strong) IBOutlet NSTextField  *textLabel;

+ (MHAddToPlaylistItem *)addTo:(NSString *)service;

@end
