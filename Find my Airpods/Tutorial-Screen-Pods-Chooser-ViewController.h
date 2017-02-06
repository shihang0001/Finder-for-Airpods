//
//  Tutorial-Screen-Pods-Chooser-ViewController.h
//  Find my Airpods
//
//  Created by Raajit Sharma on 20/12/16.
//  Copyright © 2016 Deucks Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>


@interface Tutorial_Screen_Pods_Chooser_ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *airpodsLeft;
@property (weak, nonatomic) IBOutlet UIImageView *airpodsRight;
@property (weak, nonatomic) IBOutlet UIImageView *airpodsCaseTop;
@property (weak, nonatomic) IBOutlet UIImageView *airpodsCaseBottom;

@property CGFloat airpodsRightYPosition;
@property CGFloat airpodsLeftYPosition;

@property BOOL isLeftPodActive;

@property BOOL isRightPodActive;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *airpodsStatus;

@end
