
#import "openingController.h"
#import "openFile.h"
#import "soundplayerViewController.h"

@implementation openingController

@synthesize button1;
@synthesize button2;
@synthesize openFileView;
@synthesize Obj1;

- (IBAction)play1:(id) sender
{
	[self dismissModalViewControllerAnimated:YES];	//Reveals main tab editor
}

- (IBAction)openafile:(id) sender
{	
	[Obj1 openfilenow];			//Opens instance of openFile view (This does not work and will simply display the tab editor)
	[self dismissModalViewControllerAnimated:YES];
	
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

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[Obj1 release];
	[button1 release];
    [button2 release];
	[super dealloc];
}

@end
