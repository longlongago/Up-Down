//
//  StatusItemView.m
//  iNetStat
//
//  Created by user on 16/6/8.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import "StatusItemView.h"
#import "SystemThemeChangeHelper.h"
#import "Define.h"

const static float KB = 1024;
const static float MB = KB*1024;
const static float GB = MB*1024;
const static float TB = GB*1024;

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
        self.upRate = @"- - KB/s";
        self.downRate = @"- - KB/s";
        self.menu = aMenu;
        self.menu.delegate=self;
        self.darkModel = [SystemThemeChangeHelper isCurrentDark];
        [SystemThemeChangeHelper addResponseWithTarget:self selector:@selector(changeModel)];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [self.statusItem drawStatusBarBackgroundInRect:dirtyRect withHighlight:self.mouseDown];
    self.fontColor = (self.darkModel || self.mouseDown)?[NSColor whiteColor]:[NSColor blackColor];
    
    NSDictionary* fontAttribute = @{NSFontAttributeName: [NSFont fontWithName: FONT_NAME size: self.fontSize ], NSForegroundColorAttributeName:self.fontColor};
    NSAttributedString* upRateString = [[NSAttributedString alloc] initWithString:[self.upRate stringByAppendingString:@" ↑"] attributes: fontAttribute];
    [upRateString drawAtPoint:NSMakePoint(self.bounds.size.width - upRateString.size.width -5, 10)];
    NSAttributedString* downRateString = [[NSAttributedString alloc] initWithString:[self.downRate stringByAppendingString:@" ↓"] attributes:fontAttribute];
    [downRateString drawAtPoint:NSMakePoint(self.bounds.size.width - downRateString.size.width - 5, 0)];
    
    // Drawing code here.
}

-(void) setRateDataWithUp:(float)up down:(float)down
{
    self.upRate = [self formatRateData:up];
    self.downRate = [self formatRateData:down];
    [self setNeedsDisplay];
}

- (void) changeModel
{
    self.darkModel = [SystemThemeChangeHelper isCurrentDark];
    [self setNeedsDisplay];
}

-(NSString*) formatRateData:(float)rate
{
    float result = 0.0;
    NSString* unit;
    if (rate < KB/100) {
        return @"0 KB/s";
    }else if (rate < MB) {
        result = rate/KB;
        unit = @" KB/s";
    }else if (rate < GB) {
        result = rate/MB;
        unit = @" MB/s";
    }else if (rate < TB) {
        result = rate/GB;
        unit = @" GB/s";
    }else {
        return @">1023 GB/s";
    }
    if (result < 100) {
        return [NSString stringWithFormat:@"%0.2f%@", result, unit];
    }else if (result < 999) {
        return [NSString stringWithFormat:@"%0.1f%@", result, unit];
    }else {
        return [NSString stringWithFormat:@"%0.0f%@", result, unit];
    }
}

- (void)menuWillOpen:(NSMenu *)menu
{
    self.mouseDown = YES;
    [self setNeedsDisplay];
}

- (void)menuDidClose:(NSMenu *)menu
{
    self.mouseDown = NO;
    [self setNeedsDisplay];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [NSApp sendAction:self.action to:self.target from:self];
}

@end
