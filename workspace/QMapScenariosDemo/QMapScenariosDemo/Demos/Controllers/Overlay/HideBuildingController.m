//
//  HideBuildingController.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/5/11.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "HideBuildingController.h"

@interface HideBuildingController ()
@property (nonatomic, strong) UILabel *hintLabel;
@end

@implementation HideBuildingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.zoomLevel = 18;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"归位" style:UIBarButtonItemStyleDone target:self action:@selector(resetMap)];
    
    _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    _hintLabel.numberOfLines = 0;
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.mapView addSubview:_hintLabel];
}

- (void)mapViewRegionChange:(QMapView *)mapView {
    _hintLabel.text = [NSString stringWithFormat:@"倾斜:%.2f, 旋转:%.2f, 缩放:%.2f\n当倾斜角度和旋转角度为0时，关闭3D楼块效果", mapView.overlooking, mapView.rotation, mapView.zoomLevel];
    
    if (mapView.overlooking == 0 && mapView.rotation == 0) {
        mapView.shows3DBuildings = NO;
    } else {
        mapView.shows3DBuildings = YES;
    }
}

- (void)resetMap {
    self.mapView.overlooking = 0;
    self.mapView.rotation = 0;
    self.mapView.zoomLevel = 18;
}

@end
