//
//  Tutorial-Screen-One-ViewController.h
//  Find my Airpods
//
//  Created by Raajit Sharma on 20/12/16.
//  Copyright © 2016 Deucks Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>

#define CHANGED_NAME_QUESTION 1

@interface Tutorial_Screen_One_ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *airpodsLeft;
@property (weak, nonatomic) IBOutlet UIImageView *airpodsRight;
@property (weak, nonatomic) IBOutlet UIImageView *airpodsCaseTop;
@property (weak, nonatomic) IBOutlet UIImageView *airpodsCaseBottom;
@property (weak, nonatomic) IBOutlet UIButton *unpairAirpods;

@end
