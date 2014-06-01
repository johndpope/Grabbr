//
//  MHAppDelegate.m
//  Grabbr
//
//  Created by Theo LUBERT on 4/5/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHAppDelegate.h"
#import "MHPlaylistMenuItem.h"
#import "MHAddToPlaylistItem.h"
#import "MHSeparatorItem.h"
#import "MHCountItem.h"
#import "MHSongItem.h"

@implementation MHAppDelegate

- (id)init {
    self.currentFrame = 0;
    self.totalFrames = 8;
    self.animationTimer = nil;
    self.listenerTask = nil;
    self.audio = [[MHAudio alloc] init];
    self.playlists = @[];
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
    
    [self.audio initConnections];
    
    [self buildMenu];
    [self getPlaylist];
    [self listen:self];
}

- (void)buildMenu {
    for (NSMenuItem *item in self.statusMenu.itemArray) {
        if ([item isSeparatorItem]) {
            [item setView:[MHSeparatorItem separator]];
        }
    }
    
    [self.title setView:[MHSongItem song:nil]];
    [self.playlistSection setView:[MHAddToPlaylistItem addTo:@"Deezer"]];
    for (NSInteger i=0, k=self.playlists.count; i<k; i++) {
        NSDictionary *playlist = self.playlists[i];
        NSInteger index = [self.statusMenu.itemArray indexOfObject:self.playlistSection] + 1;
        NSString *title = [NSString stringWithFormat:@"   %@", playlist[@"title"]];
        NSMenuItem *item = [self.statusMenu insertItemWithTitle:title action:@selector(addToPlaylist:) keyEquivalent:@"" atIndex:index];
        [item setView: [MHPlaylistMenuItem playlist:playlist atIndex:i]];
        [item setTarget:self];
        [item setTag:[playlist[@"id"] integerValue]];
    }
    self.count.title = [NSString stringWithFormat:@"   (%ld playlists)", self.playlists.count];
    [self.count setView:[MHCountItem count:self.playlists.count]];
}

- (void)getPlaylist {
    NSLog(@"Get playlists");
    if (self.getPlaylistTask == nil) {
        self.getPlaylistTask = [MHGetPlaylists launchWithSelector:^(NSDictionary *data) {
            self.playlists = [data[@"array"] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *p1, NSDictionary *p2) {
                return [(NSString *)p2[@"title"] compare:p1[@"title"]];
            }];
            [self buildMenu];
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
                [self notification:@"Grabbr"
                              text:[NSString stringWithFormat:@"'%@ - %@' has been added to your playlist", self.currentInfo[@"artist"][@"name"], self.currentInfo[@"song"][@"title"]]];
            }
            self.addToPlaylistTask = nil;
        } identifier:[p[@"id"] stringValue] artist:self.currentInfo[@"artist"][@"name"] song:self.currentInfo[@"song"][@"title"]];
    }
}

- (void)search:(NSDictionary *)song {
    self.searchTask = [MHSearch launchWithSelector:^(NSDictionary *searchResult) {
        NSLog(@"Search: %@", searchResult);
        
        if (![self.currentInfo[@"song"][@"id"] isEqualToString:song[@"song"][@"id"]]
            && (![self.currentInfo[@"song"][@"title"] isEqualToString:song[@"song"][@"title"]]
                || ![self.currentInfo[@"artist"][@"name"] isEqualToString:song[@"artist"][@"name"]])) {
            NSLog(@"Send notification");
            self.currentInfo = song;
            if (searchResult[@"title"]) {
                [(MHSongItem *)self.title.view setSong:searchResult];
                [self notification:searchResult[@"artist"][@"name"]
                              text:searchResult[@"title"]];
            } else {
                [(MHSongItem *)self.title.view setSong:self.currentInfo];
                [self notification:self.currentInfo[@"artist"][@"name"]
                              text:self.currentInfo[@"song"][@"title"]];
            }
        }
        
        [self stopAnimatingStatusBarIcon];
        [self performSelector:@selector(listen:) withObject:nil afterDelay:5];
    } artist:song[@"artist"][@"name"] song:song[@"song"][@"title"]];
}

- (IBAction)listen:(id)sender {
    if (self.listenerTask == nil) {
        if (sender) {
            self.title.title = @"   Listening...";
        }
        [self startAnimatingStatusBarIcon];
        NSLog(@"Start listening");
        self.listenerTask = [MHListener launchWithSelector:^(NSDictionary *data) {
            NSLog(@"Stopped listening: %@", data);
            if (data[@"song"][@"id"]) {
                [self search:data];
            } else {
                [self performSelector:@selector(listen:) withObject:nil afterDelay:0];
            }
            
            self.listenerTask = nil;
        }];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    [self.audio cleanupOnBeforeQuit];
    return YES;
}

- (IBAction)doQuit {
    [NSApp terminate:nil];
}

@end
