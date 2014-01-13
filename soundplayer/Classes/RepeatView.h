

#import <UIKit/UIKit.h>


@interface RepeatView : UIViewController <UIScrollViewDelegate>
{
	UIButton *gobackbutton;
	UIViewController *Obj4;
	UIScrollView *tempScrollView;
}

@property (nonatomic, retain) IBOutlet UIButton *gobackbutton;
@property (nonatomic, assign) UIViewController *Obj4;
@property (nonatomic, retain) IBOutlet UIScrollView *tempScrollView;

-(IBAction)setrepeaterfunc:(id) sender;
-(IBAction)goback:(id)sender;
@end
