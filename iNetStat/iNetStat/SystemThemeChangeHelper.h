//
//  SystemThemeChangeHelper.h
//  iNetStat
//
//  Created by user on 16/6/8.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemThemeChangeHelper : NSObject

+(BOOL) isCurrentDark;

+(void) addResponseWithTarget:(id)aTarget selector:(SEL)aSelector;

@end
