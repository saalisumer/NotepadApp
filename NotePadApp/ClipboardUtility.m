//
//  ClipboardUtility.m
//  NotePadApp
//
//  Created by SAALIS UMER on 08/09/15.
//  Copyright (c) 2015 SAALIS UMER. All rights reserved.
//

#import "ClipboardUtility.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation ClipboardUtility
+(void)copyText:(NSString*)text
{
    [[UIPasteboard generalPasteboard] setString:text];
}

+(NSString*)getClipboardTest
{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    return pb.string;
}
@end
