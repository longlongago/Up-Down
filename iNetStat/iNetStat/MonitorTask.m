//
//  MonitorTask.m
//  iNetStat
//
//  Created by user on 16/6/11.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import "MonitorTask.h"

@implementation MonitorTask

-(id)initWithStatusItemView:(StatusItemView*)statusItemView
{
    if (self = [super init]) {
        self.statusItemView = statusItemView;
    }
    return self;
}

-(void) start
{
    [[[NSThread alloc]initWithTarget:self selector:@selector(startUpdateTimer) object:nil] start];
}

-(void) startUpdateTimer
{
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateRateData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}

-(void) updateRateData
{
    NSTask* task = [[NSTask alloc]init];
    task.launchPath = @"/usr/bin/sar";
    task.arguments = @[@"-n", @"DEV", @"1"];
    
    NSPipe* pipe = [[NSPipe alloc]init];
    task.standardOutput = pipe;
    
    [task launch];
    [task waitUntilExit];
    
    int status = task.terminationStatus;
    if (status == 0) {
        NSData* data = [pipe.fileHandleForReading readDataToEndOfFile];
        NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSRange range = [string rangeOfString:@"Aver"];
        if (range.length > 0) {
            string = [string substringFromIndex: range.location];
            [self handleString:string];
        }
    }
    else
    {
        NSLog(@"task failed");
    }
}

/*
 22:42:12    IFACE    Ipkts/s      Ibytes/s     Opkts/s      Obytes/s
 
 22:42:13    lo0            0             0           0             0
 22:42:13    gif0           0             0           0             0
 22:42:13    stf0           0             0           0             0
 22:42:13    en0            9          1699           3           321
 22:42:13    en1            0             0           0             0
 22:42:13    en2            0             0           0             0
 22:42:13    p2p0           0             0           0             0
 22:42:13    awdl0          0             0           0             0
 22:42:13    bridge0        0             0           0             0
 Average:   lo0            0             0           0             0
 Average:   gif0           0             0           0             0
 Average:   stf0           0             0           0             0
 Average:   en0            9          1699           3           321
 Average:   en1            0             0           0             0
 Average:   en2            0             0           0             0
 Average:   p2p0           0             0           0             0
 Average:   awdl0          0             0           0             0
 Average:   bridge0        0             0           0             0
 */
-(void) handleString:(NSString*)string
{
    NSString* patten = @"en\\w+\\s+(\\d+)\\s+(\\d+)\\s+(\\d+)\\s+(\\d+)";
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:patten options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray* results = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    float upRate = 0.0;
    float downRate = 0.0;
    for (id r in results) {
        NSString* str = [string substringWithRange:[r range]];
        upRate += [[string substringWithRange:[r rangeAtIndex:2]] floatValue];
        downRate += [[string substringWithRange:[r rangeAtIndex:4]] floatValue];
        
    }
    [self.statusItemView setRateDataWithUp:upRate down:downRate];
}

@end
