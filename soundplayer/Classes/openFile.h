
#import <UIKit/UIKit.h>


@interface openFile : UIViewController 
{
	UIButton *openerbutton;
	UIButton *gobackbutton;
	UIViewController *Obj2;
}
@property (nonatomic, retain) IBOutlet UIButton *openerbutton;
@property (nonatomic, retain) IBOutlet UIButton *gobackbutton;
@property (nonatomic, assign) UIViewController *Obj2;

- (IBAction)goback:(id)sender;
- (IBAction)selectsong:(id)sender;
- (IBAction)deletesong:(id)sender;
@end
