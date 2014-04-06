//
//  MHListener.h
//  MusicHack
//
//  Created by Theo LUBERT on 4/5/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TaskCallback)(NSString *);

@interface MHListener : NSObject

+ (MHListener *)launchWithSelector:(TaskCallback)callback;

@end
