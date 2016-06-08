//
//  StatusItemView.m
//  iNetStat
//
//  Created by user on 16/6/8.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import "StatusItemView.h"
#import "SystemThemeChangeHelper.h"

@interface StatusItemView()<NSMenuDelegate>
{
    
}
@end

@implementation StatusItemView
- (id) initWithStatusItem:(NSStatusItem*) aStatusItme menu:(NSMenu*)aMenu
{
    if (self) {
        self = [super initWithFrame:NSMakeRect(0, 0, [aStatusItme length], 30)];
        self.fontSize = 9;
        self.fontColor = [NSColor blackColor];
        self.darkModel = NO;
        self.mouseDown = NO;
        self.statusItem = aStatusItme;
        self.menu = aMenu;
        self.menu.delegate=self;
        self.darkModel = [SystemThemeChangeHelper isCurrentDark];
        [SystemThemeChangeHelper addResponseWithTarget:self selector:@selector(changeModel)];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void) changeModel
{
    self.darkModel = [SystemThemeChangeHelper isCurrentDark];
    [self setNeedsDisplay];
}

@end
