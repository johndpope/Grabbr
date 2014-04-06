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
    
    [self getPlaylist];
    [self listen:self];
}

- (void)getPlaylist {
    NSLog(@"Get playlists");
    if (self.getPlaylistTask == nil) {
        self.getPlaylistTask = [MHGetPlaylists launchWithSelector:^(NSDictionary *data) {
            self.playlists = [data[@"array"] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *p1, NSDictionary *p2) {
                return [(NSString *)p2[@"title"] compare:p1[@"title"]];
            }];
            for (NSDictionary *playlist in self.playlists) {
                NSString *title = [NSString stringWithFormat:@"   %@", playlist[@"title"]];
                NSMenuItem *item = [self.statusMenu insertItemWithTitle:title action:@selector(addToPlaylist:) keyEquivalent:@"" atIndex:3];
                [item setTarget:self];
                [item setTag:[playlist[@"id"] integerValue]];
            }
            self.count.title = [NSString stringWithFormat:@"   (%ld playlists)", self.playlists.count];
            self.getPlaylistTask = nil;
        }];
    }
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


#pragma mark - Action methods

- (void)notification:(NSString *)title text:(NSString *)text {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = title;
    notification.informativeText = text;
    notification.soundName = nil;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (IBAction)addToPlaylist:(NSMenuItem *)sender {
    NSLog(@"Add to playlist (%ld)", sender.tag);
    if (self.addToPlaylistTask == nil && self.currentInfo != nil) {
        NSDictionary *p = [self.playlists filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDictionary *playlist, NSDictionary *bindings) {
            return [playlist[@"id"] isEqualToNumber:@(sender.tag)];
        }]].lastObject;
        self.addToPlaylistTask = [MHAddToPlaylist launchWithSelector:^(NSDictionary *data) {
            NSLog(@"ADD result: %@", data);
            if (data[@"error"] == nil) {
                [self notification:@"Music Hack"
                              text:[NSString stringWithFormat:@"'%@ - %@' has been added to your playlist", self.currentInfo[@"artist"][@"name"], self.currentInfo[@"song"][@"title"]]];
            }
            self.addToPlaylistTask = nil;
        } identifier:[p[@"id"] stringValue] artist:self.currentInfo[@"artist"][@"name"] song:self.currentInfo[@"song"][@"title"]];
    }
}

- (IBAction)listen:(id)sender {
    if (self.listenerTask == nil) {
        if (sender) {
            self.title.title = @"Listening...";
        }
        [self startAnimatingStatusBarIcon];
        self.listenerTask = [MHListener launchWithSelector:^(NSDictionary *data) {
            NSLog(@"Data: %@", data);
            if (![self.currentInfo[@"song"][@"id"] isEqualToString:data[@"song"][@"id"]]) {
                self.currentInfo = data;
                [self notification:self.currentInfo[@"artist"][@"name"]
                              text:self.currentInfo[@"song"][@"title"]];
            }
            self.title.title = self.currentInfo[@"song"] ? [NSString stringWithFormat:@"%@ - %@", self.currentInfo[@"artist"][@"name"], self.currentInfo[@"song"][@"title"]] : @"No match found";
            
            NSLog(@"Listening just finished");
            [self stopAnimatingStatusBarIcon];
            
            self.listenerTask = nil;
            [self performSelector:@selector(listen:) withObject:nil afterDelay:5];
        }];
    }
}

@end
