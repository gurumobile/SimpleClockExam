//
//  AlarmListVC.h
//  SimpleAlarmClock
//
//  Created by Bogdan on 10/23/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmListVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *alarmListTbl;

@property (nonatomic, strong) NSMutableArray *listOfAlarms;

- (IBAction)onAddAlarm:(id)sender;

@end
