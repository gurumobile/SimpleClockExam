//
//  HomeVC.m
//  SimpleAlarmClock
//
//  Created by Bogdan on 10/23/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setting Timer...
    [self timerAction];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    NSTimer  *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    [runLoop addTimer:timer forMode:NSRunLoopCommonModes];
    [runLoop addTimer:timer forMode:UITrackingRunLoopMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.hour1Lbl.font = [UIFont fontWithName:@"digital-7" size:90];
    self.hour2Lbl.font = [UIFont fontWithName:@"digital-7" size:90];
    self.colonLbl.font = [UIFont fontWithName:@"digital-7" size:90];
    self.min1Lbl.font = [UIFont fontWithName:@"digital-7" size:90];
    self.min2Lbl.font = [UIFont fontWithName:@"digital-7" size:90];
}

- (IBAction)onAddAlarm:(id)sender {
    [self performSegueWithIdentifier:@"toAlarmList" sender:nil];
}

- (void)timerAction {
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *hourMinuteSecond = [dateFormatter stringFromDate:date];
    
    self.hour1Lbl.text = [hourMinuteSecond substringWithRange:NSMakeRange(0, 1)];
    self.hour2Lbl.text = [hourMinuteSecond substringWithRange:NSMakeRange(1, 1)];
    self.min1Lbl.text = [hourMinuteSecond substringWithRange:NSMakeRange(3, 1)];
    self.min2Lbl.text = [hourMinuteSecond substringWithRange:NSMakeRange(4, 1)];
    self.halfDay.text = [hourMinuteSecond substringWithRange:NSMakeRange(6, 2)];
}

#pragma mark -
#pragma mark - UnwindSegue...

- (IBAction)unwindHomeVC:(UIStoryboardSegue *)unwindSegue {
    
}

@end
