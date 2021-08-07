//
//  SettingTableViewController.m
//  xm2
//
//  Created by mac on 2021/8/6.
//  Copyright © 2021 徐xj. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Helper.h"
@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setMenu) name:@"setMenu" object:nil];
    
    self.tableView.rowHeight=60;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell classForCoder] forCellReuseIdentifier:@"reuseIdentifier"];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text=@"清除城市信息";
    cell.textLabel.textColor=[UIColor redColor];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row==0){
            UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
            cell.selected=NO;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"setMenu" object:nil];
        }
    }
}

-(void)setMenu{
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:nil message:@"是否确认清除城市信息(保留当前城市)" preferredStyle:1];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //NSLog(@"OK Action");
            [[Helper new]removeCity];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadTabelView" object:nil];
        }];
    UIAlertAction* noAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //NSLog(@"NO Action");
    }];
    
    [alert addAction:okAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
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

@end
