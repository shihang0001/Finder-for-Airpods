//
//  NameChooseViewController.m
//  Find my Airpods
//
//  Created by Raajit Sharma on 23/12/16.
//  Copyright © 2016 Deucks Pty Ltd. All rights reserved.
//

#import "NameChooseViewController.h"

@interface NameChooseViewController ()

@end

@implementation NameChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)noButtonPressed:(id)sender {
    //Next button Pressed
    [self performSegueWithIdentifier:@"namerToDeviceSelectorSegue" sender:self];

}
- (IBAction)yesButtonPressed:(id)sender {

    //Skip Button Pressed
    [self performSegueWithIdentifier:@"changeNameToAirpodSelection" sender:self];

    //[alert release];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
