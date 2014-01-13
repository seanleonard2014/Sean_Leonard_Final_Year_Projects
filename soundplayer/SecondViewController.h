

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SecondViewController : UIViewController <UIScrollViewDelegate>
{
	
	UILabel *label;
	UILabel *label2;
	UIButton *button;
	NSArray *myArray;
	UIViewController *Obj;
	UIButton *wholenote;
	UIButton *halfnote;
	UIButton *quartnote;
	UIButton *eighthnote;
	UIButton *sixteenthnote;
	UIScrollView *tempScrollView;
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet NSArray *myArray;
@property (nonatomic, assign) UIViewController *Obj;
@property (nonatomic, retain) IBOutlet UIButton *wholenote;
@property (nonatomic, retain) IBOutlet UIButton *halfnote;
@property (nonatomic, retain) IBOutlet UIButton *quartnote;
@property (nonatomic, retain) IBOutlet UIButton *eighthnote;
@property (nonatomic, retain) IBOutlet UIButton *sixteenthnote;
@property (nonatomic, retain) IBOutlet UIScrollView *tempScrollView;
-(IBAction) dismissView:(id) sender;
-(IBAction) changeButton:(id) sender;
-(void)writeLabel:(NSString*)fretnumber :(NSString *)timeofnote;
-(IBAction)goback;
@end
