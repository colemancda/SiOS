//
//  LMSettingsController.m
//  SiOS
//
//  Created by Lucas Menge on 1/12/12.
//  Copyright (c) 2012 Lucas Menge. All rights reserved.
//

#import "LMSettingsController.h"

#import "LMEmulatorInterface.h"
#import "LMTableViewCellDelegate.h"
#import "LMTableViewNumberCell.h"
#import "LMTableViewSwitchCell.h"

NSString* const kLMSettingsSmoothScaling = @"SmoothScaling";
NSString* const kLMSettingsFullScreen = @"FullScreen";

NSString* const kLMSettingsSound = @"Sound";
NSString* const kLMSettingsAutoFrameskip = @"AutoFrameskip";
NSString* const kLMSettingsFrameskipValue = @"FrameskipValue";

@interface LMSettingsController(Privates) <LMTableViewCellDelegate>
@end

@implementation LMSettingsController(Privates)

- (void)done
{
  [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)toggleSmoothScaling:(UISwitch*)sender
{
  [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:kLMSettingsSmoothScaling];
}

- (void)toggleFullScreen:(UISwitch*)sender
{
  [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:kLMSettingsFullScreen];
}

- (void)toggleSound:(UISwitch*)sender
{
  [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:kLMSettingsSound];
}

- (void)toggleAutoFrameskip:(UISwitch*)sender
{
  [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:kLMSettingsAutoFrameskip];
}

- (void)cellValueChanged:(UITableViewCell*)cell
{
  if([[self.tableView indexPathForCell:cell] compare:_frameskipValueIndexPath] == NSOrderedSame)
    [[NSUserDefaults standardUserDefaults] setInteger:((LMTableViewNumberCell*)cell).value forKey:kLMSettingsFrameskipValue];
}

- (LMTableViewNumberCell*)numberCell
{
  static NSString* identifier = @"NumberCell";
  LMTableViewNumberCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil)
    cell = [[[LMTableViewNumberCell alloc] initWithReuseIdentifier:identifier] autorelease];
  return cell;
}

- (LMTableViewSwitchCell*)switchCell
{
  static NSString* identifier = @"SwitchCell";
  LMTableViewSwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
  if (cell == nil)
    cell = [[[LMTableViewSwitchCell alloc] initWithReuseIdentifier:identifier] autorelease];
  return cell;
}

@end

#pragma mark -

@implementation LMSettingsController

+ (void)setDefaultsIfNotDefined
{
  if([[NSUserDefaults standardUserDefaults] objectForKey:kLMSettingsFullScreen] == nil)
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLMSettingsFullScreen];
  
  if([[NSUserDefaults standardUserDefaults] objectForKey:kLMSettingsSmoothScaling] == nil)
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLMSettingsSmoothScaling];
  
  if([[NSUserDefaults standardUserDefaults] objectForKey:kLMSettingsSound] == nil)
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLMSettingsSound];
  
  if([[NSUserDefaults standardUserDefaults] objectForKey:kLMSettingsAutoFrameskip] == nil)
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLMSettingsAutoFrameskip];
  
  if([[NSUserDefaults standardUserDefaults] objectForKey:kLMSettingsFrameskipValue] == nil)
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kLMSettingsFrameskipValue];
}

@end

#pragma mark -

@implementation LMSettingsController(UITableViewController)

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self)
  {
    // Custom initialization
  }
  return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  if(section == 0)
    return 2;
  else if(section == 1)
    return 3;
  return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
  if(section == 0)
    return @"Full screen makes better use of the screen, but controls will be on top of the game.";
  else if(section == 1)
    return @"Auto-frameskip may appear slower due to a more inconsistent skip rate.";
  return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  
  UITableViewCell* cell = nil;
  
  if([indexPath compare:_smoothScalingIndexPath] == NSOrderedSame)
  {
    LMTableViewSwitchCell* c = (LMTableViewSwitchCell*)(cell = [self switchCell]);
    
    c.switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:kLMSettingsSmoothScaling];
    [c.switchView addTarget:self action:@selector(toggleSmoothScaling:) forControlEvents:UIControlEventValueChanged];
    c.textLabel.text = @"Smooth scaling";
  }
  else if([indexPath compare:_fullScreenIndexPath] == NSOrderedSame)
  {
    LMTableViewSwitchCell* c = (LMTableViewSwitchCell*)(cell = [self switchCell]);
    
    c.switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:kLMSettingsFullScreen];
    [c.switchView addTarget:self action:@selector(toggleFullScreen:) forControlEvents:UIControlEventValueChanged];
    c.textLabel.text = @"Full screen";
  }
  else if([indexPath compare:_soundIndexPath] == NSOrderedSame)
  {
    LMTableViewSwitchCell* c = (LMTableViewSwitchCell*)(cell = [self switchCell]);
    c.textLabel.text = @"Sound";
    c.switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:kLMSettingsSound];
    [c.switchView addTarget:self action:@selector(toggleSound:) forControlEvents:UIControlEventValueChanged];
  }
  else if([indexPath compare:_autoFrameskipIndexPath] == NSOrderedSame)
  {
    LMTableViewSwitchCell* c = (LMTableViewSwitchCell*)(cell = [self switchCell]);
    c.textLabel.text = @"Auto-frameskip";
    c.switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:kLMSettingsAutoFrameskip];
    [c.switchView addTarget:self action:@selector(toggleAutoFrameskip:) forControlEvents:UIControlEventValueChanged];
  }
  else if([indexPath compare:_frameskipValueIndexPath] == NSOrderedSame)
  {
    LMTableViewNumberCell* c = (LMTableViewNumberCell*)(cell = [self numberCell]);
    c.textLabel.text = @"Skip every";
    c.minimumValue = 0;
    c.maximumValue = 10;
    c.suffix = @"frames";
    c.allowsDefault = NO;
    c.value = [[NSUserDefaults standardUserDefaults] integerForKey:kLMSettingsFrameskipValue];
    c.delegate = self;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Navigation logic may go here. Create and push another view controller.
  /*
   <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   [detailViewController release];
   */
}

@end

#pragma mark -

@implementation LMSettingsController(UIViewController)

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Settings";
  
  UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
  self.navigationItem.rightBarButtonItem = doneButton;
  [doneButton release];
  
  _smoothScalingIndexPath = [[NSIndexPath indexPathForRow:0 inSection:0] retain];
  _fullScreenIndexPath = [[NSIndexPath indexPathForRow:1 inSection:0] retain];

  _soundIndexPath = [[NSIndexPath indexPathForRow:0 inSection:1] retain];
  _autoFrameskipIndexPath = [[NSIndexPath indexPathForRow:1 inSection:1] retain];
  _frameskipValueIndexPath = [[NSIndexPath indexPathForRow:2 inSection:1] retain];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  else
    return YES;
}

@end

#pragma mark -

@implementation LMSettingsController(NSObject)

- (id)init
{
  self = [self initWithStyle:UITableViewStyleGrouped];
  if(self)
  {
    [LMSettingsController setDefaultsIfNotDefined];
  }
  return self;
}

- (void)dealloc
{
  [_smoothScalingIndexPath release];
  _smoothScalingIndexPath = nil;
  [_fullScreenIndexPath release];
  _fullScreenIndexPath = nil;
  
  [_soundIndexPath release];
  _soundIndexPath = nil;
  [_autoFrameskipIndexPath release];
  _autoFrameskipIndexPath = nil;
  [_frameskipValueIndexPath release];
  _frameskipValueIndexPath = nil;
  
  [super dealloc];
}

@end
