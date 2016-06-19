//
//  PanelController.h
//  iNetStat
//
//  Created by haven on 16/6/19.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Panel.h"

@class PanelController;
@class StatusItemView;

@protocol PanelControllerDelegate <NSObject>
@optional
- (StatusItemView *)statusItemViewForPanelController:(PanelController*) contorller;
@end

@interface PanelController : NSWindowController

@property (nonatomic, weak) id<PanelControllerDelegate> delegate;
@property (nonatomic, strong) Panel* panel;

-(void)openPanelWithStatusView:(NSView*)statusView;
-(void)closePanel;

@end
