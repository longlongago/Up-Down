//
//  Panel.h
//  iNetStat
//
//  Created by haven on 16/6/19.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Panel : NSPanel

@property (nonatomic, strong) NSTextField* text;
@property (nonatomic, strong) NSTableView* tableView;

-(id)init:(id<NSTableViewDataSource>)dataSource tabDelegate:(id<NSTableViewDelegate>)tabDelegate;
-(void)setWindowDelegate:(id<NSWindowDelegate>)delegate;
-(void)updateData;
@end
