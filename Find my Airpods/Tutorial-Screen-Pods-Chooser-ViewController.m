//
//  Tutorial-Screen-Pods-Chooser-ViewController.m
//  Find my Airpods
//
//  Created by Raajit Sharma on 20/12/16.
//  Copyright © 2016 Deucks Pty Ltd. All rights reserved.
//

#import "Tutorial-Screen-Pods-Chooser-ViewController.h"
#import "AirpodsCaseViewController.h"



@interface Tutorial_Screen_Pods_Chooser_ViewController ()



@end

@implementation Tutorial_Screen_Pods_Chooser_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _airpodsRightYPosition = _airpodsRight.layer.position.y;
    
    _airpodsLeftYPosition = _airpodsLeft.layer.position.y;
    
    _isLeftPodActive = NO;
    _isRightPodActive = NO;
    
    [self updateButtons];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self showAirpodsFloat];

}

-(void)showAirpodsFloat{
    //Setting up variables

    int airpodsRightOffSet = 75;
    int airpodsLeftOffSet = 75;
    
    //Animation for Left Earpod
    POPSpringAnimation *airpodsLeftFloat = [POPSpringAnimation animation];
    airpodsLeftFloat.property=[POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    airpodsLeftFloat.dynamicsFriction = 150;
    airpodsLeftFloat.toValue = @(_airpodsLeftYPosition - airpodsLeftOffSet);
    [_airpodsLeft pop_addAnimation:airpodsLeftFloat forKey:@"airpodsLeftFloat"];
    
    //Animation for Right EarPod
    POPSpringAnimation *airpodsRightFloat = [POPSpringAnimation animation];
    airpodsRightFloat.property=[POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    airpodsRightFloat.dynamicsFriction = 150;
    airpodsRightFloat.toValue = @(_airpodsRightYPosition - airpodsRightOffSet);
    [_airpodsRight pop_addAnimation:airpodsRightFloat forKey:@"airpodsRightFloat"];
    
    
}

-(void)updateButtons{
    if (_isLeftPodActive || _isRightPodActive)
    {
        _nextButton.alpha = 1;
        _nextButton.enabled = YES;
        

    }
    else
    {
        _nextButton.alpha = 0.3;
        _nextButton.enabled = NO;
        _airpodsStatus.text = @"";
    }
    
    if (_isLeftPodActive && _isRightPodActive)
    {
        _airpodsStatus.text = @"Both Pods are missing.";
    }
    else if (_isRightPodActive)
    {
        _airpodsStatus.text = @"Right Pod is missing.";
    }
    else if (_isLeftPodActive)
    {
        _airpodsStatus.text = @"Left Pod is missing.";
    }
    
}

- (IBAction)leftAirpodPressed:(id)sender {
    
    int airpodsLeftOffSet;
    if (_isLeftPodActive)
    {
        airpodsLeftOffSet = 75;
        _isLeftPodActive = NO;
    }
    else
    {
        airpodsLeftOffSet = 140;
        _isLeftPodActive = YES;
    }
    
    //Animate the left airpod to raise.
    POPSpringAnimation *airpodsLeftFloatUp = [POPSpringAnimation animation];
    airpodsLeftFloatUp.property=[POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    airpodsLeftFloatUp.dynamicsFriction = 100;
    airpodsLeftFloatUp.toValue = @(_airpodsLeftYPosition - airpodsLeftOffSet);
    [_airpodsLeft pop_addAnimation:airpodsLeftFloatUp forKey:@"airpodsLeftFloatUp"];

    [self updateButtons];
    
}
- (IBAction)rightAirpodPressed:(id)sender {
    int airpodsRightOffSet;
    if (_isRightPodActive)
    {
        airpodsRightOffSet = 75;
        _isRightPodActive = NO;
    }
    else
    {
        airpodsRightOffSet = 140;
        _isRightPodActive = YES;
    }
    
    //Animate the left airpod to raise.
    POPSpringAnimation *airpodsRightFloatUp = [POPSpringAnimation animation];
    airpodsRightFloatUp.property=[POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    airpodsRightFloatUp.dynamicsFriction = 100;
    airpodsRightFloatUp.toValue = @(_airpodsLeftYPosition - airpodsRightOffSet);
    [_airpodsRight pop_addAnimation:airpodsRightFloatUp forKey:@"airpodsRightFloatUp"];

    [self updateButtons];
}

- (IBAction)nextButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"airpodsCaseTutorial" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Check if the segue is to thje finder app
    if ([segue.identifier isEqualToString:@"airpodsCaseTutorial"])
    {
        NSLog(@"airpodsCaseTutorial segueing");
        
        AirpodsCaseViewController *airPodsCase = [segue destinationViewController];
        airPodsCase.isLeftPodMissing = _isLeftPodActive;
        airPodsCase.isRightPodMissing = _isRightPodActive;
        
        //[airPodsCase setMy]
        
        
    }
}

@end
