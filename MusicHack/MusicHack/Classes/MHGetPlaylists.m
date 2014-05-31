//
//  MHGetPlaylists.m
//  Grabbr
//
//  Created by Theo LUBERT on 4/6/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHGetPlaylists.h"

@implementation MHGetPlaylists

+ (MHTask *)launchWithSelector:(TaskCallback)callback {
    MHTask *task = [[MHGetPlaylists alloc] init];
    [task setCallback:callback];
    [task launch];
    return task;
}

- (NSTask *)createTask {
    NSTask *t = [NSTask new];
    [t setCurrentDirectoryPath:@"~/.music_hack"];
    [t setLaunchPath:@"/usr/bin/python"];
    [t setArguments:@[ @"playlists.py", @"get" ]];
    return t;
}

@end
