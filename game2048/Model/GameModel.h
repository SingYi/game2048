//
//  GameModel.h
//  OC_2048
//
//  Created by 石燚 on 16/4/22.
//  Copyright © 2016年 石燚. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GameModel;

@protocol GameModelDelegate <NSObject>

- (void)gameModelAddNewNumberAtIndex:(NSInteger)index;

@end


@interface GameModel : NSObject

@property (nonatomic,strong) NSMutableArray<NSNumber *> *dataArray;
@property (nonatomic,strong) NSMutableArray *viewData;
@property (nonatomic,assign) NSInteger number;

@property (nonatomic,weak) id delegate;

//添加一个新的数字
- (void)addNewNumber;

////游戏开始
- (NSMutableArray<NSNumber *> *)newGame:(NSMutableArray *)dataArray;

- (NSMutableArray<NSNumber *> *)swipeUp:(NSMutableArray<NSNumber *> *)array;
- (NSMutableArray<NSNumber *> *)swipeDown:(NSMutableArray<NSNumber *> *)array;
- (NSMutableArray<NSNumber *> *)swipeLeft:(NSMutableArray<NSNumber *> *)array;
- (NSMutableArray<NSNumber *> *)swipeRight:(NSMutableArray<NSNumber *> *)array;

@end
