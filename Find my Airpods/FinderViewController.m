//
//  FinderViewController.m
//  Find my Airpods
//
//  Created by Raajit Sharma on 21/12/16.
//  Copyright © 2016 Deucks Pty Ltd. All rights reserved.
//

#import "FinderViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import <POP/POP.h>

#import <MediaPlayer/MediaPlayer.h>
#import "TransferService.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <AudioToolbox/AudioServices.h>
#import "Constants.h"

#define AIRPODS_ID @"airpods"

@interface FinderViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData         *data;

@property NSTimer *_timer;
@property BOOL timerStarted;

@property NSUserDefaults *userDefaults;
@property NSString *defaultDeviceName;
@property NSString *defaultUUID;

@end

@implementation FinderViewController


static const int GENERAL_OFFSET = 75;

double const SEARCH_OFFSET = 5.0f;

CGFloat _airpodsYPosition;
CGFloat _progressYPosition;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _foundItButton.enabled = NO;
    _foundItButton.alpha = 0.4;
    
    _airpodsYPosition = _topAirpod.layer.position.y;
    _progressYPosition =  _progressCircle.layer.position.y;
    
    _leftAirpod.hidden = _isLeftPodMissing ? YES : NO;
    _rightAirpod.hidden = _isRightPodMissing ? YES : NO;
    
    
    //Bluetooth Setup
    
    // Start up the CBCentralManager
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    // And somewhere to store the incoming data
    _data = [[NSMutableData alloc] init];
    
    //Sort all the spinning animation
    _findingAnimation = [self.progressCircle.layer pop_animationForKey:@"rotate"];
    _findingAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    _findingAnimation.toValue = @(2 * M_PI);

    //Start 'search' spinning
    _findingAnimation.springSpeed = 2;
    _findingAnimation.springBounciness = 1;
    _findingAnimation.repeatForever=YES;
    [self.progressCircle.layer pop_addAnimation:_findingAnimation forKey:@"rotate"];
    
    _timerStarted = false;
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    _defaultDeviceName = [_userDefaults objectForKey:AIRPOD_SAVE_ID];
    _defaultUUID = [_userDefaults objectForKey:AIRPOD_UUID_SAVE_ID];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self performSelector:@selector(animateAirpodsDown) withObject:nil afterDelay:1.0f];
    [self performSelector:@selector(animatePodCaseDown) withObject:nil afterDelay:1.0f];
    
    //Start Scan
    [self scan];
    NSLog(@"Scanning started");
}


- (void)viewWillDisappear:(BOOL)animated
{
    // Don't keep it going while we're not showing.
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    [super viewWillDisappear:animated];
}


#pragma mark - Central Methods



/** centralManagerDidUpdateState is a required protocol method.
 *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
 *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
 *  the Central is ready to be used.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
        return;
    }
    
    
    
    // The state must be CBCentralManagerStatePoweredOn...
    
    // ... so start scanning
    [self scan];
    
}



/** Scan for peripherals - specifically for our service's 128bit CBUUID
 */
- (void)scan
{
    //[self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"180A"]]
    //                                            options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    
    [self.centralManager scanForPeripheralsWithServices:nil options:options];
    
    //NSLog(@"%@", [self.centralManager retrieveConnectedPeripheralsWithServices:@[CBUUID UUIDWithString:@"180A"]]);
    
    NSLog(@"Scanning started");
    
    
}


/** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
 *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
 *  we start the connection process
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{

    
    double dRSSI = [RSSI doubleValue];
    
    double updatedRSSIValue = 127 - (dRSSI * -1)+15;
    
    
    //NSLog(@"state %@", peripheral.debugDescription);
    

    NSString *deviceUUID = [NSString stringWithFormat:@"%@", peripheral.identifier];
    
    
    if ([deviceUUID isEqualToString:_defaultUUID]){
        
        _airpodName.text = [NSString stringWithFormat:@"%@", peripheral.name];
        
        //Do alpha change on dot
        _blackDot.alpha = 0.3;
        POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
        basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        basicAnimation.duration = 2;
        basicAnimation.toValue= @(1); // scale from 0 to 1
        [_blackDot pop_addAnimation:basicAnimation forKey:@"alphachange"];
        
        
        
        NSLog(@"Discovered %@ at %@ - updated %f -- UUID %@", peripheral.name, RSSI, updatedRSSIValue, peripheral.debugDescription);
        NSLog(@"p data %ld", (long)peripheral.state);
        
        _foundItButton.enabled = YES;
        _foundItButton.alpha = 1;
        

        
        NSLog(@"Airpods Found");
        //
        
        if (updatedRSSIValue >= 100){
            [UIView animateWithDuration:1.f animations:^{
                self.progressCircle.value = 100;
            }];
        }
        else {
            [UIView animateWithDuration:1.f animations:^{
                self.progressCircle.value = updatedRSSIValue;
            }];
        }

        
        _findingAnimation.toValue = @(0);
        _findingAnimation.repeatForever=YES;
        [self.progressCircle.layer pop_addAnimation:_findingAnimation forKey:@"rotate"];

        
       [self updateTitleTextRSSI:updatedRSSIValue];
        
        //End the timer when the airpod is found
        [self endTimer];

    }
    else
    {
        //Check if timer has been started, then start timer
        if (!_timerStarted)
        {
            [self startTimer];
        }
        



        
    }
    
    [self scan];
    
    
    
}

-(void)startTimer{
    if (!__timer) {
        __timer = [NSTimer scheduledTimerWithTimeInterval:SEARCH_OFFSET
                                                  target:self
                                                selector:@selector(startRefreshingAnimation)
                                                userInfo:nil
                                                 repeats:NO];
    }
    _timerStarted = YES;
}

-(void)endTimer{
    if ([__timer isValid]) {
        [__timer invalidate];
    }
    __timer = nil;
    _timerStarted = NO;
}

-(void)startRefreshingAnimation{
    //Start spinning the circle
    _findingAnimation.toValue = @(2 * M_PI);
    _findingAnimation.repeatForever=YES;
    [self.progressCircle.layer pop_addAnimation:_findingAnimation forKey:@"rotate"];
    
    [UIView animateWithDuration:0.1f animations:^{
        self.progressCircle.value = 0;
    }];
    
    _titleText.text = @"Searching ...";
}

-(void)updateTitleTextRSSI:(double)RSSI{
    if (RSSI < 50)
    {
        _titleText.text = @"Walk around here ...";
    }
    else if (RSSI <= 80)
    {
        _titleText.text = @"You're getting closer ...";
    }
    else
    {
        _titleText.text = @"It's around here ...";
    }

}


//Method for animating the Earpods only
-(void)animateAirpodsDown{
    

    // Set Greater off sets when the user is missing specific pod
    
    int airpodsRightOffSet = _isRightPodMissing ? 150 : 75;
    int airpodsLeftOffSet = _isLeftPodMissing ? 150 : 75;
    
    
    
    //Animation for Left Earpod
    POPSpringAnimation *airpodsLeftFloat = [POPSpringAnimation animation];
    airpodsLeftFloat.property=[POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    airpodsLeftFloat.dynamicsFriction = 150;
    airpodsLeftFloat.toValue = @(_airpodsYPosition + airpodsLeftOffSet);
    [_leftAirpod pop_addAnimation:airpodsLeftFloat forKey:@"airpodsLeftFloat"];
    
    //Animation for Right EarPod
    POPSpringAnimation *airpodsRightFloat = [POPSpringAnimation animation];
    airpodsRightFloat.property=[POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    airpodsRightFloat.dynamicsFriction = 150;
    airpodsRightFloat.toValue = @(_airpodsYPosition + airpodsRightOffSet);
    [_rightAirpod pop_addAnimation:airpodsRightFloat forKey:@"airpodsRightFloat"];
    

}

//Method for animating the earpods case only
-(void)animatePodCaseDown{

    
    //Animate Bottom Earpod
    POPSpringAnimation *airpodsBottomFloat = [POPSpringAnimation animation];
    airpodsBottomFloat.property=[POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    airpodsBottomFloat.dynamicsFriction = 150;
    airpodsBottomFloat.toValue = @(_airpodsYPosition + GENERAL_OFFSET);
    [_bottomAirpod pop_addAnimation:airpodsBottomFloat forKey:@"airpodsBottomFloat"];
    
    //Animate Top Earpod
    POPSpringAnimation *airpodsTopFloat = [POPSpringAnimation animation];
    airpodsTopFloat.property=[POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    airpodsTopFloat.dynamicsFriction = 150;
    airpodsTopFloat.toValue = @(_airpodsYPosition + GENERAL_OFFSET);
    [_topAirpod pop_addAnimation:airpodsTopFloat forKey:@"airpodsTopFloat"];
    
    //Animate the Progress Bar
    POPSpringAnimation *circleProgressFloat = [POPSpringAnimation animation];
    circleProgressFloat.property=[POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    circleProgressFloat.dynamicsFriction = 75;
    circleProgressFloat.toValue = @(_progressYPosition + GENERAL_OFFSET);
    [_progressCircle pop_addAnimation:circleProgressFloat forKey:@"circleProgressFloat"];
    

    
    //Animate Text Part
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    basicAnimation.duration = 2;
    basicAnimation.toValue= @(1); // scale from 0 to 1
    [_titleText pop_addAnimation:basicAnimation forKey:@"alphachange"];

}


- (IBAction)foundButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"finalScreenSegue" sender:self];
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
