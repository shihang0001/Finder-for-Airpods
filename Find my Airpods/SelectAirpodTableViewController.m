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

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Bluetooth Setup

    // Start up the CBCentralManager
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    // And somewhere to store the incoming data
    _data = [[NSMutableData alloc] init];
    


    
    

}

-(void)addNewBluetoothItem:(NSString *)name uuid:(NSString *)uuid{
    
    //NSLog(uuid);

    //Loop if not -- This can be dont better
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
    
    //NSLog(@"Scanning started");
    
    
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
    
    //If the peripheral isnt empty
    if (peripheral.name != NULL)
    {

        
        [self addNewBluetoothItem:peripheral.name.lowercaseString uuid:[NSString stringWithFormat:@"%@",peripheral.identifier]];
        //NSLog(@"Discovered %@ at %@ - updated %f -- UUID %@", peripheral.name, RSSI, updatedRSSIValue, peripheral.debugDescription);
        //NSLog(@"p data %ld", (long)peripheral.state);
        
    }

    if ([peripheral.name.lowercaseString containsString:AIRPODS_ID]){
        

        
        

        

        
        
        
    }
    else
    {

        
        
    }
    
    [self scan];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
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
