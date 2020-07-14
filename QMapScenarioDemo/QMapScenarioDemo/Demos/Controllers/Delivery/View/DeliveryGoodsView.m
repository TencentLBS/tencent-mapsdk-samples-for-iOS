//
//  DeliveryGoodsCell.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/6/22.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "DeliveryGoodsView.h"

@interface DeliveryGoodsView ()

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, strong) UILabel *leftPriceLabel;

@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIImageView *righttImageView;
@property (nonatomic, strong) UILabel *rightTitleLabel;
@property (nonatomic, strong) UILabel *rightPriceLabel;

@property (nonatomic, strong) UIView *linerView;

@end


@implementation DeliveryGoodsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    // left view
    _leftView = [[UIView alloc] init];
    [self addSubview:_leftView];
    _leftImageView = [[UIImageView alloc] init];
    _leftTitleLabel = [[UILabel alloc] init];
    _leftTitleLabel.font = [UIFont systemFontOfSize:15.0];
    _leftTitleLabel.textAlignment = NSTextAlignmentCenter;
    _leftPriceLabel = [[UILabel alloc] init];
    _leftPriceLabel.font = [UIFont systemFontOfSize:14.0];
    _leftPriceLabel.textAlignment = NSTextAlignmentCenter;
    [_leftView addSubview:_leftImageView];
    [_leftView addSubview:_leftTitleLabel];
    [_leftView addSubview:_leftPriceLabel];
    
    // right view
    _rightView = [[UIView alloc] init];
    [self addSubview:_rightView];
    _righttImageView = [[UIImageView alloc] init];
    _rightTitleLabel = [[UILabel alloc] init];
    _rightTitleLabel.font = [UIFont systemFontOfSize:15.0];
    _rightTitleLabel.textAlignment = NSTextAlignmentCenter;
    _rightPriceLabel = [[UILabel alloc] init];
    _rightPriceLabel.font = [UIFont systemFontOfSize:14.0];
    _rightPriceLabel.textAlignment = NSTextAlignmentCenter;
    [_rightView addSubview:_righttImageView];
    [_rightView addSubview:_rightTitleLabel];
    [_rightView addSubview:_rightPriceLabel];
    
    _linerView = [[UIView alloc] init];
    _linerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self addSubview:_linerView];
}

- (void)setModel:(DeliveryGoodsModel *)model {
    _model = model;
    
    _leftImageView.image = [UIImage imageNamed:_model.imageName];
    _leftTitleLabel.text = _model.title;
    _leftPriceLabel.text = _model.price;
    
    _righttImageView.image = [UIImage imageNamed:_model.imageName];
    _rightTitleLabel.text = _model.title;
    _rightPriceLabel.text = _model.price;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat ScreenHeight = [UIScreen mainScreen].bounds.size.height;
    
    _leftView.frame = CGRectMake(0, 0, ScreenWidth * 0.5, ScreenHeight);
    _rightView.frame = CGRectMake(ScreenWidth * 0.5, 0, ScreenWidth * 0.5, ScreenHeight);
    
    // left
    _leftImageView.frame = CGRectMake(0, 5, 100, 100);
    _leftImageView.center = CGPointMake(ScreenWidth * 0.5 * 0.5, _leftImageView.center.y);
    _leftTitleLabel.frame = CGRectMake(0, _leftImageView.frame.origin.y + _leftImageView.frame.size.height + 5, ScreenWidth * 0.5, 20);
    _leftPriceLabel.frame = CGRectMake(0, _leftTitleLabel.frame.origin.y + _leftTitleLabel.frame.size.height, ScreenWidth * 0.5, 20);
    
    // right
    _righttImageView.frame = CGRectMake(0, 10, 100, 100);
    _righttImageView.center = CGPointMake(ScreenWidth * 0.5 * 0.5, _leftImageView.center.y);
    _rightTitleLabel.frame = CGRectMake(0, _leftImageView.frame.origin.y + _leftImageView.frame.size.height + 5, ScreenWidth * 0.5, 20);
    _rightPriceLabel.frame = CGRectMake(0, _leftTitleLabel.frame.origin.y + _leftTitleLabel.frame.size.height, ScreenWidth * 0.5, 20);
    
    _linerView.frame = CGRectMake(8, self.bounds.size.height - 0.5, self.bounds.size.width - 16, 0.5);
}

@end
