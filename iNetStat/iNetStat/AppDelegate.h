//
//  AppDelegate.h
//  iNetStat
//
//  Created by user on 16/6/8.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusItemView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property(nonatomic, strong) NSStatusItem* statusItem;
@property(nonatomic, strong) NSMenu* menu;
@property(nonatomic, strong) NSMenuItem* autoLaunchMenu;
@property(nonatomic, strong) StatusItemView* statusItemView;

-(void) menuItemAboutClick;
-(void) menuItemQuitClick;
-(void) menuItemAutoLaunchClick;

@end

