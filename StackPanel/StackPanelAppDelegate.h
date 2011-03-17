//
//  StackPanelAppDelegate.h
//  StackPanel
//
//  Created by Aaron Brethorst on 3/14/11.
//  Copyright 2011 Structlab LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackPanel.h"

@interface StackPanelAppDelegate : NSObject <UIApplicationDelegate>
{
	StackPanel *stackPanel;
}
@property(nonatomic,retain) IBOutlet StackPanel *stackPanel;
@property (nonatomic, retain) IBOutlet UIWindow *window;
- (IBAction)deleteTopItem:(id)sender;
@end
