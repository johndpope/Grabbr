//
//  MHAddToPlaylist.m
//  MusicHack
//
//  Created by Theo LUBERT on 4/6/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHAddToPlaylist.h"

@implementation MHAddToPlaylist

+ (MHTask *)launchWithSelector:(TaskCallback)callback {
    MHTask *task = [[MHAddToPlaylist alloc] init];
    [task setCallback:callback];
    return task;
}

+ (MHTask *)launchWithSelector:(TaskCallback)callback
                    identifier:(NSString *)identifier
                        artist:(NSString *)artist
                          song:(NSString *)song {
    MHAddToPlaylist *task = (MHAddToPlaylist *)[MHAddToPlaylist launchWithSelector:callback];
    task.identifer = identifier;
    task.artist = artist;
    task.song = song;
    
    [task launch];
    return task;
}

- (NSTask *)createTask {
    NSTask *t = [NSTask new];
    [t setCurrentDirectoryPath:@"~/.music_hack"];
    [t setLaunchPath:@"/usr/bin/python"];
    [t setArguments:@[ @"playlists.py", @"add", self.identifer, self.artist, self.song ]];
    return t;
}

@end
