//
//  FinalViewController.m
//  Find my Airpods
//
//  Created by Raajit Sharma on 22/12/16.
//  Copyright © 2016 Deucks Pty Ltd. All rights reserved.
//

#import "FinalViewController.h"

@interface FinalViewController ()

@end

@implementation FinalViewController

int const APPSTORE_ID = 1187777468;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startAgainText:(id)sender {
    [self performSegueWithIdentifier:@"finishToMainMenuSegue" sender:self];
}
- (IBAction)rateAppButtonPressed:(id)sender {
    NSString *appID = [NSString stringWithFormat:@"%d", APPSTORE_ID];
    NSString *str;
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (ver >= 7.0 && ver < 7.1) {
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appID];
    } else if (ver >= 8.0) {
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",appID];
    } else {
        str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",appID];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
