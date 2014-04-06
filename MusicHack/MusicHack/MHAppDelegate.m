//
//  MHAppDelegate.m
//  MusicHack
//
//  Created by Theo LUBERT on 4/5/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHAppDelegate.h"

@implementation MHAppDelegate

- (id)init {
    self.currentFrame = 0;
    self.totalFrames = 8;
    self.animationTimer = nil;
    self.listenerTask = nil;
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)awakeFromNib{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    [self.statusItem setMenu:self.statusMenu];
    [self.statusItem setTitle:@""];
    [self.statusItem setHighlightMode:YES];
    
    NSImage *image = [NSImage imageNamed:@"menuIcon"];
    [image setTemplate:YES];
    [self.statusItem setImage:image];
    
    [self listen:self];
}

- (void)updateStatusBarIcon:(NSTimer*)timer {
    NSImage* image = [NSImage imageNamed:[NSString stringWithFormat:@"menuIcon%ld", (self.currentFrame++ % self.totalFrames)]];
    [image setTemplate:YES];
    [self.statusItem setImage:image];
}

- (void)startAnimatingStatusBarIcon {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/16.0 target:self selector:@selector(updateStatusBarIcon:) userInfo:nil repeats:YES];
}

- (void)stopAnimatingStatusBarIcon {
    [self.animationTimer invalidate];
}

- (NSDictionary *)json:(NSString *)str {
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                                options:0 error:&error];
    if (!error && [object isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)object;
    }
    return @{};
}


#pragma mark - Action methods

- (IBAction)listen:(id)sender {
    if (self.listenerTask == nil) {
        [self stopAnimatingStatusBarIcon];
        if (sender) {
            self.title.title = @"Listening...";
        }
        self.listenerTask = [MHListener launchWithSelector:^(NSString *output) {
            NSDictionary *data = [self json:output];
            NSLog(@"Data: %@", data);
            self.title.title = data[@"song"] ? data[@"song"][@"title"] : @"No match found";
            
            NSLog(@"Listening just finished");
            [self startAnimatingStatusBarIcon];
            
            self.listenerTask = nil;
            [self performSelector:@selector(listen:) withObject:nil afterDelay:5];
        }];
    }
}

@end
