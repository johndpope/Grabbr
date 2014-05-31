//
//  MHSeparatorItem.m
//  Grabbr
//
//  Created by Theo LUBERT on 5/30/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHSeparatorItem.h"

@implementation MHSeparatorItem

+ (MHSeparatorItem *)separator {
    MHSeparatorItem *item = (MHSeparatorItem *)[MHNibLoader view:@"MHSeparatorItemView"];
    if (item) {
        // Do nothing
    }
    return item;
}

@end
