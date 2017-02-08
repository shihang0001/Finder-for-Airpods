//
//  SelectAirpodTableViewController.m
//  Find my Airpods
//
//  Created by Raajit Sharma on 24/12/16.
//  Copyright © 2016 Deucks Pty Ltd. All rights reserved.
//

#import "SelectAirpodTableViewController.h"
#import "BLDataModel.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import <POP/POP.h>

#import <MediaPlayer/MediaPlayer.h>
#import "TransferService.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <AudioToolbox/AudioServices.h>
#import "Constants.h"

#define AIRPODS_ID @"airpods"
#define AIRPODSQUESTION_ID 1

@interface SelectAirpodTableViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData         *data;

@property NSUserDefaults *userDefaults;


@property NSMutableArray *bleItems;
@property BLDataModel *currentSelection;


@end

@implementation SelectAirpodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _bleItems = [[NSMutableArray alloc] init];

    // Start up the CBCentralManager
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    // And somewhere to store the incoming data
    _data = [[NSMutableData alloc] init];

}

-(void)addNewBluetoothItem:(NSString *)name uuid:(NSString *)uuid{
    
    //NSLog(uuid);

    //Loop if not -- This can be done better
    for (BLDataModel *bl in [_bleItems reverseObjectEnumerator])
    {
        //If the UUID does exists then return method
        if ([bl.UUID isEqualToString:uuid])
        {
            return;
        }

    }
    
    //Add item
    BLDataModel *newItem = [[BLDataModel alloc] init];
    newItem.blName = name;
    newItem.UUID = uuid;
    [_bleItems addObject:newItem];
    
    //reload data
    [self.tableView reloadData];
    
    
    //If the data contains airpods, then add automatically
    if ([name.lowercaseString containsString:AIRPODS_ID])
    {
        BLDataModel *dataModel = [[BLDataModel alloc] init];
        dataModel.blName = name;
        dataModel.UUID = uuid;
        _currentSelection = dataModel;
        [self addAirpodToMemory];
    }

    
}


#pragma mark - Central Methods



/** centralManagerDidUpdateState is a required protocol method.

 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
        //HA!
        return;
    }
    
    
    
    // The state must be CBCentralManagerStatePoweredOn...=
    // ... so start scanning
    [self scan];
    
}



/** 
    Scan for peripherals
    The Airpods doesn't have a special UUID we need to scan for. Rather we can scan for all Keys.
*/
- (void)scan
{
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    
    [self.centralManager scanForPeripheralsWithServices:nil options:options];
    
    NSLog(@"Bluetooth Scanning started");
    
    
}


/** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.

 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //Calculate the RSSI value, then create the offset so we can
    //represent that on the guage
    
    //We really dont need this here though.
    
    double dRSSI = [RSSI doubleValue];
    double updatedRSSIValue = 127 - (dRSSI * -1)+15;
    
    NSLog(@"state %@", peripheral.debugDescription);
    
    
    //If the peripheral isnt empty
    if (peripheral.name != NULL)
    {
        //Add the peripheral to the list
        [self addNewBluetoothItem:peripheral.name.lowercaseString uuid:[NSString stringWithFormat:@"%@",peripheral.identifier]];
        
    }
    
    //Start the scan again
    [self scan];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _bleItems.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    BLDataModel *tableData = [_bleItems objectAtIndex:indexPath.row];
    
    cell.textLabel.text = tableData.blName;

    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Devices Around You";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    /*UIAlertView *messageAlert = [[UIAlertView alloc]
     initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];*/
    _currentSelection = _bleItems[indexPath.row];
    NSString *currentBLE = _currentSelection.blName;
    

    
    
    //Ask for permision
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:[NSString stringWithFormat:@"Are you sure '%@' are your Pods?", _currentSelection.blName]
                          message:@""
                          delegate:self
                          cancelButtonTitle:@"No"                                  otherButtonTitles:@"Yes", nil];
    alert.tag = AIRPODSQUESTION_ID;
    [alert show];
    

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //[self performSegueWithIdentifier:@"findFitbit" sender:self];
    
}

-(void)addAirpodToMemory{
    NSLog(@"Add to memory");
    [_userDefaults setObject:_currentSelection.blName forKey:AIRPOD_SAVE_ID];
    [_userDefaults setObject:_currentSelection.UUID forKey:AIRPOD_UUID_SAVE_ID];

    [_userDefaults synchronize];

    [self performSegueWithIdentifier:@"pairSelectorToAirpodsSelectorSegue" sender:self];
    
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0 && alertView.tag == AIRPODSQUESTION_ID) {
        //When clicked No
        
        
    }
    else if (buttonIndex == 1 && alertView.tag == AIRPODSQUESTION_ID){
        //When clicked Yes,
        [self addAirpodToMemory];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    //View new settings everytime view appears
    _userDefaults = [NSUserDefaults standardUserDefaults];
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self scan];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.centralManager stopScan];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

@end
