//
//  Panel.m
//  iNetStat
//
//  Created by haven on 16/6/19.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import "Panel.h"

@implementation Panel

-(id)init
{
    self = [super initWithContentRect:NSMakeRect(0, 0, 280, 180) styleMask:NSUtilityWindowMask backing:NSBackingStoreBuffered defer:YES];
    if (self) {
        [self setAcceptsMouseMovedEvents:YES];
        [self setLevel:NSPopUpMenuWindowLevel];
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor redColor]];
        
        self.text = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 0, 200, 100)];
        self.text.placeholderString = @"something";
    }
    return self;
}

-(void)setWindowDelegate:(id<NSWindowDelegate>)delegate
{
    self.delegate = delegate;
}

- (BOOL) canBecomeKeyWindow;
{
    return YES;
}

@end
