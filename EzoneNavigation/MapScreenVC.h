//
//  MapScreenVC.h
//  EzoneNavigation
//
//  Created by Keyur Modi on 9/9/17.
//  Copyright © 2017 Keyur Modi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "CalibrationIndicator.h"
#import <MapKit/MapKit.h>
#import "NodesParser.h"

@import IndoorAtlas;


@interface MapScreenVC : UIViewController <MKMapViewDelegate, IALocationManagerDelegate> {
    
    id<IAFetchTask> floorPlanFetch;
    id<IAFetchTask> imageFetch;
    
    UIImage *fpImage;
    NSData *image;
    MKMapCamera *camera;
    Boolean updateCamera;
    
    NodesParser *nodesParser;
}

@property(nonatomic, strong) IALocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;

-(void) requestLocation;

@end
