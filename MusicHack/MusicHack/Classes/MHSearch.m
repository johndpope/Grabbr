//
//  MHSearch.m
//  Grabbr
//
//  Created by Theo LUBERT on 5/30/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHSearch.h"

@implementation MHSearch

+ (MHTask *)launchWithSelector:(TaskCallback)callback {
    MHTask *task = [[MHSearch alloc] init];
    [task setCallback:callback];
    return task;
}

+ (MHTask *)launchWithSelector:(TaskCallback)callback
                        artist:(NSString *)artist
                          song:(NSString *)song {
    MHSearch *task = (MHSearch *)[MHSearch launchWithSelector:callback];
    task.artist = artist;
    task.song = song;
    
    [task launch];
    return task;
}

- (NSTask *)createTask {
    NSTask *t = [NSTask new];
    [t setCurrentDirectoryPath:@"~/.music_hack"];
    [t setLaunchPath:@"/usr/bin/python"];
    [t setArguments:@[ @"search.py", self.artist, self.song ]];
    return t;
}

@end
