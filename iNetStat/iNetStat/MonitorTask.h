//
//  MonitorTask.h
//  iNetStat
//
//  Created by user on 16/6/11.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusItemView.h"

@interface MonitorTask : NSObject
@property(nonatomic, strong) StatusItemView* statusItemView;

-(id)initWithStatusItemView:(StatusItemView*)statusItemView;

-(void) start;

//-(void) startUpdateTimer;

//-(void) updateRateData;

@end
