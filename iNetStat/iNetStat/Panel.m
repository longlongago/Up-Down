//
//  Panel.m
//  iNetStat
//
//  Created by haven on 16/6/19.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import "Panel.h"

@implementation Panel

-(id)init:(id<NSTableViewDataSource>)dataSource tabDelegate:(id<NSTableViewDelegate>)tabDelegate
{
    self = [super initWithContentRect:NSMakeRect(0, 0, 280, 780) styleMask:NSUtilityWindowMask backing:NSBackingStoreBuffered defer:YES];
    if (self) {
        [self setAcceptsMouseMovedEvents:YES];
        [self setLevel:NSPopUpMenuWindowLevel];
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor redColor]];
        
//        self.text = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 0, 200, 100)];
//        self.text.placeholderString = @"something";
//        [self.contentView addSubview:self.text];
        self.tableView = [[NSTableView alloc]initWithFrame:NSZeroRect];
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"id"];
        [self.tableView addTableColumn:column];
        //self.tableView.contentm
        [self.contentView addSubview:self.tableView];
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:0]];
        [self.tableView setDataSource:dataSource];
        [self.tableView setDelegate:tabDelegate];
        self.tableView.backgroundColor = [NSColor lightGrayColor];
    }
    return self;
}

-(void)setWindowDelegate:(id<NSWindowDelegate>)delegate
{
    self.delegate = delegate;
}

-(void)updateData
{
    [self.tableView reloadData];
}

- (BOOL) canBecomeKeyWindow;
{
    return YES;
}

@end
