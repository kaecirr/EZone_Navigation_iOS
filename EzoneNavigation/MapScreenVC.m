//
//  MapScreenVC.m
//  EzoneNavigation
//
//  Created by Keyur Modi on 9/9/17.
//  Copyright © 2017 Keyur Modi. All rights reserved.
//

#import "MapScreenVC.h"
#import "ApiKeys.h"


#define degreesToRadians(x) (M_PI * x / 180.0)

@interface MapOverlay : NSObject <MKOverlay>

- (id)initWithFloorPlan:(IAFloorPlan *)floorPlan andRotatedRect:(CGRect)rotated;

- (MKMapRect)boundingMapRect;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property CLLocationCoordinate2D center;
@property MKMapRect rect;

@end

@implementation MapOverlay

- (id)initWithFloorPlan:(IAFloorPlan *)floorPlan andRotatedRect:(CGRect)rotated
{
    self = [super init];
    if (self != nil) {
        
        _center = floorPlan.center;
        MKMapPoint topLeft = MKMapPointForCoordinate(floorPlan.topLeft);
        _rect = MKMapRectMake(topLeft.x + rotated.origin.x, topLeft.y + rotated.origin.y,
                              rotated.size.width, rotated.size.height);
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    return self.center;
}

- (MKMapRect)boundingMapRect {
    return _rect;
}

@end

@interface MapOverlayRenderer : MKOverlayRenderer

@property (nonatomic, strong, readwrite) IAFloorPlan *floorPlan;
@property (strong, readwrite) UIImage *image;
@property CGRect rotated;

@end

@implementation MapOverlayRenderer

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)ctx
{
    double mapPointsPerMeter = MKMapPointsPerMeterAtLatitude(self.floorPlan.center.latitude);
    CGRect rect = CGRectMake(0, 0, self.floorPlan.widthMeters * mapPointsPerMeter, self.floorPlan.heightMeters * mapPointsPerMeter);
    
    CGContextTranslateCTM(ctx, -_rotated.origin.x, -_rotated.origin.y);
    // Rotate around top left corner
    CGContextRotateCTM(ctx, degreesToRadians(self.floorPlan.bearing));
    
    UIGraphicsPushContext(ctx);
    [_image drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    UIGraphicsPopContext();
}

@end


@interface MapScreenVC () {
    
    MapOverlay *mapOverlay;
    MapOverlayRenderer *mapOverlayRenderer;
}

@property (strong) MKCircle *circle;
@property (strong) IAFloorPlan *floorPlan;
@property (nonatomic, strong) IAResourceManager *resourceManager;
@property CGRect rotated;
@property (nonatomic, strong) CalibrationIndicator *calibrationIndicator;

@end

@implementation MapScreenVC

@synthesize mapView;

#pragma mark VC Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    updateCamera = true;
    
    mapView = [MKMapView new];
    [self.view addSubview:mapView];
    mapView.frame = self.view.bounds;
    mapView.delegate = self;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
    
    tapRecognizer.numberOfTapsRequired = 1;
    
    tapRecognizer.numberOfTouchesRequired = 1;
    
    [self.mapView addGestureRecognizer:tapRecognizer];
    
    [self requestLocation];
}


#pragma mark Request Location Method

- (void)requestLocation {
    
    self.locationManager = [IALocationManager sharedInstance];
    
    // Optionally set initial location
    if (kFloorplanId.length) {
        IALocation *location = [IALocation locationWithFloorPlanId:kFloorplanId];
        self.locationManager.location = location;
    }
    
    // set delegate to receive location updates
    self.locationManager.delegate = self;
    
    // Create floor plan manager
    self.resourceManager = [IAResourceManager resourceManagerWithLocationManager:self.locationManager];
    
    self.calibrationIndicator = [[CalibrationIndicator alloc] initWithNavigationItem:self.navigationItem andCalibration:self.locationManager.calibration];
    
    [self.calibrationIndicator setCalibration:self.locationManager.calibration];
    
    // Request location updates
    [self.locationManager startUpdatingLocation];
    
}

#pragma mark MKMapViewDelegate Method

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if (overlay == self.circle) {
        MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.fillColor = [UIColor colorWithRed:0 green:0.647 blue:0.961 alpha:1.0];
        circleRenderer.alpha = 1.f;
        return circleRenderer;
    } else if (overlay == mapOverlay) {
        mapOverlay = overlay;
        mapOverlayRenderer = [[MapOverlayRenderer alloc] initWithOverlay:mapOverlay];
        mapOverlayRenderer.rotated = self.rotated;
        mapOverlayRenderer.floorPlan = self.floorPlan;
        mapOverlayRenderer.image = fpImage;
        return mapOverlayRenderer;
    } else {
        MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
        circleRenderer.fillColor =  [UIColor colorWithRed:1 green:0 blue:0 alpha:1.0];
        return circleRenderer;
    }
}

- (void)changeMapOverlay {
    
    if (mapOverlay != nil)
        [mapView removeOverlay:mapOverlay];
    
    double mapPointsPerMeter = MKMapPointsPerMeterAtLatitude(self.floorPlan.center.latitude);
    double widthMapPoints = self.floorPlan.widthMeters * mapPointsPerMeter;
    double heightMapPoints = self.floorPlan.heightMeters * mapPointsPerMeter;
    CGRect cgRect = CGRectMake(0, 0, widthMapPoints, heightMapPoints);
    double a = degreesToRadians(self.floorPlan.bearing);
    self.rotated = CGRectApplyAffineTransform(cgRect, CGAffineTransformMakeRotation(a));
    
    mapOverlay = [[MapOverlay alloc] initWithFloorPlan:self.floorPlan andRotatedRect:self.rotated];
    [mapView addOverlay:mapOverlay];
    
    // Enable to show red circles on floorplan corners
#if 0
    MKCircle *topLeft = [MKCircle circleWithCenterCoordinate:_floorPlan.topLeft radius:5];
    [map addOverlay:topLeft];
    
    MKCircle *topRight = [MKCircle circleWithCenterCoordinate:_floorPlan.topRight radius:5];
    [map addOverlay:topRight];
    
    MKCircle *bottomLeft = [MKCircle circleWithCenterCoordinate:_floorPlan.bottomLeft radius:5];
    [map addOverlay:bottomLeft];
#endif
}

- (NSString*)cacheFile {
    //get the caches directory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    BOOL isDir = NO;
    NSError *error;
    // create caches directory if it does not exist
    if (! [[NSFileManager defaultManager] fileExistsAtPath:cachesDirectory isDirectory:&isDir] && isDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachesDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    }
    NSString *plistName = [cachesDirectory stringByAppendingPathComponent:@"fpcache.plist"];
    return plistName;
}

// Stores floor plan meta data to NSCachesDirectory
- (void)saveFloorPlan:(IAFloorPlan *)object key:(NSString *)key {
    NSString *cFile = [self cacheFile];
    NSMutableDictionary *cache;
    if ([[NSFileManager defaultManager] fileExistsAtPath:cFile]) {
        cache = [NSMutableDictionary dictionaryWithContentsOfFile:cFile];
    } else {
        cache = [NSMutableDictionary new];
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [cache setObject:data forKey:key];
    [cache writeToFile:cFile atomically:YES];
}

// Loads floor plan meta data from NSCachesDirectory
// Remember that if you edit the floor plan position
// from www.indooratlas.com then you must fetch the IAFloorPlan again from server
- (IAFloorPlan *)loadFloorPlanWithId:(NSString *)key {
    NSDictionary *cache = [NSMutableDictionary dictionaryWithContentsOfFile:[self cacheFile]];
    NSData *data = [cache objectForKey:key];
    IAFloorPlan *object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return object;
}

// Image is fetched again each time. It can be cached on device.
- (void)fetchImage:(IAFloorPlan*)floorPlan {
    
    if (imageFetch != nil) {
        [imageFetch cancel];
        imageFetch = nil;
    }
    __weak typeof(self) weakSelf = self;
    imageFetch = [self.resourceManager fetchFloorPlanImageWithUrl:floorPlan.imageUrl andCompletion:^(NSData *imageData, NSError *error){
        if (!error) {
            fpImage = [[UIImage alloc] initWithData:imageData];
            [weakSelf changeMapOverlay];
        }
    }];
}


#pragma mark IndoorLocation Manager Delegate Methods

- (void)indoorLocationManager:(IALocationManager*)manager didUpdateLocations:(NSArray*)locations {
    
    (void)manager;
    
    CLLocation *clLocation = [(IALocation*)locations.lastObject location];
    NSLog(@"position changed to coordinate (lat,lon): %f, %f", clLocation.coordinate.latitude, clLocation.coordinate.longitude);
    
    if (self.circle != nil) {
        [mapView removeOverlay:self.circle];
    }
    
    self.circle = [MKCircle circleWithCenterCoordinate:clLocation.coordinate radius:1];
    [mapView addOverlay:self.circle];
    if (updateCamera) {
        updateCamera = false;
        if (camera == nil) {
            // Ask Map Kit for a camera that looks at the location from an altitude of 300 meters above the eye coordinates.
            camera = [MKMapCamera cameraLookingAtCenterCoordinate:clLocation.coordinate fromEyeCoordinate:clLocation.coordinate eyeAltitude:300];
            
            // Assign the camera to your map view.
            mapView.camera = camera;
        } else {
            camera.centerCoordinate = clLocation.coordinate;
        }
    }
}


- (void)indoorLocationManager:(IALocationManager*)manager didEnterRegion:(IARegion*)region {
    
    (void) manager;
    if (region.type != kIARegionTypeFloorPlan)
        return;
    
    NSLog(@"Floor plan changed to %@", region.identifier);
    updateCamera = true;
    if (floorPlanFetch != nil) {
        [floorPlanFetch cancel];
        floorPlanFetch = nil;
    }
    
    IAFloorPlan *fp = [self loadFloorPlanWithId:region.identifier];
    if (fp != nil) {
        // use stored floor plan meta data
        self.floorPlan = fp;
        [self fetchImage:fp];
    } else {
        __weak typeof(self) weakSelf = self;
        floorPlanFetch = [self.resourceManager fetchFloorPlanWithId:region.identifier andCompletion:^(IAFloorPlan *floorPlan, NSError *error) {
            if (!error) {
                self.floorPlan = floorPlan;
                [weakSelf saveFloorPlan:floorPlan key:region.identifier];
                [weakSelf fetchImage:floorPlan];
            } else {
                NSLog(@"There was error during floorplan fetch: %@", error);
            }
        }];
    }
}

- (void)indoorLocationManager:(IALocationManager *)manager calibrationQualityChanged:(enum ia_calibration)quality {
    
    [self.calibrationIndicator setCalibration:quality];
}


#pragma mark Tap Gesture Method

-(void) foundTap:(UITapGestureRecognizer *)recognizer  {
    
    if (mapView.annotations.count > 0) {
        [mapView removeAnnotations:mapView.annotations];
    }
    CGPoint point = [recognizer locationInView:self.self.mapView];
    
    CLLocationCoordinate2D tapPoint = [self.self.mapView convertPoint:point toCoordinateFromView:self.view];
    
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    
    point1.coordinate = tapPoint;
    
    [self.mapView addAnnotation:point1];
    
    nodesParser = [[NodesParser alloc] init];
    
    [nodesParser getPathDetails];
}

#pragma mark Warning Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
