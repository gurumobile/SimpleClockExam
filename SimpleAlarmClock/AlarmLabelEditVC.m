//
//  AlarmLabelEditVC.m
//  SimpleAlarmClock
//
//  Created by Bogdan on 10/23/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

#import "AlarmLabelEditVC.h"

@interface AlarmLabelEditVC ()

@end

@implementation AlarmLabelEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - UITableView DataSource...

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.alarmEditTbl dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.backgroundColor = [UIColor blackColor];
        if ([indexPath section] == 0) {
            UITextField *labelTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, 4, 280, 35)];
            labelField = labelTextField;
            labelTextField.adjustsFontSizeToFitWidth = YES;
            labelTextField.textColor = [UIColor greenColor];
            labelTextField.backgroundColor = [UIColor clearColor];
            labelTextField.text = self.label;
            labelTextField.returnKeyType = UIReturnKeyDone;
            labelTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            labelTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
            labelTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            labelTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            labelTextField.keyboardType = UIKeyboardTypeDefault;
            [labelTextField becomeFirstResponder];
            labelTextField.tag = 0;
            labelTextField.delegate = self;
            labelTextField.clearButtonMode = UITextFieldViewModeAlways;
            [labelTextField setEnabled: YES];
            [cell.contentView addSubview:labelTextField];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cellSelected = [tableView cellForRowAtIndexPath: indexPath];
    UITextField *textField = [[cellSelected.contentView subviews] objectAtIndex: 0];
    [textField becomeFirstResponder];
    
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
}

#pragma mark -
#pragma mark - UITextField Delegate...

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self onSaveAlarm:nil];
    return YES;
}

- (IBAction)onSaveAlarm:(id)sender {
    if ([self.delegate respondsToSelector:@selector(updateLabelText:)]) {
        [self.delegate updateLabelText:labelField.text];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
