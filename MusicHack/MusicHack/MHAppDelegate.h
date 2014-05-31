//
//  MHAppDelegate.h
//  Grabbr
//
//  Created by Theo LUBERT on 4/5/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "MHAudio.hpp"
#import "MHListener.h"
#import "MHSearch.h"
#import "MHGetPlaylists.h"
#import "MHAddToPlaylist.h"

@interface MHAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) IBOutlet NSMenu       *statusMenu;
@property (nonatomic, strong) IBOutlet NSMenuItem   *title;
@property (nonatomic, strong) IBOutlet NSMenuItem   *playlistSection;
@property (nonatomic, strong) IBOutlet NSMenuItem   *count;
@property (nonatomic, strong) NSStatusItem          *statusItem;
@property (nonatomic, strong) NSTimer               *animationTimer;

@property (nonatomic, strong) MHAudio               *audio;

@property (nonatomic, strong) NSDictionary          *currentInfo;
@property (nonatomic, strong) NSArray               *playlists;
@property (nonatomic, strong) MHTask                *listenerTask;
@property (nonatomic, strong) MHTask                *getPlaylistTask;
@property (nonatomic, strong) MHTask                *addToPlaylistTask;
@property (nonatomic, strong) MHTask                *searchTask;

@property (nonatomic, assign) NSInteger             currentFrame;
@property (nonatomic, assign) NSInteger             totalFrames;

@end
