//
//  TitleInfoWindowView.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/5/22.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "TitleInfoWindowView.h"

@interface TitleInfoWindowView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@end

@implementation TitleInfoWindowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        self.alpha = 0;
        
//        self.layer.cornerRadius = 5;
//        self.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.8].CGColor;
//        self.layer.borderWidth = 0.5;
    }
    
    return self;
}

- (void)rebuildSubviews {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"Group"];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imageView];
    }
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = _title;
        [self addSubview:_titleLabel];
    }
    
    if (_subtitleLabel == nil) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:13];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.text = _subtitle;
        [self addSubview:_subtitleLabel];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
}

- (void)presentInfoWindowInView:(UIView *)view {
    
    if (self.hidden) {
        // 构建控件
        [self rebuildSubviews];

        CGFloat marginTop = 15;
        CGFloat marginLeft = 20;
        CGFloat labelHeight = 20;
        
        // 设置内容
        _titleLabel.text = _title;
        [_titleLabel sizeToFit];
        
        _subtitleLabel.text = _subtitle;
        [_subtitleLabel sizeToFit];
        
        CGFloat width = _titleLabel.frame.size.width > _subtitleLabel.frame.size.width ? _titleLabel.frame.size.width : _subtitleLabel.frame.size.width;
        
        _titleLabel.frame = CGRectMake(marginLeft, marginTop, width, labelHeight);
        
        _subtitleLabel.frame = CGRectMake(marginLeft, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 5, width, labelHeight);
        
        [view addSubview:self];
        
        CGFloat infoWindowWidth = width + marginLeft * 2;
        CGFloat infoWindowHeight = labelHeight * 2 + 5 * 3 + 30;
        self.frame = CGRectMake(0, -infoWindowHeight + 10, infoWindowWidth, infoWindowHeight);
        self.center = CGPointMake(view.frame.size.width * 0.5, self.center.y);
        
        _imageView.frame = self.bounds;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.hidden = NO;
            self.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}
@end
