//
//  ViewController.m
//  OC_2048
//
//  Created by 石燚 on 16/4/22.
//  Copyright © 2016年 石燚. All rights reserved.
//

#import "ViewController.h"
#import "NumberCell.h"
#import "GameModel.h"

#define DIMENSION 4
#define CELL_WIDTH ([UIScreen mainScreen].bounds.size.width / 4 - 20)
#define VIEW_HEIGHT ([UIScreen mainScreen].bounds.size.width * 0.4)
#define kSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define kSPACE 20 / 5



@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,GameModelDelegate>

{
    NSInteger maxPoint;
}


//视图
@property (nonatomic,strong) UICollectionView *mapView;
@property (nonatomic,strong) UICollectionViewFlowLayout *mapFlowLayout;

//得分标签
@property (nonatomic,strong) UILabel *pointLabel;
@property (nonatomic,strong) UILabel *maxPointLabel;

//数据数组
@property (nonatomic,strong) NSMutableArray<NSNumber *> *dataNumber;

//数据模型以及操作
@property (nonatomic,strong) GameModel *gameModel;

@property (nonatomic,strong) UIImageView *backGround;


@end

static NSString *cellId = @"cellId";
static NSInteger newNumber = 20;

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [self clickNewGameBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册原型cell
    [self.mapView registerClass:[NumberCell class] forCellWithReuseIdentifier:cellId];
    
    //添加背景地图
    [self.view addSubview:self.mapView];
    
    //添加手势监听
    [self setupSwipeGuestures];
    
//    //添加添加按钮(测试用)
//    [self setAddBtn];
    
    //添加开始按钮
    [self setNewGameBtn];
    
    //添加标签
    [self setUpLabel];
    
    //添加得分标签
    [self setCurrenPointLabel];
    
    //添加最高分标签
    [self setUpMaxPointLabel];
    
    [self setUpEffect];
    
    self.navigationItem.title = @"游戏开始";
    
    //设置返回按钮
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"选择模式" style:UIBarButtonItemStylePlain target:self action:@selector(clickModelBtn)];

    self.navigationItem.leftBarButtonItem = leftBtn;

}

- (void)clickModelBtn {
    // 创建弹窗视图
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"返回选择模式当前分数将会清空" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    // 创建取消按钮
    UIAlertAction *cacelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertVc addAction:cacelAction];
    
    //创建确定按钮
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        self.dataNumber = nil;
        [self calculatePoint];
        [self.mapView reloadData];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertVc addAction:sureAction];
    [self presentViewController:alertVc animated:YES completion:nil];
    
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

//提示标签
- (void)setUpLabel {
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 60, self.view.bounds.size.width, 44);
    label.text = @"滑动屏幕可以移动和合并单元格";
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

//设置添加按钮(测试用的按钮)
- (void)setAddBtn {
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 100, 44)];
    addBtn.backgroundColor = [UIColor orangeColor];
    [addBtn setTitle:@"添加数字" forState:(UIControlStateNormal)];
    [addBtn addTarget:self action:@selector(clickAddbtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:addBtn];
}

- (void)clickAddbtn {
    [self.gameModel addNewNumber];
    self.dataNumber = self.gameModel.dataArray;
    [self.mapView reloadData];
}


#pragma mark - 设置按钮和标签视图;
//添加开始按钮
- (void)setNewGameBtn {
    UIButton *newBtn = [[UIButton alloc]init];
    newBtn.frame = CGRectMake(kSCREENWIDTH / 10, kSCREENHEIGHT * 0.2, kSCREENWIDTH / 3, kSCREENWIDTH / 3);
    newBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [newBtn setTitle:@"新游戏" forState:(UIControlStateNormal)];
    [newBtn addTarget:self action:@selector(clickNewGameBtn) forControlEvents:(UIControlEventTouchUpInside)];
    newBtn.layer.cornerRadius = 10;
    newBtn.layer.masksToBounds = YES;
    newBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    
    [self.view addSubview:newBtn];
}

//设置当前得分标签
- (void)setCurrenPointLabel {
    [self calculatePoint];
    [self.view addSubview:self.pointLabel];
}

//显示当前得分
- (void)calculatePoint {
    NSInteger point = 0;
    for (NSInteger i = 0; i < _dataNumber.count; i++) {
        point += self.dataNumber[i].integerValue;
    }
    NSString *pointStr = [NSString stringWithFormat:@"当前得分:%5ld",point];
    
    
    //储存最高分
//    NSLog(@"%ld",maxPoint);
    if (point > maxPoint) {
        maxPoint = point;
        [self saveMaxpoint];
        [self getUpMaxPoint];
    }
    
    self.pointLabel.text = pointStr;
}

//设置最大分标签
- (void)setUpMaxPointLabel {
    [self getUpMaxPoint];
    [self.view addSubview:self.maxPointLabel];
}

//获得最大分
- (void)getUpMaxPoint {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    maxPoint = [user integerForKey:@"maxPoint"];
    NSString *pointStr = [NSString stringWithFormat:@"最高得分:%5ld",maxPoint];
    self.maxPointLabel.text = pointStr;
}

//保存数据
- (void)saveMaxpoint {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setInteger:maxPoint forKey:@"maxPoint"];
    [user synchronize];
}


#pragma mark - 开始游戏
- (void)clickNewGameBtn {
    self.dataNumber = nil;
    for (NSInteger i = 0; i < 4; i++) {
        self.dataNumber = [[self.gameModel newGame:self.dataNumber] mutableCopy];
        [self.mapView reloadData];
    }
    
    [self calculatePoint];
}



//添加手势监听
- (void)setupSwipeGuestures {
    //监听向上的方向，相应的处理方法 swipeUp
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUpView)];
    [swipeUp setNumberOfTouchesRequired:1];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    //监听向上下方向，相应的处理方法 swipeDown
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDownView)];
    [swipeDown setNumberOfTouchesRequired:1];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    //监听向左的方向，相应的处理方法 swipeLeft
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeftView)];
    [swipeLeft setNumberOfTouchesRequired:1];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    //监听向右的方向，相应的处理方法 swipeRight
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRightView)];
    [swipeRight setNumberOfTouchesRequired:1];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}

//手势监听方法
- (void)swipeUpView {
    NSArray *array = [self.gameModel swipeUp:self.dataNumber];
    self.dataNumber = [array mutableCopy];
//    NSLog(@"%@",self.dataNumber);
    [self.mapView reloadData];
    [self calculatePoint];
    
}

- (void)swipeDownView {
    NSArray *array = [self.gameModel swipeDown:self.dataNumber];
    self.dataNumber = [array mutableCopy];
    [self.mapView reloadData];
    [self calculatePoint];
}

- (void)swipeLeftView {
    NSArray *array = [self.gameModel swipeLeft:self.dataNumber];
    self.dataNumber = [array mutableCopy];
    [self.mapView reloadData];
    [self calculatePoint];
}

- (void)swipeRightView {
    NSArray *array = [self.gameModel swipeRight:self.dataNumber];
    self.dataNumber = [array mutableCopy];
    [self.mapView reloadData];
    [self calculatePoint];
}

#pragma mark - 懒加载

- (UICollectionView *)mapView {
    if (!_mapView) {
        //初始化一个布局对象
        _mapFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        //设置最小行距
        _mapFlowLayout.minimumInteritemSpacing = 2;
        //设置最小间距
        _mapFlowLayout.minimumLineSpacing = 2;
        //设置格子大小
        _mapFlowLayout.itemSize = CGSizeMake(CELL_WIDTH, CELL_WIDTH);
        //设置组边距
        _mapFlowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
        //设置头部高度
        _mapFlowLayout.headerReferenceSize = CGSizeMake(0,kSCREENHEIGHT * 0.45);
        //设置底部高度
        _mapFlowLayout.footerReferenceSize = CGSizeMake(0, 0);
        //初始化视图合集
        _mapView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:_mapFlowLayout];
        //设置背景颜色
        _mapView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0];
        //设置代理和数据源
        _mapView.dataSource = self;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (GameModel *)gameModel {
    if (!_gameModel) {
        _gameModel = [[GameModel alloc]init];
        _gameModel.delegate = self;
    }
    return _gameModel;
}

- (UILabel *)pointLabel {
    if (!_pointLabel) {
        _pointLabel = [UILabel new];;
        _pointLabel.frame = CGRectMake(kSCREENWIDTH / 2 + 5, kSCREENHEIGHT * 0.2, kSCREENWIDTH / 7 * 3, kSCREENWIDTH / 8 - 1);
        _pointLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _pointLabel.textColor = [UIColor whiteColor];
        _pointLabel.textAlignment = NSTextAlignmentCenter;
        _pointLabel.layer.cornerRadius = 10;
        _pointLabel.layer.masksToBounds = YES;
        _pointLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _pointLabel;
}

- (UILabel *)maxPointLabel {
    if (!_maxPointLabel) {
        _maxPointLabel = [UILabel new];;
        _maxPointLabel.frame = CGRectMake(kSCREENWIDTH / 2 + 5, kSCREENHEIGHT * 0.32, kSCREENWIDTH / 7 * 3, kSCREENWIDTH / 8 - 1);
        _maxPointLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _maxPointLabel.textColor = [UIColor whiteColor];
        _maxPointLabel.textAlignment = NSTextAlignmentCenter;
        _maxPointLabel.layer.cornerRadius = 10;
        _maxPointLabel.layer.masksToBounds = YES;
        _maxPointLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _maxPointLabel;
}

- (UIImageView *)backGround {
    if (!_backGround) {
        _backGround = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _backGround.image = [UIImage imageNamed:@"1.jpg"];
    }
    return _backGround;
}

#pragma mark -- 集合视图的数据源方法
//返回多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每组返回多少个格子
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 16;
}

#pragma mark - 设置单元格
//重用单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     NumberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    //传值给cell
    cell.number = self.dataNumber[indexPath.row];
    
    if (indexPath.row == newNumber) {
        cell.transform = CGAffineTransformMakeScale(0.7, 0.7);
        [UIView animateWithDuration:0.4 animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
    
    cell.ShwoModel = self.ShowModel;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(NumberCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.ShwoModel = self.ShowModel;
}

#pragma mark - GameModelDelegate 
- (void)gameModelAddNewNumberAtIndex:(NSInteger)index {
    newNumber = index;
}




@end
