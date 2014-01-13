

#import <UIKit/UIKit.h>


@interface saveFile : UIViewController <UITextFieldDelegate>
{
	UITextField *FileNameToSave;
	UIButton *savebutton;
	UIButton *gobackbutton;
}

@property (nonatomic, retain) IBOutlet UITextField *FileNameToSave;
@property (nonatomic, retain) IBOutlet UIButton *savebutton;
@property (nonatomic, retain) IBOutlet UIButton *gobackbutton;
-(void)saveArray:(NSMutableArray *)theArray;
-(IBAction)saveAndGo:(id)sender;
- (IBAction)goback:(id)sender;
@end
