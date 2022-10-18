//
//  ShowMarkerCenterController.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/5/15.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "ShowMarkerCenterController.h"

@interface ShowMarkerCenterController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) QPinAnnotationView *pinView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ShowMarkerCenterController

- (NSString *)testTitle {
    return @"调整";
}

- (void)handleTestAction {
    CGFloat h = self.mapView.bounds.size.height - self.tableView.frame.origin.y;
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, h, 0);
    CGPoint currentPos = [self.mapView convertCoordinate:_pinView.annotation.coordinate toPointToView:self.mapView];
    CGPoint newPos = CGPointMake(self.mapView.bounds.size.width/2, (self.mapView.bounds.size.height-edge.bottom)/2);
    CGPoint translation = CGPointMake(currentPos.x-newPos.x, currentPos.y-newPos.y);
    CGPoint oldCenter = self.mapView.center;
    CLLocationCoordinate2D newCenterCoordinate = [self.mapView convertPoint:CGPointMake(oldCenter.x+translation.x, oldCenter.y+translation.y) toCoordinateFromView:self.mapView];
    [self.mapView setCenterCoordinate:newCenterCoordinate animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.040219, 116.273348)];
    [self.mapView setZoomLevel:18];
    
    [self setupAnnotation];
    [self setupBottomView];
}

- (void)setupAnnotation {
    QPointAnnotation *annotation = [[QPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(40.040219, 116.273348);
    
    [self.mapView addAnnotation:annotation];
}

- (void)setupBottomView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mapView.frame.size.height - 150, self.mapView.frame.size.width, self.mapView.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.mapView addSubview:self.tableView];
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation {
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        static NSString *identifier = @"pointAnnotation";
        
        _pinView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (_pinView == nil) {
            _pinView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        return _pinView;
    }
    
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"数据第%li行", indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    
    if (offset.y > 0 && self.tableView.frame.origin.y > self.mapView.bounds.size.height * 0.5) {
        self.tableView.frame = CGRectMake(0, self.mapView.frame.size.height - 150 - offset.y, self.mapView.bounds.size.width, self.mapView.bounds.size.height);
    }
    else if (offset.y < 0 && self.tableView.frame.origin.y <= self.mapView.frame.size.height - 150) {
        self.tableView.frame = CGRectMake(0, self.tableView.frame.origin.y - offset.y, self.mapView.bounds.size.width, self.mapView.bounds.size.height);
    }
    
       [self handleTestAction];
}

@end
