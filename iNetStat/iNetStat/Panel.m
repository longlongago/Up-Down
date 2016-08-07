//
//  Panel.m
//  iNetStat
//
//  Created by haven on 16/6/19.
//  Copyright © 2016年 ipanda. All rights reserved.
//

#import "Panel.h"
#import "NSLabel.h"
#import <MapKit/MapKit.h>

@interface Panel()

@property (nonatomic, strong) NSLabel* textIP;

@end

@implementation Panel
{
    MKMapView* _mapView;
    NSLabel* _timeZone;
    NSLabel* _city;
    NSLabel* _zip_code;
    NSLabel* _country_name;
    NSLabel* _country_code;
    NSLabel* _region_code;
    NSLabel* _region_name;
    
    NSImageView* _country_flag;
}

-(id)init:(id<PanelDataSource>)dataSource
{
    self = [super initWithContentRect:NSMakeRect(0, 0, 0, 0) styleMask:NSUtilityWindowMask backing:NSBackingStoreBuffered defer:YES];
    if (self) {
        [self setAcceptsMouseMovedEvents:YES];
        [self setLevel:NSPopUpMenuWindowLevel];
        [self setOpaque:NO];
        //[self setBackgroundColor:[NSColor redColor]];
        
        self.dataSource = dataSource;
        
        self.textIP = [[NSLabel alloc]initWithFrame:NSMakeRect(0, 100, 200, 40)];
        [self.contentView addSubview:self.textIP];
        
        self->_mapView = [[MKMapView alloc]initWithFrame:NSMakeRect(0, 400, 280, 300)];
        self->_mapView.rotateEnabled = NO;
        [self.contentView addSubview:self->_mapView];
        
        
        self->_timeZone = [[NSLabel alloc]initWithFrame:NSMakeRect(0, 160, 280, 120)];
        [self.contentView addSubview:self->_timeZone];
        self->_city = [[NSLabel alloc]initWithFrame:NSMakeRect(0, 180, 280, 120)];
        [self.contentView addSubview:self->_city];
        self->_zip_code = [[NSLabel alloc]initWithFrame:NSMakeRect(0, 200, 280, 120)];
        [self.contentView addSubview:self->_zip_code];
        self->_country_code = [[NSLabel alloc]initWithFrame:NSMakeRect(0, 220, 280, 120)];
        [self.contentView addSubview:self->_country_code];
        self->_country_name = [[NSLabel alloc]initWithFrame:NSMakeRect(0, 240, 100, 120)];
        [self.contentView addSubview:self->_country_name];
        self->_country_flag = [[NSImageView alloc]initWithFrame:NSMakeRect(100, 240, 100, 100)];
        [self.contentView addSubview:self->_country_flag];
        self->_region_code = [[NSLabel alloc]initWithFrame:NSMakeRect(0, 260, 280, 120)];
        [self.contentView addSubview:self->_region_code];
        self->_region_name = [[NSLabel alloc]initWithFrame:NSMakeRect(0, 280, 280, 120)];
        [self.contentView addSubview:self->_region_name];
    }
    return self;
}

-(void)setWindowDelegate:(id<NSWindowDelegate>)delegate
{
    self.delegate = delegate;
}

-(void)updateData

{
//    [self.tableView reloadData];
    self.textIP.stringValue = [self.dataSource getWanIP];
    NSDictionary* dictInfo = [self.dataSource getIPInfo];
    self->_timeZone.stringValue     = [NSString stringWithFormat:@"%@", [dictInfo objectForKey:@"time_zone"]];
    self->_city.stringValue         = [NSString stringWithFormat:@"%@", [dictInfo objectForKey:@"city"]];
    self->_zip_code.stringValue     = [NSString stringWithFormat:@"%@", [dictInfo objectForKey:@"zip_code"]];
    self->_country_code.stringValue = [NSString stringWithFormat:@"%@", [dictInfo objectForKey:@"country_code"]];
    self->_country_name.stringValue = [NSString stringWithFormat:@"%@", [dictInfo objectForKey:@"country_name"]];
    self->_region_code.stringValue  = [NSString stringWithFormat:@"%@", [dictInfo objectForKey:@"region_code"]];
    self->_region_name.stringValue  = [NSString stringWithFormat:@"%@", [dictInfo objectForKey:@"region_name"]];
    
    NSString* strPath = [NSString stringWithFormat:@"country_flag/%@", self->_country_code.stringValue.uppercaseString];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:strPath ofType:@"png"];
    NSImage* img = [[NSImage alloc]initWithContentsOfFile:filePath];
    //img.size = CGSizeMake(24, 24);
    //img.backgroundColor = [NSColor redColor];
    //self->_country_flag = [NSImageView alloc]initWithImage
    self->_country_flag.image = img;// [NSImage imageNamed:filePath];
    CLLocationDegrees lati = [[NSString stringWithFormat:@"%@", [dictInfo objectForKey:@"latitude"]] doubleValue];
    CLLocationDegrees longti = [[NSString stringWithFormat:@"%@", [dictInfo objectForKey:@"longitude"]] doubleValue];
    [self updateMapWithLati:lati andLongti:longti];
}

-(void) updateMapWithLati:(CLLocationDegrees) myLatitude andLongti:(CLLocationDegrees) myLongitude
{
    // Create a coordinate structure for the location.
    CLLocationCoordinate2D ground = CLLocationCoordinate2DMake(myLatitude, myLongitude);
    
    // Create a coordinate structure for the point on the ground from which to view the location.
    CLLocationCoordinate2D eye = CLLocationCoordinate2DMake(myLatitude, myLongitude);
    
    // Ask Map Kit for a camera that looks at the location from an altitude of 100 meters above the eye coordinates.
    MKMapCamera *myCamera = [MKMapCamera cameraLookingAtCenterCoordinate:ground fromEyeCoordinate:eye eyeAltitude:80000];
    
    // Assign the camera to your map view.
    self->_mapView.camera = myCamera;
    
//    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(myLatitude, myLongitude);
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
//    region.span.latitudeDelta *=15.0;
//    region.span.latitudeDelta *=15.0;
//    [self->_mapView setRegion:region animated:YES];
}


- (BOOL) canBecomeKeyWindow;
{
    return YES;
}

@end
