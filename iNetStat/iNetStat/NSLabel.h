//
//  NSLabel.h
//  iNetStat
//
//  Created by user on 16/8/6.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSLabel : NSTextField

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) NSString *text;

@end
