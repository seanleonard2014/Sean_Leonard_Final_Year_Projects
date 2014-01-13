

#import "soundplayerViewController.h"
#import "openingController.h"
#import "SecondViewController.h"
#import "openFile.h"
#import "saveFile.h"
#import "Tempo.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSXMLParser.h>

@implementation soundplayerViewController

@synthesize staffbutton;
@synthesize playbutton;
@synthesize stopbutton;
@synthesize tempobutton;
@synthesize label;
@synthesize repeatButton1;
@synthesize repeatButton2;
@synthesize string;
@synthesize secondview1;
@synthesize theAudio;
@synthesize Metronome;
@synthesize opencontroller;
@synthesize tempScrollView;
@synthesize openFileView;
@synthesize saveFileView;
@synthesize RepeaterView;
@synthesize tempoview;
@synthesize tempolabel;
@synthesize tempolabelbutton;
@synthesize repeatsetterbutton;
@synthesize repeatlabelbutton;
@synthesize metbutton;
@synthesize metlabelbutton;

AVAudioPlayer *Audiotostop;

NSMutableArray *myArray = [[NSMutableArray alloc] init];		//Holds tag numbers and notelength of notes
NSMutableArray *starttimesArray = [[NSMutableArray alloc] init];
NSTimeInterval playbackDelay = 0;
NSTimeInterval chorddevicetimes = 0;

float timer;
float tempo = 120;
float notelength;

BOOL sixth;
BOOL fifth;
BOOL fourth;
BOOL third;
BOOL second;
BOOL first;
BOOL met = FALSE;
BOOL repeat = FALSE;
BOOL firstselector = FALSE;
BOOL secondselector = FALSE;
BOOL stop = FALSE;
BOOL chord = FALSE;
BOOL incrementplaydelforchord;
BOOL endofchord = FALSE;
BOOL showopener = FALSE;

int noteindex = 0;
int staffnum = 1;
int staffx;
int thetag;
int notetagx = 0;
int notetagger = 0;
int temptag;
int temptagger = 0;
int prevtag = 0;
int numberofnotes;
int lasttag = 0;
int numberofrepeats = 0;
int repeatfromtag;
int repeattotag;
int temprbuttontag1 = 0;
int temprbuttontag2 = 0;

NSString *note;
NSMutableArray *tagnsarray ;
NSMutableArray *sortedtagnsarray;
NSMutableArray *Arrayofplayers = [[NSMutableArray alloc] init];	//This will hold each AVAudioPlayer instance as they are playing.



-(IBAction)playSound{
	
	stop = FALSE;
	numberofnotes = 0;
	int tagindex = 0;
	int tagarray[1600];
	
if(repeat == FALSE)
{

	for (UIButton *search in self.view.subviews)		//Searches through all buttons in app and counts the note segments that have notes.
	{
		if ([search isKindOfClass:[UIButton class]] 
			&& [search.titleLabel.text isEqualToString:@"-"] == FALSE
			&& [search.titleLabel.text length] <= 2
			&& [search tag] > 3000)
		{
			numberofnotes++;
		}
	}
	
	NSLog(@"repeattotag = %d", repeattotag);
	NSLog(@"repeatfromtag = %d", repeatfromtag);

	NSLog(@"numberofrepeats%d", numberofrepeats);
	NSLog(@"number%d", numberofnotes);
	if(numberofnotes == 0)
	{
		NSLog(@"no notes");
		NSLog(@"repeat is False");
		return;
	}
	
	for (int h = 0; h < 1600; h++) 
	{
		tagarray[h] = 0;
	}
	tagindex = 0;
	
	
	
			//Get all the button tags that have numbers on them and adds each tag to an array.
			for (UIButton *search in self.view.subviews)
			{
				if ([search isKindOfClass:[UIButton class]] 
					&& [search.titleLabel.text isEqualToString:@"-"] == FALSE
					&& [search.titleLabel.text length] <= 2
					&& [search tag] > 3000)
					{
							temptag = search.tag;
							tagarray[tagindex] = temptag;
							tagindex = tagindex + 1;
					}
			}
}//end if repeat is false
	

	
	if(repeat == TRUE)
	{
		
		for (UIButton *search in self.view.subviews)			//Checks for repeater bars. Repeater bars have tags between 2000 to 3000
		{
			if ([search isKindOfClass:[UIButton class]] 
				&& [search.titleLabel.text isEqualToString:@"-"] == FALSE
				&& [search.titleLabel.text length] <= 2
				&& [search tag] > 3000
				&& (((([search tag] - ([search tag] % 100)) % 100000)/100) + 1) >= (repeatfromtag%1000)
				&& (((([search tag] - ([search tag] % 100)) % 100000)/100) + 1) <= (repeattotag%1000)
				)
			{
				NSLog(@"check!!!!!!!!!!!!!!! %d", (((([search tag] - ([search tag] % 100)) % 100000)/100) + 1));
				numberofnotes++;
			}
		}
		
		NSLog(@"repeattotag = %d", repeattotag);
		NSLog(@"repeatfromtag = %d", repeatfromtag);
		
		NSLog(@"numberofrepeats%d", numberofrepeats);
		NSLog(@"number%d", numberofnotes);
		if(numberofnotes == 0)
		{
			NSLog(@"no notes");
			NSLog(@"repeat is true");
			return;
		}
		for (int h = 0; h < 1600; h++) 
		{
			tagarray[h] = 0;
		}
		tagindex = 0;
		
		
		
		//Get all the button tags that have numbers on them
		for (UIButton *search in self.view.subviews)
		{
			if ([search isKindOfClass:[UIButton class]] 
				&& [search.titleLabel.text isEqualToString:@"-"] == FALSE
				&& [search.titleLabel.text length] <= 2
				&& [search tag] > 3000
				&& (((([search tag] - ([search tag] % 100)) % 100000)/100) + 1) >= (repeatfromtag%1000)
				&& (((([search tag] - ([search tag] % 100)) % 100000)/100) + 1) <= (repeattotag%1000)
				)
			{
				temptag = search.tag;
				tagarray[tagindex] = temptag;
				tagindex = tagindex + 1;
			}
		}
	}//end if repeat is false	
	
	
	
	
	
	
	
	

	
	tagnsarray = [[NSMutableArray alloc]
								   initWithCapacity: tagindex];
	sortedtagnsarray = [[NSMutableArray alloc]
								   initWithCapacity: tagindex];
	
	
	
	
	
	//Put all the tags in a mutablearray
	int i;
	NSNumber *number;
	for (i = 0; i < tagindex; i++)
	{
		number = [NSNumber numberWithInt: tagarray[i]];
		[tagnsarray addObject: number];
	}
	
	
	
	
	
	
	for (int h = 0; h < 1600; h++) 
	{
		tagarray[h] = 0;
	}

	
	theAudio.currentTime = 0.0;
	//Metronome.currentTime = 0.0;
	
	
	

	sortedtagnsarray = [tagnsarray sortedArrayUsingSelector:@selector(compare:)];		//This function will sort the array of tags.

	NSLog(@"sortedtagarray");
	//prevtag = 100000;
	prevtag = [[sortedtagnsarray objectAtIndex: 0] intValue];

	NSLog(@"sortedtagnsarray count = %d", [sortedtagnsarray count]);

	
	/* This is some code that i used to attempt to find the first note in the score.
	int holder;
	int secondholder = 0;
	
	for (int z = 0; z < [sortedtagnsarray count]; z++) 
	{
		holder = [[sortedtagnsarray objectAtIndex: z] intValue];
		NSLog(@"holder = %d", holder);
		NSLog(@"holder % 100000 = %d", holder % 100000);
		if ((holder % 100000) < 100) 
		{
			if ((holder % 100000) <= (secondholder % 100000))
			{
				secondholder = holder;
			}
		}
	}
	prevtag = secondholder;
	NSLog(@"----prevtag = %d", prevtag);
*/
	
	
/*	int start = 100000;
	NSNumber *numberb;
	
	for (int y = 0; y < [tagnsarray count]; y++) 
	{
		numberb = [tagnsarray objectAtIndex:y];
	
		for (UIButton *search in self.view.subviews)
		{	
			if ([search tag] == [numberb intValue]) 
			{
				if () 
				{
				
				}
				
			numberb = [NSNumber numberWithInt: start];
			[sortedtagnsarray addObject:numberb];
			}
		}
	
	}
		start = start + 100000;
		if (start >= 700000) 
		{
			start = (start - 600000) + 1;
		}
	}
	
	prevtag = 0;
	prevtag = [[sortedtagnsarray objectAtIndex: 0] intValue];
	*/

	
	int loopcheck = 0;
	int numberofticks = 8*staffnum;
	NSLog(@"number of staffs = %d", staffnum);
	
	float tickinc = ((tempo/60)/((tempo/60)*(tempo/60))*1);
	float tickdel = 0;
	
	//----------------------------------------------------------------------------

	while (numberofnotes > 0) 
	{
		
		
		
		
		NSLog(@"in loop");
		loopcheck++;
		if (loopcheck > numberofnotes * 2) 
		{
			NSLog(@"break out of loop");
			break;
		}
		
		
		
		
		for (UIButton *search in self.view.subviews)
		{	
			
			if ((search.tag % 100 == 0 || ((search.tag % 100) % 4) == 0) && numberofticks > 0 && search.tag > 100000 && search.tag < 200000 ) 
			{
				if (met == TRUE)		//If met is true then the metronome will play.
				{
				NSString *path = [[NSBundle mainBundle] pathForResource:@"tock" ofType:@"caf"];
				Metronome = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
				Metronome.delegate = self;
				
				[Metronome playAtTime: Metronome.deviceCurrentTime + tickdel ];
				Metronome.volume = 0.5;
				tickdel = tickdel + tickinc;
				numberofticks = numberofticks - 1;
				NSLog(@"----tickdel = %f", tickdel);
				[Metronome play];
				}
			}
			
			
			if (search.tag == prevtag && prevtag <= 699931 && prevtag != 0)			//finds note in array.
			{
				NSLog(@"---------------");
				NSLog(@"prevtag was found = %d", prevtag);
				
					for(int i = 0; i < 6; i++)
					{
						thetag = prevtag + 100000*(i+1);
					
						for(int n = 0; n < [sortedtagnsarray count]; n++)		//This will check to see if the note found is part of a chord.
						{
							if([[sortedtagnsarray objectAtIndex: n] intValue] == thetag)
							{
								chord = TRUE;
								incrementplaydelforchord = TRUE;
								NSLog(@" incrementplaydelforchord  set to true");
							}
						}
					}
				
				
				[self setnotetoplay : search];
				numberofnotes = numberofnotes - 1;
				chord = FALSE;
				incrementplaydelforchord = FALSE;
				
				for(int n = 0; n < [sortedtagnsarray count]; n++)
				{
					if([[sortedtagnsarray objectAtIndex: n] intValue] == search.tag)
					{
						
					NSMutableArray *mutedsortedtagnsarray = [sortedtagnsarray mutableCopy];
					int zero = 0;
					NSNumber *replacer;
					replacer = [NSNumber numberWithInt: zero];
					unsigned int replace = n;
					id r = replacer;
					[mutedsortedtagnsarray replaceObjectAtIndex:replace withObject:r];
					sortedtagnsarray = mutedsortedtagnsarray;
					}
				}
				
				
				
				
				
				
				//Chord search
				
				for(int i = 0; i < 6; i++)
				{
					thetag = prevtag + 100000*(i+1);
	 
					for(int n = 0; n < [sortedtagnsarray count]; n++)
					{
						if([[sortedtagnsarray objectAtIndex: n] intValue] == thetag)
						{
							for (UIButton *search2 in self.view.subviews)
							{		
								if (search2.tag == thetag) 
								{	
									chord = TRUE;
									int checkforend = 0;
									int thetagb = thetag;
									for(int g = 0; g < 6; g++)
									{
										thetagb = thetagb + 100000*(g+1);
										for(int h = 0; h < [sortedtagnsarray count]; h++)
										{
											if([[sortedtagnsarray objectAtIndex: h] intValue] == thetagb)
											{
												endofchord = FALSE;
												checkforend++;
											}
										}
										if (checkforend == 0) 
										{
											endofchord = TRUE;
											NSLog(@"endofchord true");
										}
									}
									[self setnotetoplay : search2];
									numberofnotes = numberofnotes - 1;
									NSLog(@"numberofnotes = numberofnotes - 1");
									NSLog(@"chord = true");
									NSLog(@"chord thetag = %d", thetag);
									//le = le + 1;
									NSMutableArray *mutedsortedtagnsarray = [sortedtagnsarray mutableCopy];
									int zero = 0;
									NSNumber *replacer;
									replacer = [NSNumber numberWithInt: zero];
									unsigned int replace = n;
									id r = replacer;
									[mutedsortedtagnsarray replaceObjectAtIndex:replace withObject:r];
									sortedtagnsarray = mutedsortedtagnsarray;
									
									
									
									chord = FALSE;
									endofchord = FALSE;
									NSLog(@"chord = false");
								}
							}
						}
					}
				}//end chord search
				
				incrementplaydelforchord = FALSE;
				chord = FALSE;
				endofchord = FALSE;
				
				
				
				
				
				
				
				
				//--------------------------
			while(thetag > 0)					//This will find the next note in the sequence.
			{
							for(int j = 0; j < 6; j++)
							{
								if(prevtag >= 100000*(j+1) && prevtag <= (100000*(j+1) + 99915))
								{
									thetag = prevtag - 100000*(j+1);
								}
							}

							thetag = thetag + 100001;

							for(int n = 0; n < 6; n++)
							{
								for(int m = 0; m < [sortedtagnsarray count]; m++)
								{
									if(thetag == [[sortedtagnsarray objectAtIndex: m] intValue])
									{	
										lasttag = prevtag;
										prevtag = thetag;
										thetag = 0;
										break;
										m = [sortedtagnsarray count] + 1;
										n = 6;
									}
									if (thetag == 0) 
									{
										break;
									}
								}
								thetag = thetag + 100000;
								
									if (thetag == 100000) 
									{
										thetag = 0;
										break;
									}

								
								
								if (numberofnotes == 0) 
								{
									thetag = 0;
								}
							}

				if (thetag != 0) 
				{
					prevtag = prevtag + 1;
				}
			}//end second while
				
				
				
				
				
				
				
				
			}	//if search
		
		}//for each uibutton
		
		
		
		
		
		 int check;
		 for(int n = 0; n < [sortedtagnsarray count]; n++)
		 {
			 if([[sortedtagnsarray objectAtIndex: n] intValue] != 0)
			 {
			 check++;
			 }
		 }
		 if (check == 0) 
		 {
			 NSLog(@"no more notes");
		 }
		 
	 }	//while End

	
	
	if (repeat == TRUE)
	{
		if (numberofrepeats <= 0) 
		{
			repeat = FALSE;
			for (UIButton *search2 in self.view.subviews)
			{	
				if([search2 tag] <= 3000 && [search2 tag] > 1000)
				{
					[search2 setBackgroundColor:[UIColor blackColor]];
				}
			}
			
			return;
		}
		else 
		{
		numberofrepeats = numberofrepeats - 1;
		[self playSound];
		}
		
	}
	
	
	
	
				for (int i = 0; i < [sortedtagnsarray count]; i++) 
				{
					(NSLog(@"%d, ", [[sortedtagnsarray objectAtIndex: i] intValue]));
				}		
				NSLog(@"----------%d", numberofnotes);

	
	
	
	
	
	[tagnsarray removeAllObjects];
	[sortedtagnsarray removeAllObjects];
	
	
	
	
	
	
	
	lasttag = 0;
	numberofnotes = 0;
	temptagger = 0; 
	temptag = 0;
	prevtag = 0;
	met == FALSE;
}//end Playsound

-(void)setnotetoplay:(UIButton *)search			//Set the note to be played with buttons text and tag value.
	{
		notetagx = search.tag;
		
	if ((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"0"]) 
	{
		note = @"037";	//E1
	}
	
	if ((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"1"]) 
	{
		note = @"038"; //F1
	}
	
	if ((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"2"]) 
	{
		note = @"039";	//F#1
	}
	
	if ((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"3"]) 
	{
		note = @"040";	//G1
	}
	
	if ((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"4"]) 
	{
		note = @"041";	//G#1
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"5"]) 
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"0"])  ) 
	{
		note = @"042";	//A1
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"6"])
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"1"]))
	{
		note = @"043";	//A#1
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"7"])
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"2"])) 
	{
		note = @"044";	//B1
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"8"])
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"3"]))
	{
		note = @"045";	//C1
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"9"])
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"4"]))
	{
		note = @"046";	//C#1
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"10"])
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"5"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"0"])) 
	{
		note = @"047";	//D1
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"11"])
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"6"]) 
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"1"]))
	{
		note = @"049";	//D#1
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"12"]) 
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"7"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"2"]))
	{
		note = @"050";	//E2
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"13"]) 
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"8"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"3"]))
	{
		note = @"051";	//F2
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"14"])
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"9"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"4"]))
	{
		note = @"052";	//F#2
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"15"])
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"10"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"5"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"0"]))
	{
		note = @"053";	//G2
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"16"]) 
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"11"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"6"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"1"]))
	{
		note = @"054";	//G#2
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"17"]) 
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"12"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"7"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"2"]))
	{
		note = @"055";	//A2
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"18"]) 
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"13"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"8"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"3"])) 
	{
		note = @"056";	//A#2
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"19"])
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"14"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"9"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"4"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"0"]))
	{
		note = @"057";	//B2
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"20"])  
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"15"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"10"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"5"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"1"]))
	{
		note = @"058";	//C2
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"21"]) 
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"16"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"11"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"6"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"2"]))
	{
		note = @"059";	//C#2
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"22"])
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"17"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"12"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"7"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"3"]))
	{
		note = @"060";	//D2
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"23"])
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"18"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"13"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"8"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"4"]))
	{
		note = @"061";	//D#2
	}
	
	if (((notetagx - 100000) >= 0 && (notetagx - 100000) <= 99931 && [search.titleLabel.text isEqualToString:@"24"]) 		
		|| ((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"19"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"14"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"9"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"5"])
		|| ((notetagx - 600000) >= 0 && (notetagx - 600000) <= 99931 && [search.titleLabel.text isEqualToString:@"0"]))
	{
		note = @"062";	//E3
	}
		
	if (((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"20"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"15"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"10"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"6"])
		|| ((notetagx - 600000) >= 0 && (notetagx - 600000) <= 99931 && [search.titleLabel.text isEqualToString:@"1"]))
	{
		note = @"063";	//F3
	}
		
	if (((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"21"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"16"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"11"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"7"])
		|| ((notetagx - 600000) >= 0 && (notetagx - 600000) <= 99931 && [search.titleLabel.text isEqualToString:@"2"]))
	{
		note = @"064";	//F#3
	}
	
	if (((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"22"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"17"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"12"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"8"])
		|| ((notetagx - 600000) >= 0 && (notetagx - 600000) <= 99931 && [search.titleLabel.text isEqualToString:@"3"]))
	{
		note = @"065";	//G3
	}
	if (((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"23"])
		|| ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"18"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"13"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"9"])
		|| ((notetagx - 600000) >= 0 && (notetagx - 600000) <= 99931 && [search.titleLabel.text isEqualToString:@"4"]))
	{
		note = @"066";	//G#3
	}
	if (((notetagx - 200000) >= 0 && (notetagx - 200000) <= 99931 && [search.titleLabel.text isEqualToString:@"24"])
		 || ((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"19"])
		 || ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"14"])
		 || ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"10"])
		 || ((notetagx - 600000) >= 0 && (notetagx - 600000) <= 99931 && [search.titleLabel.text isEqualToString:@"5"]))
	{
		note = @"067";	//A3
	}
		
	if (((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"20"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"15"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"11"])
		|| ((notetagx - 600000) >= 0 && (notetagx - 600000) <= 99931 && [search.titleLabel.text isEqualToString:@"6"]))
	{
		note = @"068";	//A#3
	}
		
	if (((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"21"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"16"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"12"])
		|| ((notetagx - 600000) >= 0 && (notetagx - 600000) <= 99931 && [search.titleLabel.text isEqualToString:@"7"]))
	{
		note = @"069";	//B3
	}
		
	if (((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"22"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"17"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"13"])
		|| ((notetagx - 600000) >= 0 && (notetagx - 600000) <= 99931 && [search.titleLabel.text isEqualToString:@"8"]))
	{
		note = @"070";	//C3
	}
		
	if (((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"23"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"18"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"14"])
		|| ((notetagx - 600000) >= 0 && (notetagx - 600000) <= 99931 && [search.titleLabel.text isEqualToString:@"9"]))
	{
		note = @"071";	//C#3
	}
		
	if (((notetagx - 300000) >= 0 && (notetagx - 300000) <= 99931 && [search.titleLabel.text isEqualToString:@"24"])
		|| ((notetagx - 400000) >= 0 && (notetagx - 400000) <= 99931 && [search.titleLabel.text isEqualToString:@"19"])
		|| ((notetagx - 500000) >= 0 && (notetagx - 500000) <= 99931 && [search.titleLabel.text isEqualToString:@"15"])
		|| ((notetagx - 600000) >= 0 && (notetagx - 600000) <= 99931 && [search.titleLabel.text isEqualToString:@"10"]))
	{
		note = @"073";	//D3
	}
	if ([search.titleLabel.text isEqualToString:@"|"])
	{
		note = @"037";
	}
	[self playnote: note :theAudio :search];
}

- (void)playnote:(NSString*)n :(AVAudioPlayer *)theAudiofade :(UIButton *)button{
	
	NSString *path = [[NSBundle mainBundle] pathForResource:n ofType:@"aiff"];
	 
	theAudiofade = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
	theAudiofade.delegate = self;
	
	timer = theAudiofade.deviceCurrentTime + playbackDelay;
	
	int length = [myArray count];
	
	for (int i = 0; i < length; i++) 
	{
		NSMutableArray *tempArray = [[NSMutableArray alloc] init];
		tempArray = [myArray objectAtIndex:i];
		NSString *notetime = [tempArray objectAtIndex:0];
		NSLog(@"notetime = %@", notetime);
		NSString *notetag = [tempArray objectAtIndex:1];
		int tagvalue = [notetag intValue];
		NSLog(@"tag %d", tagvalue);
		
		
		if (button.tag == tagvalue)				//calculate note length
		{
			if ([notetime isEqualToString: @"4/4"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*4);
			}
			if ([notetime isEqualToString: @"15/16"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*3.75);
			}
			if ([notetime isEqualToString: @"7/8"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*3.5);
			}
			if ([notetime isEqualToString: @"13/16"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*3.25);
			}
			if ([notetime isEqualToString: @"3/4"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*3);
			}
			if ([notetime isEqualToString: @"11/16"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*2.75);
			}
			if ([notetime isEqualToString: @"5/8"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*2.5);
			}
			if ([notetime isEqualToString: @"9/16"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*2.25);
			}
			if ([notetime isEqualToString: @"2/4"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*2);
			}
			if ([notetime isEqualToString: @"7/16"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*1.75);
			}
			if ([notetime isEqualToString: @"3/8"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*1.50);
			}
			if ([notetime isEqualToString: @"5/16"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*1.25);
			}
			if ([notetime isEqualToString: @"1/4"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*1);
			}
			if ([notetime isEqualToString: @"3/16"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*0.75);
			}
			if ([notetime isEqualToString: @"1/8"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*0.5);
			}
			if ([notetime isEqualToString: @"1/16"]) 
			{
				notelength = ((tempo/60)/((tempo/60)*(tempo/60))*0.25);
			}
		}
	}

	
	if (chord == TRUE) 
	{
		if(incrementplaydelforchord == TRUE)
		{
			NSLog(@"Actual playback increment");
			chorddevicetimes = theAudiofade.deviceCurrentTime;
		}
			
		[theAudiofade playAtTime: chorddevicetimes + playbackDelay];		//Sets exact time for note to begins.
		NSLog(@"notelength = %f", notelength);
		
		[self performSelector:@selector(fadeOut:) withObject:theAudiofade afterDelay:playbackDelay + notelength]; //Sets exact time for note to end.
		[self performSelector:@selector(firstchangeColor:) withObject:button afterDelay:playbackDelay];
		[self performSelector:@selector(changeColor:) withObject:button afterDelay:playbackDelay + notelength];	//These set the colour of each tag to blue as its playing
		NSLog(@"ChordPlayAtTime: theAudiofade.deviceCurrentTime = %d", chorddevicetimes);
		NSLog(@"chord :%d", button.tag);
		NSLog(@"playbackDelay = %f", (playbackDelay));
		
		if(endofchord == TRUE)
		{
			playbackDelay = playbackDelay+notelength;
			endofchord = FALSE;
		}
		
	}
	if (chord == FALSE)
	{
		
		NSLog(@"theAudiofade.deviceCurrentTime = %f", theAudiofade.deviceCurrentTime);
		[theAudiofade playAtTime: theAudiofade.deviceCurrentTime + playbackDelay];
		[self performSelector:@selector(firstchangeColor:) withObject:button afterDelay:playbackDelay];
		playbackDelay = playbackDelay+notelength;
		[self performSelector:@selector(fadeOut:) withObject:theAudiofade afterDelay:playbackDelay + notelength];
		[self performSelector:@selector(changeColor:) withObject:button afterDelay:playbackDelay + notelength];
		NSLog(@"playbackDelay = %f", (playbackDelay));
		NSLog(@"note :%d", button.tag);
	}
	if (button.titleLabel.text == @"|")		//For inserting silence or rest
	{
		theAudiofade.volume = 0;
	}
	
	Audiotostop = theAudiofade;
	if(theAudiofade == NULL)
	{
		NSLog(@"Error theAudiofade == NULL");
	}

	
	if (Audiotostop != NULL) 
	{
		[Audiotostop play];
		[Arrayofplayers addObject:Audiotostop];
	}
	
}

- (void)fadeOut:(AVAudioPlayer *)theAudiotofade
{
	NSLog(@"fade");	
	if(theAudiotofade.volume >= 0.00)
	{
		[theAudiotofade stop];
		playbackDelay = 0.0;
	}
}





-(IBAction)playMetronome
{
	NSLog(@"metronome?");
	if ([[[metlabelbutton titleLabel] text] isEqualToString:@"Off" ])
	{
		NSLog(@"metronome was off");
		met = TRUE;
		[metlabelbutton setTitle:@"On" forState:(UIControlStateNormal)];
	}
	else if ([[[metlabelbutton titleLabel] text] isEqualToString:@"On" ])
	{
		NSLog(@"metronome was on");
		met = FALSE;
		[metlabelbutton setTitle:@"Off" forState:(UIControlStateNormal)];
	}
}


- (void)firstchangeColor:(UIButton *)button
{
	if (stop == FALSE) 
	{
		[button setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
	}
}

- (void)changeColor:(UIButton *)button
{
	if (stop == FALSE) 
	{
		[button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
	}
}



-(IBAction)stopSound:(id)sender
{
	NSLog(@"stop");

	if ([Audiotostop isPlaying] == TRUE) 
	{
		[Audiotostop stop];
		[theAudio stop];
		Audiotostop = nil;
		theAudio = nil;
		NSLog(@"Audiostop!!!!!!!");
		numberofnotes = 0;
		lasttag = 0;
		temptagger = 0; 
		temptag = 0;
		prevtag = 0;
		for (int i = 0; i < [Arrayofplayers count]; i++) //This will stop each instance of the AVAudioPlayer.
		{
			AVAudioPlayer *temp;
			temp = [Arrayofplayers objectAtIndex:i];
			NSLog(@"%@", [Arrayofplayers objectAtIndex:i]);
			[temp stop];
		}
		for (UIButton *search in self.view.subviews)
		{
		if ([search isKindOfClass:[UIButton class]] 
			&& [search.titleLabel.text isEqualToString:@"-"] == FALSE
			&& [search.titleLabel.text length] <= 2)
			{
				[search setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
			}
		}
	}
	
	if ([Metronome isPlaying] == TRUE) 
	{
		[Metronome stop];
	}
}

-(IBAction)clearstaff
{
	for (UIButton *search in self.view.subviews)
	{
		if ([search isKindOfClass:[UIButton class]] 
			&& [search.titleLabel.text isEqualToString:@"-"] == FALSE
			&& [search.titleLabel.text length] <= 2
			&& [search tag] > 3000)
		{
			search.titleLabel.font = [UIFont boldSystemFontOfSize:20];
			[search setTitle:@"-" forState:(UIControlStateNormal)];
		}
	}
	
	for (UILabel *search2 in self.view.subviews)
	{
		if ([search2 isKindOfClass:[UILabel class]] 
			&& [search2.text isEqualToString:@"="] == FALSE)
		{
			[search2 removeFromSuperview];
		}
	}
	
	for (UIButton *search in self.view.subviews)
	{
		if ([search isKindOfClass:[UIButton class]]
			&& [search tag] > 1000 && [search tag] <= 3000)
		{
			[search setBackgroundColor:[UIColor blackColor]];
		}
	}
	
	[myArray removeAllObjects];
	/*if ([self isViewLoaded]) 
	{
		for (UIButton *search2 in self.view.subviews)
		{
				[search2 removeFromSuperview];
		}
	}*/
	[self viewDidLoad];
}



-(IBAction)changeTempo
{
	[self presentModalViewController:tempoview animated:YES];
}

- (void)writeTempo:(NSString*)tempostring 
{
	tempo = [tempostring intValue];
	NSLog(@"Tempo = %f", tempo);
	[tempolabelbutton setTitle:tempostring forState:(UIControlStateNormal)];
}

-(IBAction)setrepeater:(id)sender
{
	UIButton *button1 = (UIButton *)sender;
	
	if ([button1 tag] > 1000 && [button1 tag] <= 3000) 
	{
		if ([button1 tag] > 1000 && [button1 tag] <= 2000) 
		{
			temprbuttontag1 = [button1 tag];
			NSLog(@"temprbutton = %d", temprbuttontag1);
			
			if ([button1 tag] != repeatfromtag) 
			{
				[button1 setBackgroundColor:[UIColor redColor]];
				repeatfromtag = [button1 tag];
				firstselector = TRUE;
				
					for (UIButton *search in self.view.subviews)
					{
						if ([search isKindOfClass:[UIButton class]]
							&& [search tag] > 1000 && [search tag] <= 2000
							&& [search tag] != [button1 tag])
							{
								[search setBackgroundColor:[UIColor blackColor]];
								NSLog(@"repeatfromtag = searchtag----%d", repeatfromtag);
							}
					}
			}
			else if([button1 tag] == repeatfromtag)
			{
					[button1 setBackgroundColor:[UIColor blackColor]];
					firstselector = FALSE;
					repeatfromtag = 0;
			}
		}
		
		
		
		if ([button1 tag] > 2000 && [button1 tag] <= 3000) 
		{
			temprbuttontag2 = [button1 tag];
			
			if ([button1 tag] != repeattotag) 
			{
				[button1 setBackgroundColor:[UIColor redColor]];
				repeattotag = [button1 tag];
				secondselector = TRUE;
				
				for (UIButton *search in self.view.subviews)
				{
					if ([search isKindOfClass:[UIButton class]]
						&& [search tag] > 2000 && [search tag] <= 3000
						&& [search tag] != [button1 tag])
						{
							[search setBackgroundColor:[UIColor blackColor]];
							NSLog(@"repeattotag searchtag = %d", repeattotag);
						}
				}
			}
			else if ([button1 tag] == repeattotag) 
			{
				[button1 setBackgroundColor:[UIColor blackColor]];
				secondselector = FALSE;
				repeattotag = 0;
			}
		}
	}
	NSLog(@"this tag is %d", [button1 tag]);
	NSLog(@"repeattotag = %d", repeattotag);
	NSLog(@"repeatfromtag = %d", repeatfromtag);
	NSLog(@"____________");
	if (repeattotag >= (repeatfromtag+1000)) 
	{
		repeat = TRUE;
		NSLog(@"repeat is on");
	}
}


-(IBAction)openrepeaterview:(id)sender;
{
	[self presentModalViewController:RepeaterView animated:YES];
}

- (void)writerepeater:(NSString*)repeatstring 
{
	numberofrepeats = [repeatstring intValue];
	[repeatlabelbutton setTitle:repeatstring forState:(UIControlStateNormal)];
}








-(IBAction) saveXML:(id) sender
{
	NSMutableArray *segtitlearray = [[NSMutableArray alloc] init];
	int tagarray[1600];
	int tagindex = 0;
	
	for (UIButton *search in self.view.subviews)
	{
		if ([search isKindOfClass:[UIButton class]] 
			&& [search.titleLabel.text isEqualToString:@"-"] == FALSE
			&& [search.titleLabel.text length] <= 2
			&& [search tag] > 3000)
		{
			temptag = search.tag;
			[segtitlearray insertObject:[[search titleLabel] text] atIndex:tagindex];
			tagarray[tagindex] = temptag;
			
			tagindex = tagindex + 1;
		}
	}
	
	tagnsarray = [[NSMutableArray alloc]
				  initWithCapacity: tagindex];
	

	int length = [myArray count];
	NSNumber *number;
	NSString *segtitle;
	NSString *timeofnote;
	NSString *notetime;
	for (int i = 0; i < tagindex; i++)
	{
		segtitle = [segtitlearray objectAtIndex:i];	
		number = [NSNumber numberWithInt: tagarray[i]];
		NSLog(@"number = %@", number);
		for (int j = 0; j < length; j++) 
		{
			NSMutableArray *tempArray = [[NSMutableArray alloc] init];
			tempArray = [myArray objectAtIndex:j];
			notetime = [tempArray objectAtIndex:0];
			NSString *notetag = [tempArray objectAtIndex:1];
			NSLog(@"notetime = %@", notetime);
			NSLog(@"notetag = %@", notetag);
			
			int tagvalue = [notetag intValue];
			
			if (tagvalue == [number intValue]) 
			{
				timeofnote = notetime;
			}
		}
		
		NSMutableArray *thisrow = [[NSMutableArray alloc] init];
		[thisrow insertObject:segtitle atIndex:0];
		[thisrow insertObject:number atIndex:1];
		[thisrow insertObject:timeofnote atIndex:2];
		[tagnsarray insertObject:thisrow atIndex:i];
		NSLog(@"%@", [tagnsarray objectAtIndex:i]);
	}
	
	
	for (int h = 0; h < 1600; h++) 
	{
		tagarray[h] = 0;
	}

	
	
	[saveFileView saveArray:tagnsarray];
	
	[self presentModalViewController:saveFileView animated:YES];
	
	[tagnsarray release];
}


-(IBAction) openXML:(id) sender
{
	[self presentModalViewController:openFileView animated:YES];
}

-(void)openfilenow
{
	NSLog(@"opener happened");
	showopener = TRUE;
	[self viewDidLoad];
	
}

-(void)FileToOpen: (NSArray *)fileArray
{
	for (int i = 0; i < [fileArray count]; i++) 
	{
		NSLog(@"-====>%@", [fileArray objectAtIndex:i]);
	}
	
//------------------------------------------------------------	

	for (UIButton *search in self.view.subviews)
	{
		if ([search isKindOfClass:[UIButton class]] 
			&& [search.titleLabel.text isEqualToString:@"-"] == FALSE
			&& [search.titleLabel.text length] <= 2
			&& [search tag] > 3000)
		{
			search.titleLabel.font = [UIFont boldSystemFontOfSize:20];
			[search setTitle:@"-" forState:(UIControlStateNormal)];
		}
	}
	int highesttag = 0;
	for (int i = 0; i < [fileArray count]; i++) 
	{
		NSArray *newArray = [fileArray objectAtIndex:i];
		NSNumber *segmenttag = [newArray objectAtIndex:1];

		if([segmenttag intValue] > highesttag)
		{
			highesttag = [segmenttag intValue];
		}
	}
	
	NSLog(@"highesttag%d", highesttag);
	[myArray removeAllObjects];
	
	int numberofnewstaffs = 0;
	
	numberofnewstaffs = ((highesttag%100000) - (highesttag%100))/100;
	
	NSLog(@"numberofnewstaffs%d", numberofnewstaffs);
	
	for (int j = 0; j < numberofnewstaffs; j++) 
	{
		[self addstaffinload];
	}
	
	for (int i = 0; i < [fileArray count]; i++) 
	{
		NSArray *newArray = [fileArray objectAtIndex:i];
		NSNumber *segmentnote = [newArray objectAtIndex:0];
		NSNumber *segmenttag = [newArray objectAtIndex:1];
		NSString *segmentlength = [newArray objectAtIndex:2];
			for (UIButton *search in self.view.subviews)
			{
				if ([search isKindOfClass:[UIButton class]] && [search tag] == [segmenttag intValue] ) 
				{
					search.titleLabel.font = [UIFont boldSystemFontOfSize:15];
					[search setTitle:segmentnote forState:UIControlStateNormal];
					NSMutableArray *thisrow = [[NSMutableArray alloc] init];
					[thisrow insertObject:segmentlength atIndex:0];
					[thisrow insertObject:segmenttag atIndex:1];
					[myArray insertObject:thisrow atIndex:i];
				}
				else 
				{
					//NSLog(@"segment could not be found");
				}

			}
	}
}





-(IBAction) removestaff:(id) sender
{
	int temptag = 0;
	int repeatertemptag = 0;
	if (staffx == 0 || staffnum == 1) 
	{
		return;
	}
	else
	{	
		for (UIButton *search in self.view.subviews)
		{
			if ([search isKindOfClass:[UIButton class]]
				&& [search.titleLabel.text length] <= 2)
			{
				if (temptag < search.tag) 
				{
					temptag = search.tag;
				}

			}
			if ([search isKindOfClass:[UIButton class]]
				&& [search tag] > 1000 && [search tag] < 3000)
			{
				if (repeatertemptag < search.tag) 
				{
					repeatertemptag = search.tag;
				}
				
			}
		}
		
		
		for (int i = 0; i < 2; i++) 
		{
			for (UIButton *search2 in self.view.subviews)
			{
				if (search2.tag == repeatertemptag) 
				{
					[search2 removeFromSuperview];
					repeatertemptag = repeatertemptag-1000;
				}
			}
		}
		
		NSLog(@"pre %d", temptag);
		
			for (int j = 0; j < 6; j++) 
			{	
				for (int i = 0; i < 32; i++) 
				{
						for (UIButton *search2 in self.view.subviews)
						{
							if (search2.tag == temptag) 
							{
								[search2 removeFromSuperview];
								if (temptag % 100 == 0) 
								{
									temptag = temptag - 100000 + 31;
								}
								else 
								{
									temptag = temptag--;
								}
						}
					}
				}	
			}
	
	NSLog(@"%d", temptag);
	staffx = staffx - 145;
		if (staffnum > 1) 
		{
			staffnum = staffnum - 1;
		}
	}
}
	
-(IBAction) addstaff:(id) sender{
	int stringnum = 6;
	int increment = 20;
	for (int i = 0; i < 2; i++) 
	{
		UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];	
		btn.frame = CGRectMake(increment, staffx + 240, 16, 142);
		[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[btn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
		[btn setBackgroundColor:[UIColor blackColor]];
		[btn setTag:staffnum + 1001 + i*1000 ];
		[btn addTarget:self action:@selector(setrepeater:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btn];
		increment = increment + 559;
	}
	
	
	for (int j = 0; j < 6; j++) 
	{	
		for (int i = 0; i < 32; i++) 
		{
		UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];	
			btn.frame = CGRectMake(40 + i*16.5, staffx + 250 + j*20, 25, 29);
			[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[btn setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
			[btn setBackgroundColor:[UIColor grayColor]];
			btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];		
			[btn setTitle:@"-" forState:UIControlStateNormal];
			[btn setTag:(100000*(stringnum-j))+(staffnum*100)+i];
			[btn addTarget:self action:@selector(displayView:) forControlEvents:UIControlEventTouchUpInside];
			[btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
			[self.view addSubview:btn];
		}
	}
	staffx = staffx + 145;
	staffnum = staffnum + 1;
	NSLog(@"staffx is:%d", staffx);
}

-(void)addstaffinload
{
	int stringnum = 6;
	int increment = 20;
	for (int i = 0; i < 2; i++) 
	{
		UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];	
		btn.frame = CGRectMake(increment, staffx + 240, 16, 142);
		[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[btn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
		[btn setBackgroundColor:[UIColor blackColor]];
		[btn setTag:staffnum + 1001 + i*1000 ];
		[btn addTarget:self action:@selector(setrepeater:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btn];
		increment = increment + 559;
	}
	for (int j = 0; j < 6; j++) 
	{	
		for (int i = 0; i < 32; i++) 
		{
			UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];	
			btn.frame = CGRectMake(40 + i*16.5, staffx + 240 + j*20, 25, 29);
			[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[btn setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
			[btn setBackgroundColor:[UIColor grayColor]];
			btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];		
			[btn setTitle:@"-" forState:UIControlStateNormal];
			[btn setTag:(100000*(stringnum-j))+(staffnum*100)+i];
			[btn addTarget:self action:@selector(displayView:) forControlEvents:UIControlEventTouchUpInside];
			[btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
			[self.view addSubview:btn];
		}
	}
	staffx = staffx + 145;
	staffnum = staffnum + 1;
	NSLog(@"staffx is:%d", staffx);
}




-(IBAction) displayView:(id) sender
{
	NSString *timeofnote;
	NSString *sendertext;
	if ([myArray count] != 0) 
	{
	
	for (int i = 0; i < [myArray count]; i++) 
	{
		NSMutableArray *tempArray = [[NSMutableArray alloc] init];
		tempArray = [myArray objectAtIndex:i];
		NSString *notetime = [tempArray objectAtIndex:0];
		NSString *notetag = [tempArray objectAtIndex:1];
		
		if ([sender tag] == [notetag intValue]) 
		{
			timeofnote = notetime;
			sendertext = [[sender titleLabel] text];
			[secondview1 writeLabel:sendertext :timeofnote];
			break;
		}
	}
	}
	
	[self presentModalViewController:secondview1 animated:YES];
}

- (IBAction)change:(id)sender{

	UIButton *button1 = (UIButton *)sender;
	segbutton = button1;
	NSLog(@"Button tag is: %d", segbutton.tag);
	
	
}

- (void)writeToSegment:(NSString*) buf {

	[segbutton setTitle:buf forState:(UIControlStateNormal)];
	segbutton.titleLabel.font = [UIFont systemFontOfSize: 15];
	[self.view addSubview:segbutton];
	
	int bufint;
	bufint = [buf intValue];
	CGRect frame;
	
	frame = [segbutton frame];
	
	float xcoor = frame.origin.x;
	float ycoor = frame.origin.y;
	NSLog(@"x = %f", frame.origin.x);
	NSLog(@"y = %f", frame.origin.y);
	
	int incrementx = 0;
	
	for(int i = 0; i < 6; i++) 
	{
		if (segbutton.tag >= 100000*(i+1) && segbutton.tag <= 100000*(i+2)) 
		{
			incrementx = i+1;
			NSLog(@"incrementx = %d", incrementx);
		}
	}

	NSLog(@"incrementx = %d", incrementx);
	NSString *lengthstring;
	for (int j = 0; j < [myArray count]; j++) 
	{
		NSArray *newArray = [myArray objectAtIndex:j];
		NSString *segmentlength = [newArray objectAtIndex:0];
		NSNumber *segmenttag = [newArray objectAtIndex:1];
		NSLog(@"segmentnote = %@", segmentlength);
		NSLog(@"segmenttag = %d", [segmenttag intValue]);
		
		if ([segmenttag intValue] == segbutton.tag)
		{
			lengthstring = segmentlength;
		}
	}
	
	
	UILabel *lbl = [[UILabel alloc] init];	
	lbl.frame = CGRectMake(xcoor+2, ycoor+(24*incrementx), 30, 25);
	
	lbl.text = lengthstring;
	lbl.backgroundColor = [UIColor grayColor];
	lbl.font = [UIFont boldSystemFontOfSize:10];
	
	[self.view addSubview:lbl];

}

- (void)addnotetime:(NSString*) buf {
	if (buf != @"-") 
	{
	int tag = segbutton.tag;
		NSLog(@"addnote tag = %d", tag);
		for (int j = 0; j < [myArray count]; j++) 
		{
			
			NSMutableArray *temprow = [[NSMutableArray alloc] init];
			temprow = [myArray objectAtIndex:j];
			
			int tempcheck = [[temprow objectAtIndex:1] intValue];
			NSLog(@"tempcheck = %d", tempcheck);
			
			
			if (tempcheck == tag) 
			{
				NSLog(@"deleted %d", [myArray objectAtIndex:j]);
				[myArray removeObjectAtIndex:j];
			}
		}
		
	NSString* tagstr = [NSString stringWithFormat:@"%d", tag];
	NSMutableArray *thisrow = [[NSMutableArray alloc] init];
	[thisrow insertObject:buf atIndex:0];
	[thisrow insertObject:tagstr atIndex:1];
	[myArray addObject:thisrow];
	int length = [myArray count];
	for (int i = 0; i < length; i++) 
	{
		NSLog(@"array %@",[myArray objectAtIndex:i]);
	}
	
	int segtag = segbutton.tag;
	
	for (int i = 1; i < 16; i++) 
	{
		segtag = segtag + 1;
		for (UIButton *search in self.view.subviews)
		{
			if(search.tag == segtag)
			{
				
			}
			
		}
	}
	
	
	
	length = [myArray count];
	
	for (int i = 0; i < length; i++) 
	{
		NSMutableArray *tempArray = [[NSMutableArray alloc] init];
		tempArray = [myArray objectAtIndex:i];
		
		if (!tempArray) 
		{
			NSString *notetime = [tempArray objectAtIndex:0];
			NSString *notetag = [tempArray objectAtIndex:1];
			int tagvalue = [notetag intValue];
		
			if (segtag == tagvalue) 
			{
				if ([notetime isEqualToString: @"4/4"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*4);
				}
				if ([notetime isEqualToString: @"15/16"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*3.75);
				}
				if ([notetime isEqualToString: @"7/8"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*3.5);
				}
				if ([notetime isEqualToString: @"13/16"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*3.25);
				}
				if ([notetime isEqualToString: @"3/4"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*3);
				}
				if ([notetime isEqualToString: @"11/16"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*2.75);
				}
				if ([notetime isEqualToString: @"5/8"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*2.5);
				}
				if ([notetime isEqualToString: @"9/16"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*2.25);
				}
				if ([notetime isEqualToString: @"2/4"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*2);
				}
				if ([notetime isEqualToString: @"7/16"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*1.75);
				}
				if ([notetime isEqualToString: @"3/8"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*1.50);
				}
				if ([notetime isEqualToString: @"5/16"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*1.25);
				}
				if ([notetime isEqualToString: @"1/4"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*1);
				}
				if ([notetime isEqualToString: @"3/16"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*0.75);
				}
				if ([notetime isEqualToString: @"1/8"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*0.5);
				}
				if ([notetime isEqualToString: @"1/16"]) 
				{
					notelength = ((tempo/60)/((tempo/60)*(tempo/60))*0.25);
				}
			}
		}	
	}
	}//end first if
}//end addnote

-(void)opener
{
	[self presentModalViewController:opencontroller animated:YES];
}









- (void)applicationDidFinishLaunching{
	
	NSLog(@"stuff");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)Audio successfully:(BOOL)flag
{
	[Audio release];
	playbackDelay = 0.0;
}

- (void)viewDidUnload {
}

- (void)viewDidLoad {
	secondview1 = [[SecondViewController alloc] init];
	secondview1.Obj = self;

	openFileView = [[openFile alloc] init];
	openFileView.Obj2 = self;
	opencontroller = [[openingController alloc] init];
	opencontroller.Obj1 = self;
	tempoview = [[Tempo alloc] init];
	tempoview.Obj3 = self;
	RepeaterView = [[RepeatView alloc] init];
	RepeaterView.Obj4 = self;
	
	if (showopener == TRUE) 
	{
		NSLog(@"showopener is true");
		[self presentModalViewController:openFileView animated:YES];
		showopener = FALSE;
	}
	[super viewDidLoad];
}

/*
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return tempScrollView;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale 
{
	//tempScrollView=(UIScrollView *)self.view;
	NSLog(@"scale %f", scale);
	//float scalecal;
	
    //tempScrollView.contentSize = CGSizeMake(800*scale, 960*scale);
	tempScrollView.contentSize=CGSizeMake(800,960);
	tempScrollView.maximumZoomScale = 1.0;
	tempScrollView.minimumZoomScale = 0.0;
	tempScrollView.delegate = self;
	tempScrollView.clipsToBounds = YES;
	tempScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	//[tempScrollView setZoomScale: scale];
	//[tempScrollView setNeedsDisplay];
}  
*/

- (void)dealloc {
	[openFileView release];
	[tempScrollView release];
	[RepeaterView release];
	[textField release];
	[segbutton release];
	[label release];
	[string release];
	[secondview1 release];
	[tempoview release];
	[myArray release];
	[note release];
	[tagnsarray release];
	[sortedtagnsarray release];
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
