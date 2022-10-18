//
//  ShowMarkersViewController.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/1/13.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "ShowMarkersViewController.h"

@interface ShowMarkersViewController ()
@property (nonatomic, strong) NSMutableArray<QPointAnnotation *> *annotationArray;
@end

@implementation ShowMarkersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.889102,116.35787) animated:YES];
    [self.mapView setZoomLevel:15];
    [self setupNavigationItem];
    [self setupLocation];
}

- (void)setupNavigationItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"调整显示" style:UIBarButtonItemStyleDone target:self action:@selector(adjustMapRect)];
}

- (void)adjustMapRect {
    
    NSUInteger length = self.mapView.annotations.count;
    
    CLLocationCoordinate2D locations[length];
    for (int i = 0; i < length; i++) {
        QPointAnnotation *annotation = self.mapView.annotations[i];
        locations[i] = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude);
    }
    
    // 选定中心点
    CLLocationCoordinate2D centerLocation = CLLocationCoordinate2DMake(39.889102,116.35787);
    QCoordinateRegion region = QBoundingCoordinateRegionWithCoordinatesAndCenter(locations, length, centerLocation);
    
    [self.mapView setRegion:region edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
    
    // 默认选中中心点
    [self.mapView selectAnnotation:self.mapView.annotations.lastObject animated:YES];
}

- (void)setupLocation {
    
    int length = 14;
    
    CLLocationCoordinate2D locations[length];
    locations[0] = CLLocationCoordinate2DMake(39.90604,116.32168);
    locations[1] = CLLocationCoordinate2DMake(39.993098,116.336462);
    locations[2] = CLLocationCoordinate2DMake(39.8982,116.37509);
    locations[3] = CLLocationCoordinate2DMake(39.934059,116.451259);
    locations[4] = CLLocationCoordinate2DMake(39.954624,116.32296);
    locations[5] = CLLocationCoordinate2DMake(39.941474,116.416938);
    locations[6] = CLLocationCoordinate2DMake(39.947071,116.371438);
    locations[7] = CLLocationCoordinate2DMake(39.911171,116.411644);
    locations[8] = CLLocationCoordinate2DMake(39.975528,116.490346);
    locations[9] = CLLocationCoordinate2DMake(39.84636,116.37075);
    locations[10] = CLLocationCoordinate2DMake(39.889102,116.35787);
    locations[11] = CLLocationCoordinate2DMake(39.959084,116.288522);
    locations[12] = CLLocationCoordinate2DMake(39.884113,116.455896);
    locations[13] = CLLocationCoordinate2DMake(39.889102,116.35787);
    
    _annotationArray = [NSMutableArray arrayWithCapacity:length];
    for (int i = 0; i < length; i++) {
        QPointAnnotation *point = [[QPointAnnotation alloc] init];
        point.coordinate = locations[i];
        [_annotationArray addObject:point];
        
        if (i == length - 1) {
            point.title = @"中心点";
        }
    }
    
    [self.mapView addAnnotations:_annotationArray];
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation {
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        static NSString *identifier = @"pointAnnotation";
        
        QPinAnnotationView *annotationView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    return nil;
}

@end
