//
//  MHNibLoader.m
//  Grabbr
//
//  Created by Theo LUBERT on 5/29/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHNibLoader.h"

@interface MHNibLoader ()

@end

@implementation MHNibLoader

+ (NSView *)view:(NSString *)nibName {
    MHNibLoader *loader = [[MHNibLoader alloc] initWithNibName:nibName bundle:nil];
    return loader.view;
}

@end
