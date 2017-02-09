//
//  AirpodsCaseViewController.m
//  Find my Airpods
//
//  Created by Raajit Sharma on 21/12/16.
//  Copyright © 2016 Deucks Pty Ltd. All rights reserved.
//

#import "AirpodsCaseViewController.h"
#import "FinderViewController.h"


@interface AirpodsCaseViewController ()

@end

@implementation AirpodsCaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%d", _isRightPodMissing);
    NSLog(@"%d", _isLeftPodMissing);
    


    //Set the visbilty of the earpods
    _airpodsLeft.hidden = _isLeftPodMissing ? YES : NO;
    _airpodsRight.hidden = _isRightPodMissing ? YES : NO;

    [self setupLabels];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self showAirpodsFloat];
}

-(void)setupLabels{
    if (_isLeftPodMissing && _isRightPodMissing){
        _titleText.text = @"Please open Pods case.";
        _subtitleText.text = @"Use a device in which the Pods are paired to. Walk slowly around the area you last saw it. Place found Pod back in case to find the next missing Pod.";
    }
    else if (_isLeftPodMissing)
    {
        _titleText.text = @"Dock right Pod and close case.";
        _subtitleText.text = @"Use a device in which the Pods are paired to. Walk slowly around the area you last saw it. Do not take right Pod out from case whilst trying to find left Pod.";
    }
    else if (_isRightPodMissing)
    {
        _titleText.text = @"Dock left Pod and close case.";
        _subtitleText.text = @"Use a device in which the Pods are paired to. Walk slowly around the area you last saw it. Do not take left Pod out from case whilst trying to find right Pod.";
    }
}


-(void)showAirpodsFloat{
    //Setting up variables
    CGFloat airpodsRightYPosition = _airpodsRight.layer.position.y;
    CGFloat airpodsLeftYPosition = _airpodsLeft.layer.position.y;
    int airpodsRightOffSet = 75;
    int airpodsLeftOffSet = 75;
    
    //Animation for Left Earpod
    POPSpringAnimation *airpodsLeftFloat = [POPSpringAnimation animation];
    airpodsLeftFloat.property=[POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    airpodsLeftFloat.dynamicsFriction = 150;
    airpodsLeftFloat.toValue = @(airpodsLeftYPosition + airpodsLeftOffSet);
    [_airpodsLeft pop_addAnimation:airpodsLeftFloat forKey:@"airpodsLeftFloat"];
    
    //Animation for Right EarPod
    POPSpringAnimation *airpodsRightFloat = [POPSpringAnimation animation];
    airpodsRightFloat.property=[POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    airpodsRightFloat.dynamicsFriction = 150;
    airpodsRightFloat.toValue = @(airpodsRightYPosition + airpodsRightOffSet);
    [_airpodsRight pop_addAnimation:airpodsRightFloat forKey:@"airpodsRightFloat"];
    
    
}

- (IBAction)nextButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"airpodsToFinderSegue" sender:sender];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Check if the segue is to thje finder app
    if ([segue.identifier isEqualToString:@"airpodsToFinderSegue"])
    {
        FinderViewController *finderVC = [segue destinationViewController];
        finderVC.isRightPodMissing = _isRightPodMissing;
        finderVC.isLeftPodMissing = _isLeftPodMissing;
        
        //Set the pod image to hidden if the pod is missing.
        [finderVC.leftAirpod setHidden:_isLeftPodMissing];
        [finderVC.rightAirpod setHidden:_isRightPodMissing];

        
    }
}

@end
