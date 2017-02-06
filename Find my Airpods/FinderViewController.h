//
//  FinderViewController.h
//  Find my Airpods
//
//  Created by Raajit Sharma on 21/12/16.
//  Copyright © 2016 Deucks Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>
#import <MBCircularProgressBar/MBCircularProgressBarView.h>



@interface FinderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *bottomAirpod;
@property (weak, nonatomic) IBOutlet UIImageView *leftAirpod;
@property (weak, nonatomic) IBOutlet UIImageView *rightAirpod;
@property (weak, nonatomic) IBOutlet UIImageView *topAirpod;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressCircle;

@property POPSpringAnimation *findingAnimation;

@property (weak, nonatomic) IBOutlet UIImageView *blackDot;

@property (weak, nonatomic) IBOutlet UILabel *airpodName;

@property BOOL isLeftPodMissing;
@property BOOL isRightPodMissing;
@property (weak, nonatomic) IBOutlet UIButton *foundItButton;
@property (weak, nonatomic) IBOutlet UILabel *titleText;


@end
