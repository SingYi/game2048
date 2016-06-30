//
//  NumberCell.h
//  OC_2048
//
//  Created by 石燚 on 16/4/22.
//  Copyright © 2016年 石燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"

@interface NumberCell : UICollectionViewCell

@property (nonatomic,assign) NSNumber *number;

@property (nonatomic,assign) NSInteger ShwoModel;

@property (nonatomic,assign) BOOL isNew;

@end
