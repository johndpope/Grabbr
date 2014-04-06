//
//  MHListener.m
//  MusicHack
//
//  Created by Theo LUBERT on 4/5/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHListener.h"

@interface MHListener ()

@property (nonatomic, strong) NSTask        *task;
@property (nonatomic, strong) NSString      *output;
@property (nonatomic, copy) TaskCallback    callback;

@end

@implementation MHListener

+ (MHListener *)launchWithSelector:(TaskCallback)callback {
    MHListener *task = [[MHListener alloc] init];
    [task setCallback:callback];
    [task launch];
    return task;
}

- (void)launch {
//    NSTask *task = [[NSTask alloc] init];
//    [task setCurrentDirectoryPath:@"~/.music_hack"];
//    [task setLaunchPath:@"/usr/bin/python"];
//    [task setArguments:@[ @"listener.py" ]];
//    [task setLaunchPath:@"/bin/ls"];
//    [task setCurrentDirectoryPath:@"/"];
    
//    NSPipe *outputPipe = [NSPipe pipe];
//    [task setStandardOutput:outputPipe];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readCompleted:) name:NSFileHandleReadToEndOfFileCompletionNotification object:[outputPipe fileHandleForReading]];
//    [[outputPipe fileHandleForReading] readToEndOfFileInBackgroundAndNotify];
//    
//    [task launch];
    
    NSPipe *outPipe = [NSPipe new]; // pipe for shell output
    self.output = @"";
    
    self.task = [NSTask new];
    [self.task setCurrentDirectoryPath:@"~/.music_hack"];
    [self.task setLaunchPath:@"/usr/bin/python"];
    [self.task setArguments:@[ @"listener.py" ]];
    
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
//         NSLog(@"output: '%@'", outStr);
         
         // Continue waiting for shell output.
         if (outStr.length > 0) {
             self.output = [self.output stringByAppendingString:outStr];
             [[outPipe fileHandleForReading] waitForDataInBackgroundAndNotify];
         } else {
             [self.task terminate];
             self.callback(self.output);
         }
     }];
    
//    [task waitUntilExit];
}

- (void)dealloc {
    [self.task terminate];
}

- (void)readCompleted:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleReadToEndOfFileCompletionNotification object:[notification object]];
    
    NSFileHandle * read = [notification object];
    NSData * dataRead = [read readDataToEndOfFile];
    NSString * stringRead = [[NSString alloc] initWithData:dataRead encoding:NSUTF8StringEncoding];
    NSLog(@"output: %@", stringRead);
//    NSLog(@"output: %@", [[notification userInfo] NSFileHandleNotificationDataItem]);
    
    self.callback(@"");//[[notification userInfo] NSFileHandleNotificationDataItem]);
}

@end
