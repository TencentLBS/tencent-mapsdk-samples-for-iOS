//
//  DeliveryCell.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/6/22.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "DeliveryRouteView.h"

@interface DeliveryRouteView ()

@property (nonatomic, strong) UILabel *routeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *hintView;
@property (nonatomic, strong) UIView *linerView;

@end

@implementation DeliveryRouteView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    _routeLabel = [[UILabel alloc] init];
    _routeLabel.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:_routeLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:_timeLabel];
    
    _hintView = [[UIView alloc] init];
    _hintView.frame = CGRectMake(0, 5, 60, 5);
    _hintView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _hintView.hidden = YES;
    _hintView.layer.cornerRadius = 2.5;
    [self addSubview:_hintView];
    
    _linerView = [[UIView alloc] init];
    _linerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self addSubview:_linerView];
}

- (void)setModel:(DeliveryModel *)model {
    _model = model;
    
    _routeLabel.text = [NSString stringWithFormat:@"%@  ->  %@", model.origin, model.destination];
    if (model.time == 0) {
        _timeLabel.text = @"未抵达";
    } else {
        _timeLabel.text = [NSString stringWithFormat:@"耗时%li小时", model.time];
    }
    
    [_routeLabel sizeToFit];
    [_timeLabel sizeToFit];
    
    if (model.firstStep) {
        _hintView.hidden = NO;
    } else {
        _hintView.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _routeLabel.frame = CGRectMake(10, 0, _routeLabel.bounds.size.width, _routeLabel.bounds.size.height);
    _routeLabel.center = CGPointMake(_routeLabel.center.x, self.bounds.size.height * 0.5);
    
    _timeLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - _timeLabel.bounds.size.width,
                                  0,
                                  _timeLabel.bounds.size.width,
                                  _timeLabel.bounds.size.height);
    _timeLabel.center = CGPointMake(_timeLabel.center.x, self.bounds.size.height * 0.5);
    
    if (_model.firstStep) {
        _hintView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, _hintView.center.y);
    }
    
    _linerView.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
}

@end
