//
//  Tutorial-Screen-One-ViewController.m
//  Find my Airpods
//
//  Created by Raajit Sharma on 20/12/16.
//  Copyright © 2016 Deucks Pty Ltd. All rights reserved.
//

#import "Tutorial-Screen-One-ViewController.h"
#import "Constants.h"

#define UNLINKAIRPODS_QUESTION 2

@interface Tutorial_Screen_One_ViewController ()

@property NSUserDefaults *userDefaults;

@end

@implementation Tutorial_Screen_One_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([_userDefaults objectForKey:AIRPOD_SAVE_ID] == nil){
        _unpairAirpods.hidden = YES;
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    //Wait a second then do the floating animation.
    [self performSelector:@selector(showAirpodsFloat)
               withObject:nil
               afterDelay:1];

}

-(void)showAirpodsFloat{
    //Setting up variables
    CGFloat airpodsRightYPosition = _airpodsRight.layer.position.y;
    CGFloat airpodsLeftYPosition = _airpodsLeft.layer.position.y;
    int airpodsRightOffSet = 75;
    int airpodsLeftOffSet = 100;
    
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
- (IBAction)nextTutorialButton:(id)sender {
    
    if ([_userDefaults stringForKey:AIRPOD_SAVE_ID] != nil)
    {
        //Already added user
        [self performSegueWithIdentifier:@"mainScreenToAirpodSelectorSegue" sender:self];
    }
    else
    {
        //First time user, show them to add their device
        [self performSegueWithIdentifier:@"changedNameSegue" sender:self];
    }
    


}
- (IBAction)unPairAirpodsButton:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Are you sure?"
                         message:@"It's better to keep your Pods paired, it will be easier to find if you do lose them."
                          delegate:self
                         cancelButtonTitle:@"No"                                  otherButtonTitles:@"Yes", nil];
    alert.tag = UNLINKAIRPODS_QUESTION;
    [alert show];
    

}

-(void)deleteAllSettings{
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    _unpairAirpods.hidden = YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0 && alertView.tag == UNLINKAIRPODS_QUESTION) {
        //When clicked No


    }
    else if (buttonIndex == 1 && alertView.tag == UNLINKAIRPODS_QUESTION){
        //When clicked Yes remove all settings
        [self deleteAllSettings];
    }
    
}


@end
