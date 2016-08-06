//
//  PanelController.m
//  iNetStat
//
//  Created by haven on 16/6/19.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import "PanelController.h"


#define POPUP_HEIGHT 722
#define PANEL_WIDTH 280
#define ARROW_WIDTH 12
#define ARROW_HEIGHT 8
#define OPEN_DURATION .15
#define CLOSE_DURATION .1


@interface PanelController ()<NSWindowDelegate, PanelDataSource>
@property (nonatomic, assign)int index;
@property (nonatomic, strong)NSArray* echoSites;

@end

@implementation PanelController

-(id)initWithDelegate:(id<PanelControllerDelegate>)delegate
{
    Panel* panel = [[Panel alloc]init:self];
    self = [super initWithWindow:panel];
    if (self) {
        self.echoSites = @[@"https://api.ipify.org", @"https://icanhazip.com/", @"https://www.trackip.net/ip"];
        self.index = 2;
        self.delegate = delegate;
        self.panel = panel;
        [self.panel setWindowDelegate:self];
        [self updateWanIP];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)showWindow:(nullable id)sender
{
    [super showWindow:sender];
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
    [NSApp activateIgnoringOtherApps:YES];
    [self.panel setAlphaValue:0];
    [self.panel setFrame:panelRect display:YES];
    [self.panel makeKeyAndOrderFront:nil];
    [self.panel updateData];
    
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

-(void) updateWanIP
{
    if (self.index >= self.echoSites.count) {
        NSLog(@"no more echo site!");
        return;
    }
    NSString* site = (NSString*)[self.echoSites objectAtIndex:self.index];
    self.index++;
    NSURL* url = [NSURL URLWithString:site];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error){
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*)response;
            if (httpResp.statusCode == 200) {
                NSString* strIP = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
                NSLog(@"out wan ip:%@", strIP);
                self.wanIP = strIP;
                [self.panel updateData];
                [self updateIPInfo:self.wanIP];
            }
            else
            {
                [self updateWanIP];
            }
        }
    }];
    [task resume];
}

-(void) updateIPInfo:(NSString*)ip
{
    if (ip.length == 0) {
        NSLog(@"wrong ip");
        return;
    }
    NSString* site = [NSString stringWithFormat:@"https://ipanda-ip2geo-v1.p.mashape.com/json/%@", ip];
    NSURL* url = [NSURL URLWithString:site];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: url];
    [request setValue:@"ExLCG9onM2mshwKdAs0HaCUmIA8Ep1im0QLjsnVgDMn1w2xeXA" forHTTPHeaderField:@"X-Mashape-Key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error){
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse* httpResp = (NSHTTPURLResponse*)response;
            if (httpResp.statusCode == 200) {
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                self.ipInfo = [json copy];
                [self.panel updateData];
                NSLog(@"ip country_code:%@", [self.ipInfo objectForKey:@"country_code"]);
            }
            else
            {
                NSLog(@"request ip info error");
            }
        }
    }];
    [task resume];
}


#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSInteger count = 0;
    if (self.wanIP.length > 0) {
        count++;
    }
    count += self.ipInfo.count;
    return count;
}
//
//- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
//{
//    NSCell* cell = (NSCell*)[tableView makeViewWithIdentifier:@"id" owner:nil];
//    if (!cell) {
//        cell = [[NSCell alloc]initTextCell:@"aaa"];
//    }
//    switch (row) {
//        case 0:
//            cell.title = self.wanIP;
//            break;
//        case 1:
//            cell.title = [self.ipInfo objectForKey:@"country_code"];
//            
//        default:
//            break;
//    }
//    cell.stringValue = cell.title;
//    return cell;
//}
//
//- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
//{
//    NSTextFieldCell* c = (NSTextFieldCell*)cell;
//    [c setTitle:@"bbb"];
//    
//    switch (row) {
//        case 0:
//            c.title = self.wanIP;
//            break;
//        case 1:
//            c.title = [self.ipInfo objectForKey:@"country_code"];
//            
//        default:
//            break;
//    }
//}

#pragma mark - NSWindowDelegate
- (void)windowWillClose:(NSNotification *)notification
{
    [self closePanel];
}

- (void)windowDidResignKey:(NSNotification *)notification
{
    if ([self.panel isVisible]) {
        [self closePanel];
    }
}

#pragma mark - Keyboard

- (void)cancelOperation:(id)sender
{
    [self closePanel];
}


#pragma mark - PanelDataSource
-(NSString*) getWanIP
{
    return self.wanIP;
}

-(NSDictionary*) getIPInfo
{
    return [NSDictionary dictionaryWithDictionary:self.ipInfo];
}

-(NSString*) dumpInfo
{
    NSString* info = [NSString stringWithFormat:@"IP:%@", self.wanIP];
    NSDictionary* dic = [self getIPInfo];
    for (NSString* key in dic.allKeys) {
        info = [info stringByAppendingFormat:@";%@:%@", key, [dic objectForKey:key] ];
    }
    return info;
}
@end
