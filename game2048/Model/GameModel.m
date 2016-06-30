//
//  GameModel.m
//  OC_2048
//
//  Created by 石燚 on 16/4/22.
//  Copyright © 2016年 石燚. All rights reserved.
//

#import "GameModel.h"

@interface GameModel ()


//判断还有多少个空位置没有数字,并且返回空位置的个数
- (NSInteger)isEmpty:(NSMutableArray *)array;

//生成一个随机数(随机选中一个空位置)
- (NSInteger)randomNumber:(NSInteger)num;



@end

@implementation GameModel

//判断数组是否为空
- (NSInteger)isEmpty:(NSMutableArray<NSNumber*> *)array {
    NSInteger number = 0;
    for (NSInteger index = 0; index < array.count; index ++) {
        if (array[index].integerValue == 0) {
            number ++;
        }
    }
    return number;
}

//选择一个空位置
- (NSInteger)randomNumber:(NSInteger)num {
    NSInteger randmNum = arc4random() % num + 1;
    return randmNum;
}

//添加一个新数字
- (void)addNewNumber {
    //找出空位
    NSInteger number = [self isEmpty:self.dataArray];
    if (number != 0) {
        //随机空位
        number = [self randomNumber:number];
        NSInteger mark = 0;
        for (NSInteger index = 0; index < self.dataArray.count; index ++) {
            if (self.dataArray[index].integerValue == 0) {
                mark ++;
                if (mark == number) {
                    
                    if (arc4random() % 6 == 0) {
                        [self.dataArray setObject:[NSNumber numberWithInteger:4] atIndexedSubscript:index];
//                        NSLog(@"%ld",index);
                        if ([self.delegate respondsToSelector:@selector(gameModelAddNewNumberAtIndex:)]) {
                            [self.delegate gameModelAddNewNumberAtIndex:index];
                        }
                    } else {
                        [self.dataArray setObject:[NSNumber numberWithInteger:2] atIndexedSubscript:index];
//                        NSLog(@"%ld",index);
                        if ([self.delegate respondsToSelector:@selector(gameModelAddNewNumberAtIndex:)]) {
                            [self.delegate gameModelAddNewNumberAtIndex:index];
                        }
                    }
                }
            }
        }
    }
//    return 20;
}

#pragma mark - 开始游戏

- (NSMutableArray *)newGame:(NSMutableArray *)dataArray {
    self.dataArray = [dataArray mutableCopy];
//    for (NSInteger index = 0; index < 4; index ++) {
        [self addNewNumber];
//    }
//    NSMutableArray *numberArray = [NSMutableArray arrayWithArray:self.dataArray];
    return [self.dataArray mutableCopy];
}

#pragma mark - 懒加载
//初始化数据数组
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]initWithCapacity:16];
        for (NSInteger index = 0; index < 16; index ++) {
            [_dataArray addObject:[NSNumber numberWithInteger:0]];
        }
    }
    return _dataArray;
}


#pragma mark - 移动和合并
//向上移动和合并
- (NSMutableArray<NSNumber *> *)swipeUp:(NSMutableArray<NSNumber*> *)array {
    NSInteger i = 0,j = 0;//行(i)和列(j)
    //移动
    for (int t = 0; t < 4; t++) {
        for (i = 0; i < 3; i++) {
            for (j = 0; j < 4; j++) {
                if (array[i * 4 + j].integerValue == 0 ) {
                    [array exchangeObjectAtIndex:i * 4 + j withObjectAtIndex:(i + 1) * 4 + j];
                }
            }
        }
    }
    //合并
    for (i = 0; i < 3; i++) {
        for (j = 0; j < 4; j++) {
            if (array[i * 4 + j].integerValue == array[(i + 1) * 4 + j].integerValue) {
                NSNumber *data = [NSNumber numberWithInteger:array[i * 4 + j].integerValue * 2];
                [array setObject:data atIndexedSubscript:i * 4 + j];
                data = @0;
                [array setObject:data atIndexedSubscript:(i + 1) * 4 + j];
            }
        }
    }
    //移动
    for (i = 0; i < 3; i++) {
        for (j = 0; j < 4; j++) {
            if (array[i * 4 + j].integerValue == 0 ) {
                [array exchangeObjectAtIndex:i * 4 + j withObjectAtIndex:(i + 1) * 4 + j];
            }
        }
    }

    for (NSInteger i = 0; i < array.count; i++) {
        if (self.dataArray[i].integerValue != array[i].integerValue) {
            self.dataArray = [array mutableCopy];
            [self addNewNumber];
            return self.dataArray;
        }
    }
    if ([self.delegate respondsToSelector:@selector(gameModelAddNewNumberAtIndex:)]) {
        [self.delegate gameModelAddNewNumberAtIndex:20];
    }
    return array;
}

//向下移动和合并
- (NSMutableArray<NSNumber *> *)swipeDown:(NSMutableArray<NSNumber*> *)array {
    NSInteger i = 0,j = 0;//行(i)和列(j)
    //移动
    for (int t = 0; t < 4; t++) {
        for (i = 0; i < 3; i++) {
            for (j = 0; j < 4; j++) {
                if (array[(i + 1) * 4 + j].integerValue == 0 ) {
                    [array exchangeObjectAtIndex:(i + 1) * 4 + j withObjectAtIndex:i * 4 + j];
                }
            }
        }
    }
    //合并
    for (i = 3; i > 0; i--) {
        for (j = 0; j < 4; j++) {
            if (array[i * 4 + j].integerValue == array[(i - 1) * 4 + j].integerValue) {
                NSNumber *data = [NSNumber numberWithInteger:array[i * 4 + j].integerValue * 2];
                [array setObject:data atIndexedSubscript:i * 4 + j];
                data = @0;
                [array setObject:data atIndexedSubscript:(i - 1) * 4 + j];
            }
        }
    }
    //移动
    for (i = 0; i < 3; i++) {
        for (j = 0; j < 4; j++) {
            if (array[(i + 1) * 4 + j].integerValue == 0 ) {
                [array exchangeObjectAtIndex:(i + 1) * 4 + j withObjectAtIndex:i * 4 + j];
            }
            
        }
    }

    for (NSInteger i = 0; i < array.count; i++) {
        if (self.dataArray[i].integerValue != array[i].integerValue) {
            self.dataArray = [array mutableCopy];
            [self addNewNumber];
            return self.dataArray;
        }
    }
    if ([self.delegate respondsToSelector:@selector(gameModelAddNewNumberAtIndex:)]) {
        [self.delegate gameModelAddNewNumberAtIndex:20];
    }
    return array;
}

//向左移动和合并
- (NSMutableArray<NSNumber *> *)swipeLeft:(NSMutableArray<NSNumber *> *)array {
    NSInteger i = 0,j = 0;//行(i)和列(j)
    //移动
    for (int t = 0; t < 4; t++) {
        for (j = 0; j < 3; j++) {
            for (i = 0; i < 4; i++) {
                if (array[i * 4 + j].integerValue == 0 ) {
                    [array exchangeObjectAtIndex:i * 4 + (j + 1) withObjectAtIndex:i * 4 + j];
                }
            }
        }
    }
    //合并
    for (j = 1; j < 4 ; j++) {
        for (i = 0; i < 4; i++) {
            if (array[i * 4 + j - 1].integerValue == array[i * 4 + j].integerValue) {
                NSNumber *data = [NSNumber numberWithInteger:array[i * 4 + j].integerValue * 2];
                [array setObject:data atIndexedSubscript:i * 4 + j - 1];
                data = @0;
                [array setObject:data atIndexedSubscript:i * 4 + j];
            }
        }
    }
    //移动
    for (j = 0; j < 3; j++) {
        for (i = 0; i < 4; i++) {
            if (array[i * 4 + j].integerValue == 0 ) {
                [array exchangeObjectAtIndex:i * 4 + (j + 1) withObjectAtIndex:i * 4 + j];
            }
        }
    }

    for (NSInteger i = 0; i < array.count; i++) {
        if (self.dataArray[i].integerValue != array[i].integerValue) {
            self.dataArray = [array mutableCopy];
            [self addNewNumber];
            return self.dataArray;
        }
    }
    if ([self.delegate respondsToSelector:@selector(gameModelAddNewNumberAtIndex:)]) {
        [self.delegate gameModelAddNewNumberAtIndex:20];
    }
    return array;
}

//向右移动和合并
- (NSMutableArray<NSNumber *> *)swipeRight:(NSMutableArray<NSNumber *> *)array {
    NSInteger i = 0,j = 0;//行(i)和列(j)
    //移动
    for (int t = 0; t < 4; t++) {
        for (j = 3; j > 0; j--) {
            for (i = 0; i < 4; i++) {
                if (array[i * 4 + j].integerValue == 0 ) {
                    [array exchangeObjectAtIndex:i * 4 + (j - 1) withObjectAtIndex:i * 4 + j];
                }
            }
        }
    }
    //合并
    for (j = 3; j > 0 ; j--) {
        for (i = 0; i < 4; i++) {
            if (array[i * 4 + (j - 1)].integerValue == array[i * 4 + j].integerValue) {
                NSNumber *data = [NSNumber numberWithInteger:array[i * 4 + j].integerValue * 2];
                [array setObject:data atIndexedSubscript:i * 4 + j];
                data = @0;
                [array setObject:data atIndexedSubscript:i * 4 + j - 1];
            }
        }
    }
    //移动
    for (j = 3; j > 0; j--) {
        for (i = 0; i < 4; i++) {
            if (array[i * 4 + j].integerValue == 0 ) {
                [array exchangeObjectAtIndex:i * 4 + (j - 1) withObjectAtIndex:i * 4 + j];
            }
        }
    }

    for (NSInteger i = 0; i < array.count; i++) {
        if (self.dataArray[i].integerValue != array[i].integerValue) {
            self.dataArray = [array mutableCopy];
            [self addNewNumber];
            return self.dataArray;
        }
    }
    if ([self.delegate respondsToSelector:@selector(gameModelAddNewNumberAtIndex:)]) {
        [self.delegate gameModelAddNewNumberAtIndex:20];
    }
    return array;
}


@end

