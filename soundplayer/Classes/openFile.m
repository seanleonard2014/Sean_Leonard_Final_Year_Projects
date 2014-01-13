

#import "openFile.h"
#import "soundplayerViewController.h"

@implementation openFile

@synthesize openerbutton;
@synthesize gobackbutton;
@synthesize Obj2;

NSMutableArray *tempfileArray;

- (IBAction)goback:(id) sender
{
	[self dismissModalViewControllerAnimated:YES];
	self.view = nil;
}

- (IBAction)selectsong:(id) sender
{
	NSString *song = [NSString stringWithString:[[sender titleLabel] text]];
	song = [song stringByAppendingPathExtension:@"plist"];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) 
	{
		NSLog(@"documentsDirectory empty.");
		assert(0);
	}
	NSString *fileName = [documentsDirectory stringByAppendingPathComponent:song];
	NSLog(@"%@", fileName);
	
	if([[NSFileManager defaultManager]fileExistsAtPath:fileName])
	{
		NSArray *array = [[NSArray alloc]initWithContentsOfFile:fileName];
		
		[Obj2 FileToOpen:array];
		
		[self dismissModalViewControllerAnimated:YES];
		self.view = nil;
	}
	
}


- (IBAction)deletesong:(id) sender 
{
	UILabel * btitle = [sender titleLabel];
	
	NSString *filetodelete;
	NSInteger sendertag;
	sendertag = [sender tag];
	
	filetodelete = [tempfileArray objectAtIndex:[sender tag]];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	int amountoffiles = 0;
	NSString *documentsFolder = [paths objectAtIndex:0];
	
	NSFileManager *localFileManager=[[NSFileManager alloc] init];
	NSDirectoryEnumerator *dirEnum =[localFileManager enumeratorAtPath:documentsFolder];
	
	NSString *file;
	while (file = [dirEnum nextObject]) 
	{
		if ([file isEqualToString:filetodelete]) 
		{
			NSString *myFilePath = [documentsFolder stringByAppendingPathComponent:filetodelete];
			[localFileManager removeItemAtPath:myFilePath error:NULL];
			NSLog(@"-----%@", myFilePath);
		}
	}
	if ([self isViewLoaded]) 
	{
		for (UIButton *search2 in self.view.subviews)
		{
			if ([search2.titleLabel.text isEqualToString: @"go back"] == FALSE) 
			{
				[search2 removeFromSuperview];
			}
		}
		[self viewDidLoad];
	}
}


- (void)viewDidLoad 
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	int amountoffiles = 0;
	NSString *documentsFolder = [paths objectAtIndex:0];
	NSFileManager *localFileManager=[[NSFileManager alloc] init];
	NSDirectoryEnumerator *dirEnum =[localFileManager enumeratorAtPath:documentsFolder];
	
	NSString *file;
	NSMutableArray *fileArray = [[NSMutableArray alloc] init];

	while (file = [dirEnum nextObject]) 
	{
		NSLog(@"---%@", file);
		if ([[file pathExtension] isEqualToString: @"plist"]) {
			NSLog(@"add%@", file);
			amountoffiles++;
			[fileArray addObject:file];
		}
	}
	

	NSLog(@"famountoffiles = %d", amountoffiles);
	
	
		
	for(int i = 0; i < amountoffiles; i++)
	{
		UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];	
		btn.frame = CGRectMake(50, 60+(30*(i+1)), 200, 30);
		[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[btn setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
		[btn setBackgroundColor:[UIColor grayColor]];
		btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];	
		NSLog(@"%@", [fileArray objectAtIndex:i]);
		NSString *stringoffile = [fileArray objectAtIndex:i];
	
		stringoffile = [stringoffile stringByReplacingOccurrencesOfString:@".plist" withString:@""];
		
		[btn setTitle:stringoffile forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(selectsong:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btn];
		
		UIButton * btnd = [UIButton buttonWithType:UIButtonTypeCustom];	
		btnd.frame = CGRectMake(250, 60+(30*(i+1)), 20, 30);
		[btnd setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		[btnd setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
		[btnd setBackgroundColor:[UIColor grayColor]];
		btnd.titleLabel.font = [UIFont boldSystemFontOfSize:20];		
		[btnd setTitle:@"X" forState:UIControlStateNormal];
		[btnd setTag:i];
		NSLog(@"btnd%d", btnd.tag);
		[btnd addTarget:self action:@selector(deletesong:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btnd];
	}

	tempfileArray = fileArray;
    [super viewDidLoad];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];

}


- (void)dealloc {
	[openerbutton release];
	[gobackbutton release];
	[Obj2 release];
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
