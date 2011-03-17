//
//  Copyright (c) 2011 Aaron Brethorst
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "StackPanel.h"

@interface StackPanel ()
- (void)configureView;
@end

@implementation StackPanel
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self configureView];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self configureView];
	}
	
	return self;
}

- (void)dealloc
{
	self.delegate = nil;
	[cells release];
	[tableView release];
	[super dealloc];
}

#pragma mark -
#pragma mark Private

- (void)configureView
{
	self.delegate = nil;
	cells = [[NSMutableArray alloc] init];
	
	tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self addSubview:tableView];
}

#pragma mark -
#pragma mark Public Methods

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
	[super setBackgroundColor:backgroundColor];
	tableView.backgroundColor = backgroundColor;
}

- (void)addStackedView:(UIView *)v
{
	[self addStackedView:v reload:YES];
}

- (void)addStackedView:(UIView *)v reload:(BOOL)yn
{
	assert(nil != v);
	
	UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	CGRect cellFrame = cell.frame;
	cellFrame.size = v.frame.size;
	cell.frame = cellFrame;
	[cell.contentView addSubview:v];
	
	[cells addObject:cell];
	
	[cell release];

	if (yn)
	{
		[tableView reloadData];
	}
}

- (void)addStackedViews:(NSArray*)a
{
	for (UIView *v in a)
	{
		[self addStackedView:v reload:NO];
	}

	[tableView reloadData];
}

- (void)removeStackedViewAtIndex:(NSInteger)index
{
	[self removeStackedViewAtIndex:index animation:UITableViewRowAnimationNone];
}

- (void)removeStackedViewAtIndex:(NSInteger)index animation:(UITableViewRowAnimation)rowAnimation
{
	if ([cells count] > index)
	{
		[cells removeObjectAtIndex:index];
	}
	
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]]
					 withRowAnimation:rowAnimation];
}

- (void)removeStackedView:(UIView*)aView
{
	[self removeStackedView:aView animation:UITableViewRowAnimationNone];
}

- (void)removeStackedView:(UIView*)aView animation:(UITableViewRowAnimation)rowAnimation
{
	for (int i=0; i<[cells count]; i++)
	{
		UITableViewCell *cell = [cells objectAtIndex:i];
		if (aView == [cell.contentView.subviews objectAtIndex:0])
		{
			[self removeStackedViewAtIndex:i animation:rowAnimation];
		}
	}
}

- (void)reloadStack
{
	[tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
	return [cells count];
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIView *v = [cells objectAtIndex:indexPath.row];
	return v.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [cells objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	SEL selector = @selector(stackPanel:didSelectView:);
	if (self.delegate && [self.delegate respondsToSelector:selector])
	{
		UITableViewCell *tappedCell = [cells objectAtIndex:indexPath.row];
		UIView *tappedView = [tappedCell.contentView.subviews objectAtIndex:0];
		[self.delegate performSelector:selector withObject:self withObject:tappedView];
	}
}

@end
