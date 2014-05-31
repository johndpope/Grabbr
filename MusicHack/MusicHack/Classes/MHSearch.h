//
//  MHSearch.h
//  Grabbr
//
//  Created by Theo LUBERT on 5/30/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHTask.h"

@interface MHSearch : MHTask

+ (MHTask *)launchWithSelector:(TaskCallback)callback
                        artist:(NSString *)artist
                          song:(NSString *)song;

@property (nonatomic, strong) NSString  *artist;
@property (nonatomic, strong) NSString  *song;

@end
