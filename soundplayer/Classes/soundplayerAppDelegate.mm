

#import "soundplayerAppDelegate.h"
#import "soundplayerViewController.h"
#import "SecondViewController.h"

@implementation soundplayerAppDelegate

@synthesize window;
@synthesize viewController;

UIScrollView *tempScrollView;
#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	tempScrollView = (UIScrollView *) viewController.view;
    tempScrollView.contentSize=CGSizeMake(800,960);
	tempScrollView.maximumZoomScale = 5.0;
	tempScrollView.minimumZoomScale = 0.5;
	tempScrollView.delegate = self;
	tempScrollView.clipsToBounds = NO;

	[self.window addSubview:tempScrollView];
	[self.window makeKeyAndVisible];
	[viewController opener];
	
    return YES;
	
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return tempScrollView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale 
{
	NSLog(@"scale %f", scale);
	float scalecal;
	scalecal = 1 - scale;
	scalecal = scalecal + 1;
	
	tempScrollView.contentSize=CGSizeMake(800,960);
	tempScrollView.maximumZoomScale = 5.0;
	tempScrollView.minimumZoomScale = 0.5;
	tempScrollView.delegate = self;
	tempScrollView.clipsToBounds = NO;
	
	[tempScrollView setNeedsDisplay];
}  

- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if((toInterfaceOrientation == UIInterfaceOrientationPortrait) ||
	   (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) ||
	   (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
	   (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))  {   
		return YES; 
	}
	else{
		return NO;
	}
}

- (void)dealloc {
	[tempScrollView release];
    [viewController release];
    [window release];
    [super dealloc];
}


@end
