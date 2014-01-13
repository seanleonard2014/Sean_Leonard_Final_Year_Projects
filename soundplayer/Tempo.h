

#import <UIKit/UIKit.h>


@interface Tempo : UIViewController 
{
	IBOutlet UISlider		*theSlider;
	IBOutlet UILabel	*theLabel;
	IBOutlet UIButton	*theButton;
	UIViewController *Obj3;
}

@property (nonatomic, retain)	UISlider *theSlider;
@property (nonatomic, retain)	UILabel	*theLabel;
@property (nonatomic, retain)	UIButton	*theButton;
@property (nonatomic, assign) UIViewController *Obj3;

-(IBAction)SliderMoved:(UISlider*)sender;
-(IBAction)goback:(id)sender;
@end
