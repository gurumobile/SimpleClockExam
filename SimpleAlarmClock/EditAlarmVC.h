//
//  EditAlarmVC.h
//  SimpleAlarmClock
//
//  Created by Bogdan on 10/23/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmLabelEditVC.h"

@interface EditAlarmVC : UIViewController <AlarmLabelEditVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *editAlarmTbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, assign) NSInteger indexOfAlarmEdit;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, assign) BOOL editMode;
@property (nonatomic, assign) NSInteger notificationID;

- (IBAction)onCancelAlarm:(id)sender;
- (IBAction)onSaveAlarm:(id)sender;

@end
