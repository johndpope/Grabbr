//
//  MHCountItem.m
//  Grabbr
//
//  Created by Theo LUBERT on 5/29/14.
//  Copyright (c) 2014 Theo Lubert. All rights reserved.
//

#import "MHCountItem.h"

@implementation MHCountItem

+ (MHCountItem *)count:(NSInteger)count {
    MHCountItem *item = (MHCountItem *)[MHNibLoader view:@"MHCountItemView"];
    if (item) {
        [item.textLabel setStringValue:[NSString stringWithFormat:@"%ld playlists", count]];
    }
    return item;
}

@end
