//
//  PanelController.m
//  iNetStat
//
//  Created by haven on 16/6/19.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import "PanelController.h"


#define POPUP_HEIGHT 122
#define PANEL_WIDTH 280
#define ARROW_WIDTH 12
#define ARROW_HEIGHT 8
#define OPEN_DURATION .15
#define CLOSE_DURATION .1

@interface PanelController ()<NSWindowDelegate>

@end

@implementation PanelController

-(id)initWithDelegate:(id<PanelControllerDelegate>)delegate
{
    Panel* panel = [[Panel alloc]init];
    self = [super initWithWindow:panel];
    if (self) {
        self.delegate = delegate;
        self.panel = panel;
        [self.panel setDelegate:self];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


-(void)openPanelWithStatusView:(NSView*)statusView
{
    NSRect screenRect = [[NSScreen screens]objectAtIndex:0].frame;
    NSRect statusRect = NSZeroRect;
    if (statusView) {
        statusRect = [statusView.window convertRectToScreen:statusView.frame];
        statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
    }else{
        statusRect.size = NSMakeSize(40, [[NSStatusBar systemStatusBar] thickness]);
        statusRect.origin.x = roundf((NSWidth(screenRect) - NSWidth(statusRect)) / 2);
        statusRect.origin.y = NSHeight(screenRect) - NSHeight(statusRect) * 2;
    }
    
    NSRect panelRect = self.panel.frame;
    panelRect.size.width = PANEL_WIDTH;
    panelRect.size.height = POPUP_HEIGHT;
    panelRect.origin.x = roundf(NSMidX(statusRect) - NSWidth(panelRect) / 2);
    panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
    
    if (NSMaxX(panelRect) > (NSMaxX(screenRect) - ARROW_HEIGHT)) {
        panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - ARROW_HEIGHT);
    }
    [NSApp activateIgnoringOtherApps:NO];
    [self.panel setAlphaValue:0];
    [self.panel setFrame:panelRect display:YES];
    [self.panel makeKeyAndOrderFront:nil];
    
    NSTimeInterval openDuration = OPEN_DURATION;
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:openDuration];
    [[self.panel animator] setFrame:panelRect display:YES];
    [[self.panel animator] setAlphaValue:1];
    [NSAnimationContext endGrouping];
}

-(void)closePanel
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:CLOSE_DURATION];
    [[self.panel animator] setAlphaValue:0];
    [NSAnimationContext endGrouping];
    dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC*CLOSE_DURATION*2), dispatch_get_main_queue(), ^{
        [self.window orderOut:nil];
    });
}

#pragma mark - NSWindowDelegate
- (void)windowWillClose:(NSNotification *)notification
{
    
}

- (void)windowDidResignKey:(NSNotification *)notification
{
    
}

@end
