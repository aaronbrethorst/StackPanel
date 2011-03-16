//
//  StackPanelAppDelegate.m
//  StackPanel
//
//  Created by Aaron Brethorst on 3/14/11.
//  Copyright 2011 Structlab LLC. All rights reserved.
//

#import "StackPanelAppDelegate.h"

@implementation StackPanelAppDelegate

@synthesize stackPanel;
@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	for (int i=0; i<10; i++)
	{
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, (50 * i) + 50)];
		label.textAlignment = UITextAlignmentCenter;
		label.text = [NSString stringWithFormat:@"%@", [label description]];
		label.textColor = [UIColor whiteColor];
		label.numberOfLines	= 0;
		label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
		label.backgroundColor = i%2 == 0 ? [UIColor redColor] : [UIColor blueColor];
		[self.stackPanel addStackedView:label reload:NO];
	}
	[self.stackPanel reloadStack];
	
	[self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
	[stackPanel release];	
	[_window release];
    [super dealloc];
}

@end
