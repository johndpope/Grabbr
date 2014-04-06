//
//  MHTask.h
//  MusicHack
//
//  Created by Theo LUBERT on 4/6/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TaskCallback)(NSDictionary *);

@interface MHTask : NSTask
@property (nonatomic, copy) TaskCallback    callback;

+ (MHTask *)launchWithSelector:(TaskCallback)callback;

@end
