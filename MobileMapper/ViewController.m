//
//  ViewController.m
//  MobileMapper
//
//  Created by Syed Amaanullah on 1/20/15.
//  Copyright (c) 2015 Syed Amaanullah. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *mobileMakersAnnotation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mobileMakersAnnotation = [[MKPointAnnotation alloc] init];
    self.mobileMakersAnnotation.title = @"Mobile Makers";
    self.mobileMakersAnnotation.subtitle = @"Where we make shit happen!";
    self.mobileMakersAnnotation.coordinate = CLLocationCoordinate2DMake(41.89373987, -87.63532979);
    [self.mapView addAnnotation:self.mobileMakersAnnotation];

    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:@"Grand Canyon" completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
            annotation.coordinate = place.location.coordinate;
            [self.mapView addAnnotation:annotation];
        }
    }];

    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.showsUserLocation = YES;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];

    if (annotation == mapView.userLocation) {
        return nil;
    }

    pin.canShowCallout = YES;

    if (annotation == self.mobileMakersAnnotation) {
        pin.image = [UIImage imageNamed:@"donbora"];
    }
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    CLLocationCoordinate2D centerCoordinate = view.annotation.coordinate;

    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;

    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = span;

    [self.mapView setRegion:region animated:YES];
}

@end
