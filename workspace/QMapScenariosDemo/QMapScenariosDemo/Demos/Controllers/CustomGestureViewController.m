//
//  CustomGestureViewController.m
//  QMapScenarioDemo
//
//  Created by Zhang Tian on 2019/9/23.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "CustomGestureViewController.h"

@interface CustomGestureViewController () <UIGestureRecognizerDelegate>

@end

@implementation CustomGestureViewController

#pragma mark - Override

- (NSString *)testTitle
{
    return @"清除标记";
}

- (void)handleTestAction
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}

#pragma mark - Helper

-(void)addAnnotation:(CLLocationCoordinate2D)coordinate
{
    QPointAnnotation *annotation = [[QPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    
    [self.mapView addAnnotation:annotation];
}

#pragma mark - Action

-(void)handleLongPressAction:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gestureRecognizer locationInView:self.mapView];
        
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        [self addAnnotation:coordinate];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - QMapViewDelegate

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QAnnotationView *annotationView = (QAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        UIImage *image = [UIImage imageNamed:@"marker"];
        
        annotationView.image = image;
        annotationView.centerOffset = CGPointMake(0, -image.size.height / 2.0);
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Setup

- (void)setupLongPressGesture
{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressAction:)];
    longPressGestureRecognizer.delegate = self;
    
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLongPressGesture];
}

@end
