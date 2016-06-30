//
//  NumberCell.m
//  OC_2048
//
//  Created by 石燚 on 16/4/22.
//  Copyright © 2016年 石燚. All rights reserved.
//

#import "NumberCell.h"
#import "SettingViewController.h"

#define CELL_WIDTH (([UIScreen mainScreen].bounds.size.width / 4) - 20)

@interface NumberCell ()

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) NSDictionary *backgroundColor;
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSDictionary *gameModelForKongfu;
@property (nonatomic,strong) NSDictionary *gameModelForeducation;

@end

@implementation NumberCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_WIDTH)];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:24];
    [self.contentView addSubview:self.label];
}

- (void)setNumber:(NSNumber *)number {
    _number = number;
    if (_isNew) {
        [self transformLabel];
        _isNew = NO;
    }
}

- (void)setShwoModel:(NSInteger)ShwoModel {
    _ShwoModel = ShwoModel;
    self.label.layer.cornerRadius = 10;
    self.label.layer.masksToBounds = YES;
    if (_number.integerValue == 0) {
        self.label.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        self.label.text = @"";
    } else {
        self.label.backgroundColor = self.backgroundColor[_number];
        self.label.alpha = 0.9;
        self.label.textColor = [UIColor whiteColor];
        switch (_ShwoModel) {
            case 0:
                self.label.text = [NSString stringWithFormat:@"%ld",self.number.integerValue];
                break;
            case 1:
                self.label.text = [NSString stringWithFormat:@"%@",self.gameModelForKongfu[self.number]];
                break;
            case 2:
                self.label.text = [NSString stringWithFormat:@"%@",self.gameModelForeducation[self.number]];
                break;
            default:
                break;
        }
    }
}


- (void)transformLabel {
    self.label.center = CGPointMake(CELL_WIDTH / 2, CELL_WIDTH / 2);
    self.label.bounds = CGRectMake(0, 0, CELL_WIDTH - 20 , CELL_WIDTH - 20);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(ditransform) userInfo:nil repeats:YES];
}

- (void)ditransform {
    CGFloat wideth = self.label.bounds.size.width;
    wideth = wideth + 4;
    self.label.bounds = CGRectMake(0, 0, wideth, wideth);
    if (wideth == CELL_WIDTH) {
        [self.timer invalidate];
    }
}

#pragma mark - 懒加载
- (NSDictionary *)backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = @{@2:    [UIColor redColor],
                             @4:    [UIColor orangeColor],
                             @8:    [UIColor colorWithRed:0.6 green:0.2 blue:0.3 alpha:1],
                             @16:   [UIColor grayColor],
                             @32:   [UIColor brownColor],
                             @64:   [UIColor purpleColor],
                             @128:  [UIColor colorWithRed:0.7 green:0.2 blue:0.5 alpha:1],
                             @256:  [UIColor magentaColor],
                             @512:  [UIColor darkGrayColor],
                             @1024: [UIColor blackColor],
                             @2048: [UIColor blackColor],
                             @4096: [UIColor blackColor],
                             @8192: [UIColor blackColor]
                             };

    }
    return _backgroundColor;
}

- (NSDictionary *)gameModelForKongfu {
    if (!_gameModelForKongfu) {
        _gameModelForKongfu = @{@2:    @"小兵",
                                @4:    @"排长",
                                @8:    @"连长",
                                @16:   @"营长",
                                @32:   @"团长",
                                @64:   @"旅长",
                                @128:  @"师长",
                                @256:  @"军长",
                                @512:  @"司令",
                                @1024: @"首长",
                                @2048: @"总理",
                                @4096: @"主席",
                                @8192: @"啥?"
                             };
        
    }
    return _gameModelForKongfu;
}

- (NSDictionary *)gameModelForeducation {
    if (!_gameModelForeducation) {
        _gameModelForeducation = @{@2:    @"幼稚园",
                                   @4:    @"小学",
                                   @8:    @"初中",
                                   @16:   @"高中",
                                   @32:   @"专科",
                                   @64:   @"本科",
                                   @128:  @"研究生",
                                   @256:  @"硕士",
                                   @512:  @"博士",
                                   @1024: @"博士后",
                                   @2048: @"毕业",
                                   @4096: @"结婚",
                                   @8192: @"啥?"
                                };
        
    }
    return _gameModelForeducation;
}



@end






