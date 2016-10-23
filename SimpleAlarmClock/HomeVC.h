//
//  HomeVC.h
//  SimpleAlarmClock
//
//  Created by Bogdan on 10/23/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *hour1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *hour2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *colonLbl;
@property (weak, nonatomic) IBOutlet UILabel *min1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *min2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *halfDay;

@property (nonatomic, assign) BOOL alarmGoingOff;

- (IBAction)onAddAlarm:(id)sender;

@end
