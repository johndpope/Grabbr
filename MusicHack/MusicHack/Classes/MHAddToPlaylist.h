//
//  MHAddToPlaylist.h
//  MusicHack
//
//  Created by Theo LUBERT on 4/6/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHTask.h"

@interface MHAddToPlaylist : MHTask

+ (MHTask *)launchWithSelector:(TaskCallback)callback
                    identifier:(NSString *)identifier
                        artist:(NSString *)artist
                          song:(NSString *)song;

@property (nonatomic, strong) NSString  *identifer;
@property (nonatomic, strong) NSString  *artist;
@property (nonatomic, strong) NSString  *song;

@end
