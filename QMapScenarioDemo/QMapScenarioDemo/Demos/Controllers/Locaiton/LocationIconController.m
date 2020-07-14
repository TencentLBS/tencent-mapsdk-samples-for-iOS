//
//  LocationController.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/5/12.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "LocationIconController.h"

@interface LocationIconController ()
@property (nonatomic, assign) BOOL isLoaded;
@end

@implementation LocationIconController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // iOS SDK的定位图标，默认跟随手机的方向而转动
    [self.mapView setShowsUserLocation:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"调整中心" style:UIBarButtonItemStyleDone target:self action:@selector(setupMapCenter)];
}

- (void)setupMapCenter {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate];
}

- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation fromHeading:(BOOL)fromHeading {
    if (_isLoaded == NO) {
        [self.mapView setCenterCoordinate:userLocation.location.coordinate];
        _isLoaded = YES;
    }
}


@end
