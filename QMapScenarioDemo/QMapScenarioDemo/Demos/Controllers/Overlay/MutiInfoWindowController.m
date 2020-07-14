//
//  MutiInfoWindowController.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/5/21.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "MutiInfoWindowController.h"
#import "MutiInfoAnnotation.h"
#import "MutiInfoAnnotationView.h"

@interface MutiInfoWindowController ()

@end

@implementation MutiInfoWindowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAnnotation];
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.977457,116.312832)];
    [self.mapView setZoomLevel:10];
}

- (void)setupAnnotation {
    MutiInfoAnnotation *annotation1 = [[MutiInfoAnnotation alloc] init];
    MutiInfoAnnotation *annotation2 = [[MutiInfoAnnotation alloc] init];
    
    annotation1.coordinate = CLLocationCoordinate2DMake(39.928933,116.333045);
    annotation1.isImageInfoWindow = YES;
    annotation2.coordinate = CLLocationCoordinate2DMake(40.04049,116.273428);
    annotation2.title = @"腾讯北京总部大厦";
    annotation2.subtitle = @"海淀区西北旺东路10号院西区9号楼";

    [self.mapView addAnnotation:annotation1];
    [self.mapView addAnnotation:annotation2];
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation {
    static NSString *reuse = @"annotation";
    MutiInfoAnnotationView *annotationView = (MutiInfoAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuse];
    if (annotationView == nil) {
        annotationView = [[MutiInfoAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuse];
        annotationView.image = [UIImage imageNamed:@"redPin"];
        annotationView.isCanShowInfoWindow = YES;
    }
    
    return annotationView;
}


@end
