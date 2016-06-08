//
//  StatusItemView.h
//  iNetStat
//
//  Created by user on 16/6/8.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusItemView : NSControl
@property(nonatomic, strong) NSStatusItem* statusItem;
@property(nonatomic, assign) BOOL darkModel;
@property(nonatomic, assign) BOOL mouseDown;
@property(nonatomic, assign) CGFloat fontSize;
@property(nonatomic, strong) NSColor* fontColor;
@end
