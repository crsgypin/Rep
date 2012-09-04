//
//  FastFoodDetailViewController.m
//  FindFastfood
//
//  Created by Gypin on 12/8/25.
//  Copyright (c) 2012年 Gypin. All rights reserved.
//

#import "FastFoodDetailViewController.h"

@interface FastFoodDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation FastFoodDetailViewController
@synthesize myMapView, fastFood;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
      //  self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

/*
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
}
*/

- (void)viewWillAppear:(BOOL)animated
//-(void)viewDidLoad
{
    self.navigationItem.title = self.title;
     
    [super viewDidLoad];
    NSLog(@"title:%@",self.title);
    [super viewWillAppear:animated];
	[myMapView setShowsUserLocation:YES];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    if(userLocation.latitude==0)
    {
        userLocation.longitude = newLocation.coordinate.longitude;
        userLocation.latitude = newLocation.coordinate.latitude;
        NSLog(@"userlocation.latitude in update:%f",userLocation.latitude);
        [self getGoogleConnection];
    }
//    [locationManager stopUpdatingLocation];
    
}

- (void) getGoogleConnection
{
    NSLog(@"userlocation:%f %f",userLocation.latitude, userLocation.longitude);
        
//    [myMapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(25.08, 121.60), MKCoordinateSpanMake(0.01, 0.01))];
    [myMapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(userLocation.latitude, userLocation.longitude), MKCoordinateSpanMake(0.01, 0.01))];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    fastFood = [defaults stringForKey:@"fastfood"];
    
	[myMapView setDelegate:self];
    
    googleLocalConnection = [[GoogleLocalConnection alloc] initWithDelegate:self];
    
    [googleLocalConnection getGoogleObjectsWithQuery:self.title andMapRegion:[myMapView region] andNumberOfResults:8 addressesOnly:YES andReferer:@"http://tw.yahoo.com"];

}


- (void) googleLocalConnection:(GoogleLocalConnection *)conn didFinishLoadingWithGoogleLocalObjects:(NSMutableArray *)objects andViewPort:(MKCoordinateRegion)region
{    
    if ([objects count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No matches found near this location" message:@"Try another place name or address (or move the map and try again)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
//        [alert release];
    }
    else {
        id userAnnotation=myMapView.userLocation;
        [myMapView removeAnnotations:myMapView.annotations];
         
        [myMapView addAnnotations:objects];
        if(userAnnotation!=nil)
			[myMapView addAnnotation:userAnnotation];

        MKCoordinateRegion userRegion;
        userRegion.center = userLocation;
        userRegion.span = MKCoordinateSpanMake(0.01, 0.01);
                
//        [myMapView setRegion:region];
        [myMapView setRegion:userRegion];
        
    }
}


- (void) googleLocalConnection:(GoogleLocalConnection *)conn didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error finding place - Try again" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"McDonald's", @"麥當勞");
    }
    return self;
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
