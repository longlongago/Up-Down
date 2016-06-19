//
//  Panel.h
//  iNetStat
//
//  Created by haven on 16/6/19.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Panel : NSPanel

@property (nonatomic, strong) NSTextField* text;

-(id)init;
-(void)setDelegate:(id<NSWindowDelegate>)delegate;
@end
