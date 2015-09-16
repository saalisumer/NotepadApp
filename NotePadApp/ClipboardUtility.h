//
//  ClipboardUtility.h
//  NotePadApp
//
//  Created by SAALIS UMER on 08/09/15.
//  Copyright (c) 2015 SAALIS UMER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClipboardUtility : NSObject
+(void)copyText:(NSString*)text;
+(NSString*)getClipboardTest;
@end
