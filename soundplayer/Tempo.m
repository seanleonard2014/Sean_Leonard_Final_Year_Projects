

#import "Tempo.h"
#import "soundplayerViewController.h"

@implementation Tempo

@synthesize theSlider;
@synthesize theLabel;
@synthesize theButton;
@synthesize Obj3;

float f = 0;
NSString *str;
- (IBAction)SliderMoved:(UISlider *)sender
{
	NSLog(@"%f", [sender value]);
	f = [sender value];
	int myInt = [[NSNumber numberWithFloat:f] intValue];
	str = [NSString stringWithFormat:@"%d", myInt];
	theLabel.text = str;
	[Obj3 writeTempo:str];
}

-(IBAction)goback:(id)sender
{	
	[self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad 
{
	theSlider.maximumValue = 180;
	theSlider.minimumValue = 60;
	theSlider.value = 120;
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[theSlider release];
	[theLabel release];
	[theButton release];
	[Obj3 release];
	
    [super dealloc];
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

@end
