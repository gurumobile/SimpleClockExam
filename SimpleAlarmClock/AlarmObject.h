//
//  AlarmObject.h
//  SimpleAlarmClock
//
//  Created by Bogdan on 10/23/16.
//  Copyright © 2016 Bogdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmObject : NSObject

@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSDate *timeToSetOff;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) int notificationID;

@end
