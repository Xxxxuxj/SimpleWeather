//
//  RightTableViewController.m
//  Weather
//
//  Created by 徐xj on 2021/7/22.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import "RightTableViewController.h"
#import "RightTableViewCell.h"
#import "AppDelegate.h"
#import "Helper.h"
@interface RightTableViewController () <UIPickerViewDelegate,UIPickerViewDataSource>
{
    
    //历史城市
    NSArray* historyCity;
    
    NSArray* section0Title;
    NSArray* section0Img;
    
    //添加的城市
    NSString* addedcity;
    
    CGRect pickerViewFrame;
}
@property NSInteger toggle;
@property (strong, nonatomic) UIView *addCityView;
@property(nonatomic,copy)NSArray* pickerData;
@property(nonatomic,strong)NSMutableDictionary *dictionary;
@property(nonatomic,strong)NSArray *provinceArray;
@property(nonatomic,copy)NSString *selectedProvince;
@property(nonatomic)UIPickerView* pickerView;

@end

@implementation RightTableViewController







- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //初始化
    CGRect mainScreenBounds=[[UIScreen mainScreen]bounds];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,mainScreenBounds.size.width, mainScreenBounds.size.height)];
    
    self.tableView.backgroundColor=[UIColor colorWithRed:(40.0/255.0) green:(37.0/255.0) blue:(40.0/255.0) alpha:1.0];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    
    //
    [self showHistoryCity];
    
    
    
    section0Title=@[@"提醒",@"设置",@"支持"];
    section0Img=@[@"reminder",@"setting",@"contact"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UINib* nib=[UINib nibWithNibName:@"RightTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"reuseIdentifier"];
    
    self.tableView.rowHeight=69;
    
    self.tableView.separatorStyle=UIAccessibilityTraitNone;
    
    
    
    //对historycity 的操作 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"ReloadTabelView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCity:) name:@"DeleteCity" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCity:) name:@"InsertCity" object:nil];
    
    //setting界面的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alertSetMenu) name:@"AlertSetMenu" object:nil];
    
    
    
    //所有省份和城市的信息
    NSString*path=[[NSBundle mainBundle]pathForResource:@"ProvincesAndCities" ofType:@"plist"];
    //NSLog(@"%@",path);
    NSArray* array=[[NSArray alloc]initWithContentsOfFile:path];
    self.dictionary=[NSMutableDictionary new];
    for(NSDictionary* dic in array){
        [self.dictionary addEntriesFromDictionary:dic];
    }
    
    //获取字典中所有的省份并排序保存
    self.provinceArray = [[self.dictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    self.selectedProvince = self.provinceArray[0];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]){
        [self.addCityView removeFromSuperview];
    }
}
-(void)deleteCity:(NSNotification*)sender{
    [[[Helper alloc]init]deleteCity:sender.userInfo[@"chooseCity"]];
    historyCity=[[[Helper alloc]init]readChaceCity];
    [self.tableView reloadData];
}

-(void)reloadTableView:(NSNotification*)sender{
    historyCity=[[[Helper alloc]init]readChaceCity];
    [self.tableView reloadData];
}

-(void)insertCity:(NSNotification*)sender{
    [[[Helper alloc]init]insertCity:sender.userInfo[@"insertCity"]];
    historyCity=[[Helper new]readChaceCity];
    [self.tableView reloadData];
}

-(void)showHistoryCity{
    historyCity=[[[Helper alloc]init]readChaceCity];
    [self.tableView reloadData];
}
//#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    if(section == 0){
        return 3;
    }else{
        return 1+historyCity.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    if(indexPath.section == 0){
        cell.titleLabel.text=section0Title[indexPath.row];
        cell.indicatorImageView.image=[UIImage imageNamed:section0Img[indexPath.row]];
        cell.tintColor=[UIColor whiteColor];
        cell.deleteBtn.hidden=true;
    }else{
        if(indexPath.row == 0){
            cell.titleLabel.text=@"添加";
            cell.indicatorImageView.image=[UIImage imageNamed:@"add"];
            cell.deleteBtn.hidden=true;
        }
//        else if(indexPath.row==1){
//            cell.titleLabel.text=@"定位";
//            cell.indicatorImageView.image=[UIImage imageNamed:@"city"];
//            cell.deleteImageView.hidden=true;
//        }
        else{
            cell.titleLabel.text=historyCity[indexPath.row-1];
//            UIImage* img=[[UIImage imageNamed:@"delete"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.indicatorImageView.image=[UIImage imageNamed:@"city"];
            cell.deleteBtn.tintColor=[UIColor redColor];
            cell.deleteBtn.hidden=false;
        }
    }
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
        
    }else{
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        return lbl;
    }else{
        UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        lbl.text=@"城市管理";
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.backgroundColor=[UIColor blackColor];
        lbl.textColor=[UIColor whiteColor];
        return lbl;
    }
}

-(void)alertSetMenu{
    UIStoryboard* storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    SettingTableViewController* settingController=[storyBoard instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
    
    [self.controller presentViewController:settingController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.selected=NO;
        if(indexPath.row==2){
            UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"联系或反馈" message:@"请邮箱联系：2205931267@qq.com" preferredStyle:1];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //NSLog(@"OK Action");
                }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if(indexPath.row==0){
            UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"操作提示" message:@"点击添加可添加城市,点击红色删除按钮即可删除城市" preferredStyle:1];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //NSLog(@"OK Action");
                }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if(indexPath.row==1){
            [self alertSetMenu];
        }
    }
    
    if( indexPath.section == 1){
        if(indexPath.row == 0){
            //NSIndexPath* ip=[self.tableView indexPathForSelectedRow];
            //UIStoryboard* storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

            //addNewCityViewController* addNewCityController= [storyBoard instantiateViewControllerWithIdentifier:@"AddNewCityViewController"];

            //[self.controller presentViewController:addNewCityController animated:true completion:^{}];
            CGRect mainScreenBounds=[[UIScreen mainScreen]bounds];
            self.addCityView=[[UIView alloc]initWithFrame:pickerViewFrame];
            self.addCityView.backgroundColor=[UIColor grayColor];

            UIButton* cancelBtn=[[UIButton alloc]initWithFrame: CGRectMake(0, 0, 50, 50)];
            //cancelbtn.backgroundColor=[UIColor whiteColor];
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.addCityView addSubview:cancelBtn];
            UIButton* submitBtn=[[UIButton alloc]initWithFrame: CGRectMake(mainScreenBounds.size.width-110, 0, 50, 50)];
            //cancelbtn.backgroundColor=[UIColor whiteColor];
            [submitBtn setTitle:@"完成" forState:UIControlStateNormal];
            [submitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.addCityView addSubview:submitBtn];
            
            self.pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, mainScreenBounds.size.width-60, 250)];
            self.pickerView.delegate=self;
            self.pickerView.dataSource=self;
            
            
            [self.addCityView addSubview:self.pickerView];
            
            

            [self.tableView addSubview:self.addCityView];
            
            
            
            
            
            
        }
//        else if(indexPath.row == 1){
//            NSLog(@"自动定位");
//        }
        else{
            NSString* newcity=[NSString new];
            NSIndexPath* ip=[self.tableView indexPathForSelectedRow];
            RightTableViewCell* cell=[self.tableView cellForRowAtIndexPath:ip];
            newcity=cell.titleLabel.text;
            [self.addCityView removeFromSuperview];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ChooseLocationNotification" object:nil userInfo:@{@"chooseCity" : newcity}];
        }
        
    }

}

-(void)cancelBtn:(UIButton*)sender{
    [self.addCityView removeFromSuperview];
}

-(void)submitBtn:(UIButton*)sender{
    NSInteger number1=[self.pickerView selectedRowInComponent:0];
    NSString* str=self.provinceArray[number1];
    NSInteger number2=[self.pickerView selectedRowInComponent:1];
    NSString* city=self.dictionary[str][number2];
    
    addedcity=city;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadTableView" object:nil userInfo:@{@"chooseCity" : addedcity}];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChooseLocationNotification" object:nil userInfo:@{@"chooseCity" : addedcity}];
    self.selectedProvince=self.provinceArray[0];
    [self.addCityView removeFromSuperview];
    [self reloadTableView:nil];
    //NSLog(@"%@",city);
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint p=self.tableView.contentOffset;
    CGRect mainScreenBounds=[[UIScreen mainScreen]bounds];
    self->pickerViewFrame=CGRectMake(60, p.y+mainScreenBounds.size.height-300, mainScreenBounds.size.width-60, 300);
}

//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//设置指定列包含的项数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArray.count;
    }
    return [self.dictionary[self.selectedProvince] count];
}

//设置每个选项显示的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArray[row];
    }
    return [self.dictionary[self.selectedProvince] objectAtIndex:row];
}

//用户进行选择
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.selectedProvince = self.provinceArray[row];
        [self.pickerView reloadComponent:1];
        //设置第二列首选的始终是第一个
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
    }
}




@end
