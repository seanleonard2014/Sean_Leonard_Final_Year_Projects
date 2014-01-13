

#import "saveFile.h"


@implementation saveFile

@synthesize FileNameToSave;
@synthesize savebutton;
@synthesize gobackbutton;

NSMutableArray *ArrayToSave;

-(void)saveArray:(NSMutableArray *)theArray
{
	ArrayToSave = [[NSMutableArray alloc] init];
	[ArrayToSave setArray:theArray];
	
}

- (IBAction)goback:(id) sender
{
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)saveAndGo:(id)sender
{
	if (FileNameToSave.text != NULL) 
	{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsFolder = [paths objectAtIndex:0];
	documentsFolder = [documentsFolder stringByAppendingString:@"/"];
	NSString *fileTitle = [FileNameToSave text];
		
	fileTitle = [fileTitle stringByAppendingPathExtension:@"plist"];
		NSLog(@"-%@", fileTitle);
	documentsFolder = [documentsFolder stringByAppendingString:fileTitle];
		NSLog(@"--%@", documentsFolder);
	
		if ([ArrayToSave isKindOfClass:[NSMutableArray class]]) 
		{
			NSLog(@"Its a mutable array");
			int i = [ArrayToSave count];
			NSLog(@"count = %d", i);
		}
		
		for (int i = 0; i < [ArrayToSave count]; i++) 
		{
			NSLog(@"+++%@", [ArrayToSave objectAtIndex:i]);
		}
		
	[ArrayToSave writeToFile:documentsFolder atomically:YES];		//Saves file to directory
		
		
		
		
	[self dismissModalViewControllerAnimated:YES];
	}
	else 
	{
		NSLog(@"No string in field");
	}

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}


- (void)viewDidLoad 
{
    FileNameToSave.delegate = self;
	FileNameToSave.placeholder = @"<Enter Text>";
	FileNameToSave.textAlignment = UITextAlignmentCenter;
	[self.view addSubview: FileNameToSave];
	[super viewDidLoad];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[FileNameToSave release];
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
