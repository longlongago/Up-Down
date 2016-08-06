//
//  Panel.h
//  iNetStat
//
//  Created by haven on 16/6/19.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PanelDataSource <NSObject>

-(NSString*) getWanIP;
-(NSDictionary*) getIPInfo;

-(NSString*) dumpInfo;

@end

@interface Panel : NSPanel

//@property (nonatomic, strong) NSTableView* tableView;
@property (nonatomic, weak)id<PanelDataSource> dataSource;

-(id)init:(id<PanelDataSource>)dataSource;
-(void)setWindowDelegate:(id<NSWindowDelegate>)delegate;
-(void)updateData;
@end
