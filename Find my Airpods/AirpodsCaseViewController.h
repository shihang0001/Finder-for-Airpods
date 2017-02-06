//
//  AirpodsCaseViewController.h
//  Find my Airpods
//
//  Created by Raajit Sharma on 21/12/16.
//  Copyright © 2016 Deucks Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirpodsCaseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *airpodsLeft;
@property (weak, nonatomic) IBOutlet UIImageView *airpodsRight;

@property BOOL isLeftPodMissing;
@property BOOL isRightPodMissing;
@property (weak, nonatomic) IBOutlet UILabel *titleText;

@property (weak, nonatomic) IBOutlet UILabel *subtitleText;

@end
