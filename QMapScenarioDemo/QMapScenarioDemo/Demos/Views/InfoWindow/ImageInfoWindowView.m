//
//  CarInfoWindowView.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/5/22.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "ImageInfoWindowView.h"

#define TitleHeight 21

@interface ImageInfoWindowView ()
@property (nonatomic, strong) UIImageView *backImageView;
@end

@implementation ImageInfoWindowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        self.alpha = 0;
    }
    
    return self;
}

- (void)rebuildSubviews {
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:@"jiancai"];
        [self addSubview:_backImageView];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
}

- (void)setImage:(NSString *)image {
    _image = image;
}

- (void)presentInfoWindowInView:(UIView *)view {
    
    if (self.hidden) {
        // 构建控件
        [self rebuildSubviews];
        
        [view addSubview:self];
        
        self.frame = CGRectMake(0, -70, 200, 80);
        self.center = CGPointMake(view.frame.size.width * 0.5, self.center.y);
        
        _backImageView.frame = self.bounds;
        
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
