

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "SecondViewController.h"
#import "openingController.h"
#import "openFile.h"
#import "saveFile.h"
#import "RepeatView.h"
#import "Tempo.h"
#import <pthread.h>

@interface soundplayerViewController : UIViewController <AVAudioPlayerDelegate, UIScrollViewDelegate>
{
	UIButton *staffbutton;
	UIButton *playbutton;
	UIButton *stopbutton;
	UIButton *segbutton;
	UIButton *tempobutton;
	UIButton *tempolabelbutton;
	UIButton *repeatButton1;
	UIButton *repeatButton2;
	UIButton *repeatsetterbutton;
	UIButton *repeatlabelbutton;
	UIButton *metbutton;
	UIButton *metlabelbutton;
	UILabel *label;
	NSString *string;
	
	UITextField *textField;
	IBOutlet SecondViewController *secondview1;
	AVAudioPlayer *theAudio;
	AVAudioPlayer *Metronome;
	IBOutlet openingController *opencontroller;
	pthread_mutex_t lock;
	UIScrollView *tempScrollView;
	IBOutlet openFile *openFileView;
	IBOutlet saveFile *saveFileView;
	IBOutlet Tempo *tempoview;
	IBOutlet RepeatView *RepeaterView;
	IBOutlet UILabel *tempolabel;
}


@property (nonatomic, retain) AVAudioPlayer *theAudio;
@property (nonatomic, retain) AVAudioPlayer *Metronome;
@property (nonatomic, retain) IBOutlet UIButton *staffbutton;
@property (nonatomic, retain) IBOutlet UIButton *playbutton;
@property (nonatomic, retain) IBOutlet UIButton *stopbutton;
@property (nonatomic, retain) IBOutlet UIButton *segbutton;
@property (nonatomic, retain) IBOutlet UIButton *tempobutton;
@property (nonatomic, retain) IBOutlet UIButton *repeatButton1;
@property (nonatomic, retain) IBOutlet UIButton *repeatButton2;
@property (nonatomic, retain) IBOutlet UIButton *tempolabelbutton;
@property (nonatomic, retain) IBOutlet UIButton *repeatsetterbutton;
@property (nonatomic, retain) IBOutlet UIButton *repeatlabelbutton;
@property (nonatomic, retain) IBOutlet UIButton *metbutton;
@property (nonatomic, retain) IBOutlet UIButton *metlabelbutton;
@property (nonatomic, retain) IBOutlet UILabel *label;

@property (nonatomic, copy) NSString *string;
@property (nonatomic, retain) IBOutlet SecondViewController *secondview1;
@property (nonatomic, retain) IBOutlet openingController *opencontroller;
@property (nonatomic, retain) IBOutlet UIScrollView *tempScrollView;
@property (nonatomic, retain) IBOutlet openFile *openFileView;
@property (nonatomic, retain) IBOutlet saveFile *saveFileView;
@property (nonatomic, retain) IBOutlet Tempo *tempoview;
@property (nonatomic, retain) IBOutlet RepeatView *RepeaterView;
@property (nonatomic, retain) IBOutlet UILabel *tempolabel;

-(IBAction)displayView:(id)sender;
-(IBAction)playSound;
-(IBAction)stopSound:(id)sender;
-(IBAction)clearstaff;
-(IBAction)change:(id)sender;
-(IBAction)addstaff:(id) sender;
-(IBAction)removestaff:(id) sender;
-(IBAction)saveXML:(id) sender;
-(IBAction)setrepeater:(id)sender;
-(IBAction)changeTempo;
-(IBAction)openXML:(id) sender;
-(IBAction)setrepeater:(id)sender;
-(IBAction)openrepeaterview:(id)sender;
-(void)writeToSegment:(NSString*) buf; 
-(void)playnote:(NSString*)n :(AVAudioPlayer *)theAudiofade :(UIButton *)button;
-(void)fadeOut:(AVAudioPlayer *)theAudiotofade;
-(void)firstchangeColor:(UIButton *)button;
-(void)changeColor:(UIButton *)button;
-(void)addnotetime:(NSString*) buf;
-(void)opener;
-(void)openfilenow;
-(void)writeTempo:(NSString *)tempostring;
-(void)applicationDidFinishLaunching;
-(IBAction)playMetronome;
-(NSString *)pathOfFile;
@end

