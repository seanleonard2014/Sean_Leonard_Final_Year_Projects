

#import <UIKit/UIKit.h>

@class soundplayerViewController;

@interface soundplayerAppDelegate : NSObject <UIApplicationDelegate, UIScrollViewDelegate> {
    UIWindow *window;
    soundplayerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet soundplayerViewController *viewController;
@end

