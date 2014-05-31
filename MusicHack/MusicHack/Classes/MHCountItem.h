//
//  MHCountItem.h
//  Grabbr
//
//  Created by Theo LUBERT on 5/29/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MHNibLoader.h"
#import "MHMenuItem.h"

@interface MHCountItem : MHMenuItem

@property (nonatomic, strong) IBOutlet NSTextField  *textLabel;

+ (MHCountItem *)count:(NSInteger)count;

@end
