//
//  PickMapPointViewController.m
//  QMapScenarioDemo
//
//  Created by Zhang Tian on 2019/9/24.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "PickMapPointViewController.h"
#import <QMapKit/QMSSearchKit.h>

@interface PickMapPointViewController () <QMSSearchDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) QPointAnnotation *annotation;
@property (nonatomic, strong) QPinAnnotationView *pinView;
@property (nonatomic, assign) CLLocationCoordinate2D lastLocation;
@property (nonatomic, strong) QMSSearcher *mapSearcher;

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *searchResultTableView;
@property (nonatomic, strong) NSArray *searchResultArray;

@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation PickMapPointViewController

#pragma mark - Lazy Load
- (QMSSearcher *)mapSearcher {
    if (_mapSearcher == nil) {
        _mapSearcher = [[QMSSearcher alloc] initWithDelegate:self];
    }
    
    return _mapSearcher;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 344);
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.040219,116.273348)];
    [self.mapView setZoomLevel:15.0];
    
    [self setupPointAnnotation];
    [self searchCurrentLocationWithKeyword:@""];
    [self setupSearchView];
    [self setupKeyboardNotification];
}

- (void)setupPointAnnotation {
    _annotation = [[QPointAnnotation alloc] init];
    _annotation.coordinate = CLLocationCoordinate2DMake(40.040219,116.273348);
    
    [self.mapView addAnnotation:_annotation];
}

- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation {
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        static NSString *pinIndentifier = @"PinIndentifier";
        _pinView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinIndentifier];
        if (_pinView == nil) {
            _pinView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIndentifier];
        }
        
        return _pinView;
    }
    
    return nil;
}

- (void)mapView:(QMapView *)mapView regionWillChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture {
    [self.view endEditing:YES];
}

- (void)mapViewRegionChange:(QMapView *)mapView {
    // 更新位置
    _annotation.coordinate = mapView.centerCoordinate;
}

// 请求当前位置的地标
- (void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture {
    if (bGesture == YES) {
        _searchBar.text = @"";
        
        // 判断与上次坐标是否相同
        CLLocationCoordinate2D centerCoord = mapView.centerCoordinate;
        
        if (_lastLocation.latitude == centerCoord.latitude && _lastLocation.longitude == centerCoord.longitude) {
            return;
        }
        
        // 请求当前地点
        [self searchCurrentLocationWithKeyword:@""];
    }
    
    _annotation.coordinate = mapView.centerCoordinate;
}

- (void)searchCurrentLocationWithKeyword:(NSString *)keyword {
    CLLocationCoordinate2D centerCoord = self.mapView.centerCoordinate;
    
    QMSPoiSearchOption *option = [[QMSPoiSearchOption alloc] init];
    if (keyword.length > 0) {
        option.keyword = keyword;
    }
    option.boundary = [NSString stringWithFormat:@"nearby(%f,%f,2000,1)", centerCoord.latitude, centerCoord.longitude];
    
    [self.mapSearcher searchWithPoiSearchOption:option];
}

- (void)searchWithPoiSearchOption:(QMSPoiSearchOption *)poiSearchOption didReceiveResult:(QMSPoiSearchResult *)poiSearchResult {
    NSLog(@"%@", poiSearchResult);
    
    if (poiSearchResult.count == 0) {
        return;
    }
    
    // 地图移动到搜索结果的第一个位置
    if (_searchBar.text.length > 0) {
        _selectedIndex = 0;
        QMSPoiData *firstData = poiSearchResult.dataArray[0];
        _annotation.coordinate = firstData.location;
        [self.mapView setCenterCoordinate:firstData.location animated:YES];
    } else {
        _selectedIndex = -1;
    }
    
    _searchResultArray = poiSearchResult.dataArray;
    [_searchResultTableView reloadData];
}


#pragma mark - SearchBar
- (void)setupSearchView {
    
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 344, [UIScreen mainScreen].bounds.size.width, 344)];
    _searchView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_searchView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    [_searchView addSubview:_searchBar];
    
    _searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 300 - 44) style:UITableViewStyleGrouped];
    _searchResultTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _searchResultTableView.dataSource = self;
    _searchResultTableView.delegate = self;
    _searchResultTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.01, 0.01)];
    [_searchView addSubview:_searchResultTableView];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchCurrentLocationWithKeyword:searchBar.text];
}


#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *searchCellIdentifier = @"SearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:searchCellIdentifier];
    }
    
    QMSPoiData *data = _searchResultArray[indexPath.row];
    cell.textLabel.text = data.title;
    cell.detailTextLabel.text = data.address;
    
    if (indexPath.row == _selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedIndex = indexPath.row;
    
    QMSPoiData *data = _searchResultArray[indexPath.row];
    
    // 更新位置
    [self.mapView setCenterCoordinate:data.location animated:YES];
    
    [self.searchResultTableView reloadData];
}


#pragma mark - Keyboard
- (void)setupKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // 获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.searchView.frame = CGRectMake(0, 0, weakSelf.searchView.bounds.size.width, self.view.frame.size.height);
        weakSelf.searchResultTableView.frame = CGRectMake(0, weakSelf.searchBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - height - weakSelf.searchBar.frame.size.height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.searchView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 344, weakSelf.searchView.bounds.size.width, 344);
        weakSelf.searchResultTableView.frame = CGRectMake(0, weakSelf.searchBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, weakSelf.searchView.frame.size.height - weakSelf.searchBar.frame.size.height);
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
