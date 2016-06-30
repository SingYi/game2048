//
//  SettingViewController.m
//  OC_2048
//
//  Created by 石燚 on 16/5/12.
//  Copyright © 2016年 石燚. All rights reserved.
//

#import "SettingViewController.h"
#import "ViewController.h"

#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface SettingViewController ()

@property (nonatomic,strong) ViewController *vc;

@property (nonatomic,strong) UIButton *normalBtn;

@property (nonatomic,strong) UIButton *kongfuBtn;

@property (nonatomic,strong) UIButton *eduBtn;

@property (nonatomic,strong) UIImageView *backGround;

- (UIButton *)creatBtnWihttitle:(NSString*)title setCenter:(CGPoint)center;

- (void)initUserInterface;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.navigationItem.title = @"选择模式";
    
    _normalBtn = [self creatBtnWihttitle:@"正常模式" setCenter:CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 4)];
    
    _kongfuBtn = [self creatBtnWihttitle:@"军旅等级" setCenter:CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2)];
    
    _eduBtn = [self creatBtnWihttitle:@"学历水平" setCenter:CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 4 * 3)];
    
    [self.view addSubview:self.normalBtn];
    
    [self.view addSubview:self.kongfuBtn];
    
    [self.view addSubview:self.eduBtn];
    
    [self setUpEffect];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2]];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

//创建按钮
- (UIButton *)creatBtnWihttitle:(NSString*)title setCenter:(CGPoint)center {
    UIButton *testBtn = [[UIButton alloc]init];
    testBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 2, 44);
    testBtn.center = center;
    [testBtn setTitle:title forState:(UIControlStateNormal)];
    testBtn.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    [testBtn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:(UIControlStateNormal)];
    testBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    testBtn.layer.cornerRadius = 10;
    testBtn.layer.masksToBounds = YES;
    [testBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    return testBtn;
}

#pragma mark - 监听
- (void)clickBtn:(UIButton *)btn {
    if ([btn.titleLabel.text isEqualToString:@"正常模式"]) {
        self.vc.ShowModel = 0;
        [self.navigationController pushViewController:self.vc animated:YES];
    } else if ([btn.titleLabel.text isEqualToString:@"军旅等级"]) {
        self.vc.ShowModel = 1;
        [self.navigationController pushViewController:self.vc animated:YES];
    } else if ([btn.titleLabel.text isEqualToString:@"学历水平"]) {
        self.vc.ShowModel = 2;
        [self.navigationController pushViewController:self.vc animated:YES];
    }
}

//设置毛玻璃效果
- (void)setUpEffect {
    [self.view addSubview:self.backGround];
    [self.view sendSubviewToBack:self.backGround];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    
    effectview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height);
    
    [self.view addSubview:effectview];
    [self.view insertSubview:effectview aboveSubview:self.backGround];
}

#pragma mark - 懒加载
- (ViewController *)vc {
    if (!_vc) {
        _vc = [ViewController new];
    }
    return _vc;
}

- (UIImageView *)backGround {
    if (!_backGround) {
        _backGround = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _backGround.image = [UIImage imageNamed:@"1.jpg"];
    }
    return _backGround;
}




@end
