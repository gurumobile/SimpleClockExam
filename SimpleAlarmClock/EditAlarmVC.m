//
//  EditAlarmVC.m
//  SimpleAlarmClock
//
//  Created by Bogdan on 10/23/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

#import "EditAlarmVC.h"
#import "AlarmListVC.h"
#import "AlarmObject.h"

@interface EditAlarmVC ()

@end

@implementation EditAlarmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.editMode) {
        self.titleLbl.text = @"Edit Alarm";
        NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
        NSData *alarmListData = [defaulsts objectForKey:@"AlarmListData"];
        NSMutableArray *alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
        AlarmObject *oldAlarmObject = [alarmList objectAtIndex:self.indexOfAlarmEdit];
        self.label = oldAlarmObject.label;
        self.datePicker.date = oldAlarmObject.timeToSetOff;
        self.notificationID = oldAlarmObject.notificationID;
        
        self.datePicker.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - UITableView DataSource...

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.editMode) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.backgroundColor = [UIColor blackColor];
    
    if (indexPath.section == 0) {
        UILabel *labelTextField = [[UILabel alloc] initWithFrame:CGRectMake(180, 4, 280, 35)];
        labelTextField.adjustsFontSizeToFitWidth = YES;
        labelTextField.textColor = [UIColor whiteColor];
        labelTextField.backgroundColor = [UIColor blackColor];
        [labelTextField setEnabled:YES];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = self.label;
            labelTextField.text = self.label;
        }
        [cell.contentView addSubview:labelTextField];
    }
    if (indexPath.section == 1) {
        cell.backgroundColor = [UIColor redColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"Delete this alram";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if(indexPath.row == 0) {
            UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            AlarmLabelEditVC *labelEditController = [mystoryboard instantiateViewControllerWithIdentifier:@"AlarmLabelEditVC"];
            
            labelEditController.delegate = self;
            labelEditController.label = self.label;
            
            [self presentViewController:labelEditController animated:YES completion:nil];
        }
    }
    else if(indexPath.section == 1) {
        NSLog(@"Are you sure to delete this alarm");
    }
}

- (void)CancelExistingNotification {
    //cancel alarm
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    
    for (int i=0; i<[eventArray count]; i++) {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"notificationID"]];
        
        if ([uid isEqualToString:[NSString stringWithFormat:@"%li",(long)self.notificationID]]) {
            [app cancelLocalNotification:oneEvent];
            break;
        }
    }
}

- (void)deleteSavedInfo {
    [self CancelExistingNotification];
    //delete alarm
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *alarmListData = [defaults objectForKey:@"AlarmListData"];
    NSMutableArray *alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
    [alarmList removeObjectAtIndex: self.indexOfAlarmEdit];
    NSData *alarmListData2 = [NSKeyedArchiver archivedDataWithRootObject:alarmList];
    [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListData"];
    
    [self performSegueWithIdentifier: @"AlarmListSegue" sender: self];
}

- (void)scheduleLocalNotificationWithDate:(NSDate *)fireDate atIndex:(int)indexOfObject {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    if (!localNotification)
        return;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh-mm -a";
    NSDate* date = [dateFormatter dateFromString:[dateFormatter stringFromDate:self.datePicker.date]];
    
    localNotification.repeatInterval = NSCalendarUnitDay;
    [localNotification setFireDate:date];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    // Setup alert notification
    [localNotification setAlertBody:@"Alarm" ];
    [localNotification setAlertAction:@"Open App"];
    [localNotification setHasAction:YES];
    
    NSLog(@"%@", date);
    //This array maps the alarms uid to the index of the alarm so that we can cancel specific local notifications
    
    NSNumber* uidToStore = [NSNumber numberWithInt:indexOfObject];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:uidToStore forKey:@"notificationID"];
    localNotification.userInfo = userInfo;
    NSLog(@"Uid Store in userInfo %@", [localNotification.userInfo objectForKey:@"notificationID"]);
    
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (int)getUniqueNotificationID {
    NSMutableDictionary * hashDict = [[NSMutableDictionary alloc]init];
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    
    for (int i=0; i<[eventArray count]; i++) {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSNumber *uid= [userInfoCurrent valueForKey:@"notificationID"];
        NSNumber * value =[NSNumber numberWithInt:1];
        [hashDict setObject:value forKey:uid];
    }
    for (int i=0; i<[eventArray count]+1; i++) {
        NSNumber * value = [hashDict objectForKey:[NSNumber numberWithInt:i]];
        if (!value) {
            return i;
        }
    }
    return 0;
}

- (void)updateLabelText:(NSString *)newLabel {
    self.label = newLabel;
    [self.editAlarmTbl reloadData];
}

- (IBAction)onCancelAlarm:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSaveAlarm:(id)sender {
    AlarmObject * newAlarmObject;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *alarmListData = [defaults objectForKey:@"AlarmListData"];
    NSMutableArray *alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
    
    if (!alarmList) {
        alarmList = [[NSMutableArray alloc]init];
    }
    
    if (self.editMode) {
        newAlarmObject = [alarmList objectAtIndex:self.indexOfAlarmEdit];
        
        [self CancelExistingNotification];
    } else {
        newAlarmObject = [[AlarmObject alloc]init];
        newAlarmObject.enabled = YES;
        newAlarmObject.notificationID = [self getUniqueNotificationID];
    }
    
    newAlarmObject.label = self.label;
    newAlarmObject.timeToSetOff = self.datePicker.date;
    newAlarmObject.enabled = YES;
    
    [self scheduleLocalNotificationWithDate:self.datePicker.date atIndex:newAlarmObject.notificationID];
    
    if (self.editMode == NO) {
        [alarmList addObject:newAlarmObject];
    }
    NSData *alarmListData2 = [NSKeyedArchiver archivedDataWithRootObject:alarmList];
    [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListData"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
