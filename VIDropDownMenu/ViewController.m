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
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) NSArray *menuItemsArray;

- (IBAction)menuButtonTapped:(id)sender;

@end

@implementation ViewController

@synthesize menuTextField;
@synthesize menuTableView;
@synthesize menuButton;
@synthesize menuItemsArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.menuTableView setDelegate:self];
    [self.menuTableView setDataSource:self];
    [self.menuTableView setHidden:YES];
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.menuTableView setBounces:NO];
    [self.menuTableView setRowHeight:self.menuTextField.frame.size.height];
    
    [self.menuTextField setDelegate:self];
    
    self.menuItemsArray = [[NSArray alloc] initWithObjects:@"Item #1", @"Item #2", @"Item #3", @"Item #4", @"Item #5", nil];
    
    [self.menuButton setImage:[UIImage imageNamed:@"arrow_down.png"] forState:UIControlStateNormal];
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
    [[cell textLabel] setFont:[self.menuTextField font]];
    
    return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.menuTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *selectedString = [self.menuItemsArray objectAtIndex:indexPath.row];
    [self.menuTextField setText:[NSString stringWithFormat:@" %@", selectedString]];
    
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
    [self.view endEditing:YES];
    
    if (self.menuTableView.hidden) {
        CGFloat xCoord = self.menuTextField.frame.origin.x;
        CGFloat yCoord = self.menuTextField.frame.origin.y + self.menuTextField.frame.size.height;
        CGFloat width = self.menuTextField.frame.size.width;
        CGFloat height = (float)(self.menuTextField.frame.size.height * [self.menuItemsArray count]);
        
        CGFloat heightAllowed = (self.view.frame.size.height - self.menuTableView.frame.origin.y);
        if (height > heightAllowed) {
            height = heightAllowed;
        }
        
        [self.menuTableView setFrame:CGRectMake(xCoord, yCoord, width, height)];
        [self.menuTableView setHidden:NO];
        [[self.menuTableView layer] setMasksToBounds:NO];
        [[self.menuTableView layer] setShadowOffset:CGSizeMake(3.0f, 3.0f)];
        [[self.menuTableView layer] setShadowRadius:3.0f];
        [[self.menuTableView layer] setShadowOpacity:0.5f];
        [[self.menuTableView layer] setShadowPath:[UIBezierPath bezierPathWithRect:self.menuTableView.bounds].CGPath];
        [self.menuButton setImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateNormal];
    } else {
        [self.menuTableView setHidden:YES];
        [self.menuButton setImage:[UIImage imageNamed:@"arrow_down.png"] forState:UIControlStateNormal];
    }
}

@end
