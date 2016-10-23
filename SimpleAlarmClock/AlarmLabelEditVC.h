//
//  AlarmLabelEditVC.h
//  SimpleAlarmClock
//
//  Created by Bogdan on 10/23/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlarmLabelEditVCDelegate <NSObject>

- (void)updateLabelText:(NSString *)newLabel;

@end

@interface AlarmLabelEditVC : UIViewController <UITextFieldDelegate> {
    UITextField *labelField;
}

@property (weak, nonatomic) IBOutlet UITableView *alarmEditTbl;
@property (nonatomic, strong) NSString *label;
@property (unsafe_unretained) id <AlarmLabelEditVCDelegate> delegate;

- (IBAction)onSaveAlarm:(id)sender;

@end
