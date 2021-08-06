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

@property(nonatomic,strong)UIViewController * mainViewController;
@property(nonatomic,strong)LeftTableViewController * leftViewController;
@property(nonatomic,strong)RightTableViewController * rightViewController;

//滑动速率
@property(nonatomic,assign)CGFloat speed_f;


//什么时候显示中间的view 什么时候显示左右边的view
//为滑动的距离
@property(nonatomic,assign)CGFloat condition_f;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainViewAction:) name:@"ChooseLocationNotification" object:nil];
    

    
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
    self.rightViewController.controller=self;
    
    //最后添加main 保证其在最上层
    [self.view addSubview:self.mainViewController.view];
    
    
    
    //隐藏
    self.leftViewController.view.hidden=true;
    self.rightViewController.view.hidden=true;
    
    //设置滑动的动作
    UIGestureRecognizer* pan=[UIPanGestureRecognizer new];
    [pan addTarget:self action:@selector(panAction:)];
    //将动作添加到mainview中
    [self.mainViewController.view addGestureRecognizer:pan];
    
    
    
    
    
}
-(void)showMainViewAction:(NSNotification *)sender{
    [self showMainView];
}



// 隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return false;
}


//滑动的选择器
-(void)panAction:(UIPanGestureRecognizer *)sender{
    
    
    
    //获取手指的位置改变
    CGPoint point= [sender translationInView:sender.view];
    
    //累加赋值给condition 作为滑动的距离
    //但是有一个小bug 当一直小幅度滑动时
    //滑动多次后 就会翻页
    self.condition_f += point.x;
    
    
    //根据滑动的方向 令左边或者右边的视图隐藏
    if(sender.view.frame.origin.x  >= 0){
        sender.view.center=CGPointMake(sender.view.center.x+point.x*self.speed_f, sender.view.center.y);
        
        //另每时每刻mainview左上角的坐标都为（0.0）
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
        self.rightViewController.view.hidden=true;
        self.leftViewController.view.hidden=false;
    }else{
        sender.view.center=CGPointMake(sender.view.center.x+point.x*self.speed_f, sender.view.center.y);
        
        //另每时每刻mainview左上角的坐标都为（0.0）
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
