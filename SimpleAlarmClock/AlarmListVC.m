//
//  AlarmListVC.m
//  SimpleAlarmClock
//
//  Created by Bogdan on 10/23/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

#import "AlarmListVC.h"
#import "AlarmObject.h"
#import "EditAlarmVC.h"

@interface AlarmListVC ()

@end

@implementation AlarmListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.alarmListTbl.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.alarmListTbl.rowHeight = 70;
    self.alarmListTbl.backgroundColor = [UIColor clearColor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *alarmListData = [defaults objectForKey:@"AlarmListData"];
    self.listOfAlarms = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITableView DataSource...

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.listOfAlarms) {
        return [self.listOfAlarms count];
    } else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDateFormatter * dateReader = [[NSDateFormatter alloc] init];
    [dateReader setDateFormat:@"hh:mm a"];
    AlarmObject *currentAlarm = [self.listOfAlarms objectAtIndex:indexPath.row];
    
    NSString *label = currentAlarm.label;
    BOOL enabled = currentAlarm.enabled;
    NSString *date = [dateReader stringFromDate:currentAlarm.timeToSetOff];
    
    UILabel *topLabel;
    UILabel *bottomLabel;
    UISwitch *enabledSwitch;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CellIdentifier];
        topLabel = [[UILabel alloc] initWithFrame:CGRectMake(14,5,170,40)];
        [cell.contentView addSubview:topLabel];
        
        topLabel.backgroundColor = [UIColor grayColor];
        topLabel.textColor = [UIColor whiteColor];
        topLabel.highlightedTextColor = [UIColor greenColor];
        topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] +2];
        
        bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(14,30,170,40)];
        [cell.contentView addSubview:bottomLabel];
        
        bottomLabel.backgroundColor = [UIColor clearColor];
        bottomLabel.textColor = [UIColor blackColor];
        bottomLabel.highlightedTextColor = [UIColor whiteColor];
        bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
        enabledSwitch = [[UISwitch alloc]
                         initWithFrame:
                         CGRectMake(200,20,170,40)];
        enabledSwitch.tag = indexPath.row;
        [enabledSwitch addTarget:self
                          action:@selector(toggleAlarmEnabledSwitch:)
                forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:enabledSwitch];
        
        [enabledSwitch setOn:enabled];
        topLabel.text = date;
        bottomLabel.text = label;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"listToEdit" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"listToEdit"]) {
        EditAlarmVC *controller = (EditAlarmVC *)segue.destinationViewController;
        controller.indexOfAlarmEdit = self.alarmListTbl.indexPathForSelectedRow.row;
        controller.editMode = YES;
    }
}

-(void)toggleAlarmEnabledSwitch:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    
    if (mySwitch.isOn == NO) {
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        AlarmObject *currentAlarm = [self.listOfAlarms objectAtIndex:mySwitch.tag];
        currentAlarm.enabled = NO;
        for (int i=0; i<[eventArray count]; i++) {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"notificationID"]];
            
            if ([uid isEqualToString:[NSString stringWithFormat:@"%li",(long)mySwitch.tag]]) {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                break;
            }
        }
        
    }
    else if(mySwitch.isOn == YES) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        AlarmObject *currentAlarm = [self.listOfAlarms objectAtIndex:mySwitch.tag];
        currentAlarm.enabled = YES;
        
        if (!localNotification)
            return;

        localNotification.repeatInterval = NSCalendarUnitDay;
        [localNotification setFireDate:currentAlarm.timeToSetOff];
        [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
        // Setup alert notification
        [localNotification setAlertBody:@"Alarm" ];
        [localNotification setAlertAction:@"Open App"];
        [localNotification setHasAction:YES];
        
        NSNumber* uidToStore = [NSNumber numberWithInt:currentAlarm.notificationID];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:uidToStore forKey:@"notificationID"];
        localNotification.userInfo = userInfo;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    NSData *alarmListData2 = [NSKeyedArchiver archivedDataWithRootObject:self.listOfAlarms];
    [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListData"];
}

- (IBAction)onAddAlarm:(id)sender {
    [self performSegueWithIdentifier:@"listToEdit" sender:nil];
}

@end
