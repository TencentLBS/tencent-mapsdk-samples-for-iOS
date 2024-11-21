//
//  SnapShotViewController.m
//  QMapScenariosDemo
//
//  Created by halldwang on 2024/11/21.
//

#import "SnapShotViewController.h"


@interface SnapShotViewController ()

@property (nonatomic) UIImageView *shotView;

@end

@implementation SnapShotViewController

#pragma mark - Action

- (void)handleTestAction
{
  [self snapshot];
}

- (NSString *)testTitle
{
    return @"do snapshot";
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shotView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 400, 230, 150)];
    [self.view addSubview:self.shotView];
    self.shotView.layer.borderColor = [UIColor redColor].CGColor;
    self.shotView.layer.borderWidth = 2;
    self.shotView.backgroundColor = [UIColor magentaColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 50)];
    title.backgroundColor = [UIColor whiteColor];
    title.text = @"截图测试DEMO";
    [self.shotView addSubview:title];
}

#pragma mark - QMapViewDelegate

//- (void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture
//{
//
//}

#pragma mark - Snapshot

- (void)snapshot
{
    __weak __typeof(self) ws = self;
 
    [self.mapView takeSnapshotInRect:CGRectMake(0, 0, 230, 150) timeout:2 afterScreenUpdates:NO completion:^(UIImage *resultImage) {
        ws.shotView.image = resultImage;
    }];
}


@end
