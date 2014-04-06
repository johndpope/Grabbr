//
//  MHAudio.hpp
//  MusicHack
//
//  Created by Theo LUBERT on 4/6/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//
#ifndef __MHAudio_hpp__
#define __MHAudio_hpp__

#include <vector>
#import <Foundation/Foundation.h>
#include "AudioTee.hpp"

@interface MHAudio : NSObject {
    NSStatusItem *mSbItem;
    NSMenu *mMenu;
    AudioTee *mEngine;
}

- (void)initConnections;
- (void)cleanupOnBeforeQuit;
@end

struct Device {
    char mName[64];
    AudioDeviceID mID;
};

#endif