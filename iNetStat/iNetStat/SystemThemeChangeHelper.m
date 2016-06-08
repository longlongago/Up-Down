//
//  SystemThemeChangeHelper.m
//  iNetStat
//
//  Created by user on 16/6/8.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import "SystemThemeChangeHelper.h"

@implementation SystemThemeChangeHelper

+(BOOL) isCurrentDark
{
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults]persistentDomainForName:NSGlobalDomain];
    NSString* style = dict[@"AppleInterfaceStyle"];
    if ([style isKindOfClass:[NSString class]]) {
        return [style caseInsensitiveCompare:@"dark"] == NSOrderedSame;
    }
    return NO;
}


+(void) addResponseWithTarget:(id)aTarget selector:(SEL)aSelector
{
    [[NSDistributedNotificationCenter defaultCenter] addObserver:aTarget selector:aSelector name:@"AppleInterfaceThemeChangedNotification" object:nil];
}
@end
