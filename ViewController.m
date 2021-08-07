//
//  ViewController.m
//  xm2
//
//  Created by 徐xj on 2021/7/22.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
#import "LeftTableViewController.h"
#import "RightTableViewController.h"

@interface ViewController ()


//主界面 UIViewController
@property(nonatomic,strong)UIViewController * mainViewController;

//左界面 LeftTableViewController
@property(nonatomic,strong)LeftTableViewController * leftViewController;

//右界面 RightTableViewController
@property(nonatomic,strong)RightTableViewController * rightViewController;

//滑动速率 决定着转移界面需要滑动屏幕的距离
@property(nonatomic,assign)CGFloat speed_f;


//什么时候显示中间的view 什么时候显示左右边的view
//为滑动的距离
@property(nonatomic,assign)CGFloat condition_f;

@end





@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //注册一个通知 执行showMainViewAction
    //转到主界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainViewAction:) name:@"ChooseLocationNotification" object:nil];
    

    //初始化
    self.speed_f=1.0;
    self.condition_f=0;
    
    
    //设置mainview
    MainViewController* rootController=[MainViewController new];
    self.mainViewController=[[UINavigationController alloc]initWithRootViewController:rootController];
    
    
    //设置leftview
    self.leftViewController=[LeftTableViewController new];
    [self.view addSubview:self.leftViewController.view];
    
    
    //设置rightview
    self.rightViewController=[RightTableViewController new];
    [self.view addSubview:self.rightViewController.view];
    self.rightViewController.controller=(SettingTableViewController*) self;
    
    //最后添加main 保证其在最上层
    [self.view addSubview:self.mainViewController.view];
    
    
    
    //将左右界面先隐藏
    self.leftViewController.view.hidden=true;
    self.rightViewController.view.hidden=true;
    
    //设置滑动的手势
    UIGestureRecognizer* pan=[UIPanGestureRecognizer new];
    //将方法绑定到pan
    [pan addTarget:self action:@selector(panAction:)];
    
    
    //将手势添加到mainview中
    //LeftTableView和RightTableView 中无该事件
    [self.mainViewController.view addGestureRecognizer:pan];
    
    
    
    
    
}


//显示主界面
-(void)showMainViewAction:(NSNotification *)sender{
    [self showMainView];
}



// 隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return false;
}


//滑动触发的方法 参数为UIPanGesturRecognizer手势
-(void)panAction:(UIPanGestureRecognizer *)sender{
    
    
    
    //获取手指的位置改变
    CGPoint point= [sender translationInView:sender.view];
    
    
    
    
    
    //累加赋值给condition 作为滑动的距离
    self.condition_f += point.x;
    
    
    //根据滑动的方向 令左边或者右边的视图隐藏
    if(sender.view.frame.origin.x  >= 0){
        sender.view.center=CGPointMake(sender.view.center.x+point.x*self.speed_f, sender.view.center.y);
        
        //令偏移量重置为0
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
        self.rightViewController.view.hidden=true;
        self.leftViewController.view.hidden=false;
    }else{
        sender.view.center=CGPointMake(sender.view.center.x+point.x*self.speed_f, sender.view.center.y);
        
        //令偏移量重置为0 
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
        
        self.rightViewController.view.hidden=false;
        self.leftViewController.view.hidden=true;
        
    }
    
    
    
    //当手指离开屏幕时
    if(sender.state == UIGestureRecognizerStateEnded){
        
        //当滑动的距离达到一定程度时
        //距离大于正方向屏幕宽度*0.5*滑动速率时 showleftview
        //距离为大于负方向屏幕宽度*0.5*滑动速率时 showrightview
        //在这些之间 则会showmainview
        if(self.condition_f > UIScreen.mainScreen.bounds.size.width*0.5*self.speed_f){
            [self showLeftView];
        }else if(self.condition_f < UIScreen.mainScreen.bounds.size.width*(-0.5)*self.speed_f ){
            [self showRightView];
        }else{
            [self showMainView];
            self.condition_f=0;
        }
    }
    
    
}


-(void)showMainView{
    
    //动画
    [UIView beginAnimations:nil context:nil];
    
    //另主屏幕 mainview的中心为屏幕中心坐标为（屏幕宽度的一半，屏幕高度的一半）
    self.mainViewController.view.center=CGPointMake(UIScreen.mainScreen.bounds.size.width/2, UIScreen.mainScreen.bounds.size.height/2);
    
    [UIView commitAnimations];
}

-(void)showLeftView{
    [UIView beginAnimations:nil context:nil];
    //另主屏幕mainview的中心坐标为（屏幕宽度*1.5-60，屏幕高度的一半）
    self.mainViewController.view.center=CGPointMake(UIScreen.mainScreen.bounds.size.width* 1.5-60, UIScreen.mainScreen.bounds.size.height/2);
    [UIView commitAnimations];
}

-(void)showRightView{
    [UIView beginAnimations:nil context:nil];
    
    //另主屏幕mainview的中心坐标为（60-屏幕宽度*0.5，屏幕高度的一半）
    self.mainViewController.view.center=CGPointMake(60-UIScreen.mainScreen.bounds.size.width*0.5, UIScreen.mainScreen.bounds.size.height/2);
    [UIView commitAnimations];
}

@end
