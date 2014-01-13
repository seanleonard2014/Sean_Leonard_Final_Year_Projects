
#import <Foundation/Foundation.h>
#import "openFile.h"

@interface openingController : UIViewController  {

	UIButton *button1;
	UIButton *button2;
	IBOutlet openFile *openFileView;
	UIViewController *Obj1;
}


@property (nonatomic, retain) IBOutlet UIButton *button1;
@property (nonatomic, retain) IBOutlet UIButton *button2;
@property (nonatomic, retain) IBOutlet IBOutlet openFile *openFileView;
@property (nonatomic, assign) UIViewController *Obj1;

- (IBAction)play1:(id) sender;
- (IBAction)openafile:(id) sender;
@end
