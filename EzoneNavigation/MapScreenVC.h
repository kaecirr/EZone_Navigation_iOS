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
#import <CoreLocation/CoreLocation.h>


@import IndoorAtlas;


@interface MapScreenVC : UIViewController <MKMapViewDelegate, IALocationManagerDelegate, NodesParserDelegate, CLLocationManagerDelegate> {
    
    id<IAFetchTask> floorPlanFetch;
    id<IAFetchTask> imageFetch;
    
    UIImage *fpImage;
    NSData *image;
    MKMapCamera *camera;
    Boolean updateCamera;
    
//    CLLocationManager *clLocationManager;
    NodesParser *nodesParser;
    
    NSMutableArray  *arrayOfNodesPathPoint;
    
}

@property(nonatomic, strong) IALocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MKPolyline *polyline;
@property (nonatomic, strong) MKPolylineView *polyLineView;

-(void) requestLocation;

@end
