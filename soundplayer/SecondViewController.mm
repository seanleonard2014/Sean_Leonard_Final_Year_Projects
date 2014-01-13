
#import "SecondViewController.h"
#import "soundplayerViewController.h"

@implementation SecondViewController
@synthesize label;
@synthesize label2;
@synthesize button;
@synthesize myArray;
@synthesize Obj;
@synthesize wholenote;
@synthesize halfnote;
@synthesize quartnote;
@synthesize eighthnote;
@synthesize sixteenthnote;
@synthesize tempScrollView;

NSString *fret = NULL;
NSString *notetime = NULL;


-(IBAction) dismissView:(id) sender
{
	fret = NULL;
	UILabel * btitle = [sender titleLabel];
	NSLog(@"%@", btitle.text);
	if ([[btitle text] isEqualToString:@"rest"]) 
	{
		fret = @"|";
	}
	else
	{
	fret = (@"%@", btitle.text);
	}
	
	label.text = fret;
	NSLog(@"--%@",fret);
	if (notetime != NULL) 
	{
		[Obj addnotetime:notetime];
		[Obj writeToSegment:fret];
		
		notetime = NULL;
		fret = NULL;
		[self dismissModalViewControllerAnimated:YES];
	}
	if ([fret isEqualToString:@"-"])
	{
		[Obj writeToSegment:fret];
		notetime = NULL;
		fret = NULL;
		[self dismissModalViewControllerAnimated:YES];
	}
}


-(IBAction) changeButton:(id) sender
{
	notetime = NULL;
	UILabel * btitle = [sender titleLabel];
	notetime = (@"%@", btitle.text);
	label2.text = notetime;
	NSLog(@"--%@",notetime);
	if (fret != NULL) {
		
		[Obj addnotetime:notetime];
		[Obj writeToSegment:fret];
		
		notetime = NULL;
		fret = NULL;
		[self dismissModalViewControllerAnimated:YES];
	}
}


-(void)writeLabel:(NSString*)fretnumber :(NSString *)timeofnote
{
	label.text = fretnumber;
	label2.text = timeofnote;
}


-(IBAction)goback
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad 
{
tempScrollView=(UIScrollView *)self.view;
	[tempScrollView setContentSize:CGSizeMake(640, 400)];

	[super viewDidLoad];
}


- (void)dealloc {
	[tempScrollView release];
	[label release];
	[Obj release];
	[button release];
	[myArray release];
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
