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
    task.artist = [task removeParentethis:artist];
    task.song = [task removeParentethis:song];
    
    NSLog(@"%@ - %@", task.artist, task.song);
    
    [task launch];
    return task;
}

- (NSString *)removeParentethis:(NSString *)str {
    NSInteger removing = 0;
    NSMutableString *output = [@"" mutableCopy];
    for (NSInteger i=0, k=str.length; i<k; i++) {
        char c = [str characterAtIndex:i];
        if (c == '(') {
            removing++;
        } else if (c == ')') {
            removing--;
        } else if (removing == 0) {
            [output appendFormat:@"%c", c];
        }
    }
    return output;
}

- (NSTask *)createTask {
    NSTask *t = [NSTask new];
    [t setCurrentDirectoryPath:@"~/.music_hack"];
    [t setLaunchPath:@"/usr/bin/python"];
    [t setArguments:@[ @"search.py", self.artist, self.song ]];
    return t;
}

@end
