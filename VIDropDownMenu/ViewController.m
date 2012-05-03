//
//  ViewController.m
//  VIDropDownMenu
//
//  Created by Bracken Spencer <bracken.spencer@vokalinteractive.com>.
//  Copyright (c) 2012 Vokal Interactive. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *menuTextField;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) NSArray *menuItemsArray;

- (IBAction)menuButtonTapped:(id)sender;

@end

@implementation ViewController

@synthesize menuTextField;
@synthesize menuTableView;
@synthesize menuItemsArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.menuTableView setDelegate:self];
    [self.menuTableView setDataSource:self];
    [self.menuTableView setHidden:YES];
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.menuTableView setBounces:NO];
    
    [self.menuTextField setDelegate:self];
    
    self.menuItemsArray = [[NSArray alloc] initWithObjects:@"Item #1", @"Item #2", @"Item #3", @"Item #4", @"Item #5", nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - IBActions

- (IBAction)menuButtonTapped:(id)sender
{
    [self toggleMenuState];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return ([self.menuItemsArray count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
	[[cell textLabel] setText:[self.menuItemsArray objectAtIndex:indexPath.row]];
    
    return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.menuTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *selectedString = [self.menuItemsArray objectAtIndex:indexPath.row];
    [self.menuTextField setText:selectedString];
    
    [self toggleMenuState];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - "Menu" open/close

- (void)toggleMenuState
{
    if (self.menuTableView.hidden) {
        
        CGFloat xCoord = (self.menuTextField.frame.origin.x + 5.0f);
        CGFloat yCoord = (self.menuTextField.frame.origin.y + self.menuTextField.frame.size.height - 1.0f);
        CGFloat width = (self.menuTextField.frame.size.width - 10.0f);
        CGFloat height = (float)(44.0f * [self.menuItemsArray count] + 0.0f);
        
        CGFloat heightAllowed = (self.view.frame.size.height - self.menuTableView.frame.origin.y);
        if (height > heightAllowed) {
            height = heightAllowed;
        }
        
        [self.menuTableView setFrame:CGRectMake(xCoord, yCoord, width, self.menuTextField.frame.size.height)];
        [self.menuTableView setAlpha:0.0f];
        [self.menuTableView setHidden:NO];
        [UIView animateWithDuration:0.2f
                         animations:^{
                             [self.menuTableView setAlpha:1.0f];
                             [self.menuTableView setFrame:CGRectMake(xCoord, yCoord, width, height)];
                             [[self.menuTableView layer] setMasksToBounds:NO];
                             [[self.menuTableView layer] setShadowOffset:CGSizeMake(3.0f, 3.0f)];
                             [[self.menuTableView layer] setShadowRadius:3.0f];
                             [[self.menuTableView layer] setShadowOpacity:0.5f];
                             [[self.menuTableView layer] setShadowPath:[UIBezierPath bezierPathWithRect:self.menuTableView.bounds].CGPath];
                         }];
    } else {
        
        [UIView animateWithDuration:0.2f
                         animations:^{
                             [self.menuTableView setAlpha:0.0f];
                         }];
        
        [self.menuTableView setHidden:YES];
    }
}

@end
