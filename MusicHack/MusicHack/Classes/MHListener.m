//
//  MHListener.m
//  Grabbr
//
//  Created by Theo LUBERT on 4/5/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHListener.h"

@implementation MHListener

+ (MHTask *)launchWithSelector:(TaskCallback)callback {
    MHTask *task = [[MHListener alloc] init];
    [task setCallback:callback];
    [task launch];
    return task;
}

- (NSTask *)createTask {
    NSTask *t = [NSTask new];
    [t setCurrentDirectoryPath:@"~/.music_hack"];
    [t setLaunchPath:@"/usr/bin/python"];
    [t setArguments:@[ @"listener.py" ]];
    return t;
}

@end
