

#import "RepeatView.h"


@implementation RepeatView
@synthesize gobackbutton;
@synthesize Obj4;
@synthesize tempScrollView;

NSString *numbertoset;

- (IBAction)goback:(id) sender
{
	[self dismissModalViewControllerAnimated:YES];
}


-(IBAction)setrepeaterfunc:(id) sender		//This is called when the users chooses a number.
{
	numbertoset = [[sender titleLabel] text];
	[Obj4 writerepeater:numbertoset];
	[self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad 
{
	tempScrollView=(UIScrollView *)self.view;
	[tempScrollView setContentSize:CGSizeMake(640, 400)];
	tempScrollView.delegate = self;
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[tempScrollView release];
	[gobackbutton release];
	[Obj4 release];
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
