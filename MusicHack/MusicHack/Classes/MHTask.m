//
//  MHTask.m
//  MusicHack
//
//  Created by Theo LUBERT on 4/6/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHTask.h"

@interface MHTask ()

@property (nonatomic, strong) NSTask        *task;
@property (nonatomic, strong) NSString      *output;

@end

@implementation MHTask

+ (MHTask *)launchWithSelector:(TaskCallback)callback {
    [MHTask doesNotRecognizeSelector:@selector(launchWithSelector:)];
    return nil;
}

- (NSDictionary *)json:(NSString *)str {
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                                options:0 error:&error];
    if (error) {
        if (str && error.code == 3840) {
            return @{ @"raw": str };
        }
        return @{ @"error": error };
    } else if ([object isKindOfClass:[NSArray class]]) {
        return @{ @"array": object };
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)object;
    } else if (str) {
        return @{ @"raw": str };
    }
    return @{};
}

- (NSTask *)createTask {
    [self doesNotRecognizeSelector:@selector(createTask)];
    return nil;
}

- (void)launch {
    NSPipe *outPipe = [NSPipe new];
    self.output = @"";
    
    self.task = [self createTask];
    [self.task setStandardOutput:outPipe];
    [self.task launch];
    
    [[outPipe fileHandleForReading] waitForDataInBackgroundAndNotify];
    
    // Wait asynchronously for shell output.
    // The block is executed as soon as some data is available on the shell output pipe.
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification
                                                      object:[outPipe fileHandleForReading] queue:nil
                                                  usingBlock:^(NSNotification *note)
     {
         // Read from shell output
         NSData *outData = [[outPipe fileHandleForReading] availableData];
         NSString *outStr = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
         
         // Continue waiting for shell output.
         if (outStr.length > 0) {
             self.output = [self.output stringByAppendingString:outStr];
             [[outPipe fileHandleForReading] waitForDataInBackgroundAndNotify];
         } else {
             [self.task terminate];
             NSLog(@"output: '%@'", [self json:self.output]);
             self.callback([self json:self.output]);
         }
     }];
}

- (void)dealloc {
    [self.task terminate];
}

@end
