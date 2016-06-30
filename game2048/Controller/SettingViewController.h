//
//  SettingViewController.h
//  OC_2048
//
//  Created by 石燚 on 16/5/12.
//  Copyright © 2016年 石燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingViewController;

@protocol SettingDelegate <NSObject>

- (void)SettingView:(SettingViewController *)settingVC selectModel:(NSInteger)test;

@end



@interface SettingViewController : UIViewController

@property (nonatomic,weak) id delegate;




@end
