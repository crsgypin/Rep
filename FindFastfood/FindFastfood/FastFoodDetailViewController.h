//
//  FastFoodDetailViewController.h
//  FindFastfood
//
//  Created by Gypin on 12/8/25.
//  Copyright (c) 2012年 Gypin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GoogleLocalConnection.h"

@interface FastFoodDetailViewController : UIViewController <UISplitViewControllerDelegate, MKMapViewDelegate, GoogleLocalConnectionDelegate, CLLocationManagerDelegate>
{
    GoogleLocalConnection *googleLocalConnection;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D userLocation;

}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@property (strong, nonatomic) NSString *fastFood;

- (void) getGoogleConnection;


@end
