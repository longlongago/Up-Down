//
//  AppDelegate.m
//  iNetStat
//
//  Created by user on 16/6/8.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import "AppDelegate.h"
#import "AutoLaunchHelper.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:72];
    self.menu = [[NSMenu alloc ]init];
    self.autoLaunchMenu = [[NSMenuItem alloc]init];
    [self.autoLaunchMenu setTitle:@"Launch when login"];
    [self.autoLaunchMenu setState:[AutoLaunchHelper isLaunchWhenLogin]?1:0];
    [self.autoLaunchMenu setAction:@selector(menuItemAutoLaunchClick)];
    [self.menu addItem:self.autoLaunchMenu];
    [self.menu addItem:[NSMenuItem separatorItem]];
    [self.menu addItemWithTitle:@"About" action:@selector(menuItemAboutClick) keyEquivalent:@""];
    [self.menu addItemWithTitle:@"Quit" action:@selector(menuItemQuitClick) keyEquivalent:@"q"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void) menuItemAboutClick
{
    NSAlert *alert = [[NSAlert alloc]init];
    [alert setMessageText:@"About iNetStat"];
    [alert addButtonWithTitle:@"About me"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setInformativeText:@"A Mac OSX app to monitor net status!"];
    NSModalResponse resp = [alert runModal];
    switch (resp) {
        case NSAlertFirstButtonReturn:
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.ipandx.com/"]];
            break;
        case NSAlertSecondButtonReturn:
            
            break;
        default:
            break;
    }
}

-(void) menuItemQuitClick
{
    [NSApp terminate:nil];
}


-(void) menuItemAutoLaunchClick
{
    [NSApp terminate:nil];
}
@end
