//
//  MainController.m
//  MacBNetGatewayEditor
//
//  Created by Jeremy Knope on Sun May 16 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import "MainController.h"
#import "GatewayLists.h"
#import "ErrorController.h"
#import "BNGateway.h"

@implementation MainController
// *** make the app quit when the last window closes (main window...)
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (void)awakeFromNib {
	OSType appType = kLSUnknownCreator;
	CFURLRef appURL;
	NSString *appName = @"Warcraft III.app";
	OSStatus errNo = LSFindApplicationForInfo(appType, NULL, (CFStringRef)appName, NULL, &appURL);
	if(errNo == noErr) {
		NSLog(@"App URL: %@", (NSURL *)appURL);
		CFRelease(appURL);
	}
	
	NSTabViewItem *tempItem;
	
	// Make vdefault in the table a button!
	NSTableColumn *vdefault;

    NSButtonCell *cell;
    cell = [[NSButtonCell alloc] init];
    [cell setButtonType:NSRadioButton];
    [cell setTitle:@" "]; // I don't want any text displayed
    [cell setAction:@selector(vdefaultButtonChecked:)];
    [cell setTarget:self];

    vdefault = [gatewayTable tableColumnWithIdentifier:@"vdefault"];
    [vdefault setDataCell:cell];
    [cell release];
  
  	lists = [[GatewayLists alloc] init];
	if(![lists hasSC] && ![lists hasD2] && ![lists hasW3]) {
		// no games!
		[mainWindow makeKeyAndOrderFront:nil];
		//[err displayError:@"No games found" onWindow:mainWindow withDescription:@"You must have Starcraft, Diablo 2, or Warcraft III installed and run at least once to use this program"];
		[err displayError:@"No games found" onWindow:mainWindow withDescription:@"You must have Starcraft, or Diablo 2 installed and run at least once to use this program"];
		return;
	}
	if([lists hasSC]) {
//		NSLog(@"Got SC");
		tempItem = [[NSTabViewItem alloc] initWithIdentifier:@"starcraft"];
		[tempItem setLabel:@"Starcraft"];
		[tempItem setView:gatewayView];
		[tabView addTabViewItem:tempItem];
		[tempItem release];
		[gamedataportScreen setIntValue:[lists port]];
	}
	if([lists hasD2]) {
//		NSLog(@"Got D2");
		tempItem = [[NSTabViewItem alloc] initWithIdentifier:@"diablo2"];
		[tempItem setLabel:@"Diablo 2"];
		[tempItem setView:gatewayView];
		[tabView addTabViewItem:tempItem];
		[tempItem release];
	}
	if([lists hasW3]) {
		//NSLog(@"Got W3");
		tempItem = [[NSTabViewItem alloc] initWithIdentifier:@"warcraft3"];
		[tempItem setLabel:@"Warcraft III"];
		[tempItem setView:gatewayView];
		[tabView addTabViewItem:tempItem];
		[tempItem release];
	}
	[gatewayTable setDataSource:lists];
	[lists retain];
	
	//[[tabView tabViewItemAtIndex:0] setView:gatewayView];
}

- (IBAction)addGateway:(id)sender
{
	BNGateway *gat;
	gat = [[BNGateway alloc] initWithName:@"NewGateway" address:@"somegateway.net" zone:-4 vdefault:NO];
	[lists addGateway:gat forGame:currGame];
	[gat release];
	[gatewayTable reloadData];
}

- (IBAction)removeGateway:(id)sender
{
	if([gatewayTable selectedRow] >= 0) {
		[lists removeGatewayAtIndex:[gatewayTable selectedRow] forGame:currGame];
		[gatewayTable reloadData];
	}
}

- (IBAction)saveGateways:(id)sender
{
	//need to determine if the port has been changed
	if ([gamedataportScreen intValue] == [lists port]) {
		NSLog(@"Game Data port has not changed");
	} else {
		[lists gameDataPortHasChanged:[gamedataportScreen intValue]];
	}
	if([lists saveResourceData])
		[err displayError:@"Successfully saved gateways" onWindow:mainWindow];
	else
		[err displayError:@"Failed to save gateways" onWindow:mainWindow withDescription:@"Contact Jfro for more help, imeepmeep@yahoo.com, subject: XBNGatewayEditor support"];
}

- (IBAction)vdefaultButtonChecked:(id)sender
{
    //NSLog(@"A button has been clicked");
    //NSLog(@"Need to deselect other buttons if they are checked and redisplay the table");
	if([gatewayTable selectedRow] >= 0) {
		[lists setDefaultGatewatAtIndex:[gatewayTable selectedRow] forGame:currGame];
		[gatewayTable reloadData];
		}
}

- (IBAction)moveGatewayUp:(id)sender;
{
	NSLog(@"User request to moveGatewayUp");
	if([gatewayTable selectedRow] > 0) {
		[lists moveGatewayUpFromIndex:[gatewayTable selectedRow] forGame:currGame];
		//[gatewayTable deselectRow:[gatewayTable selectedRow]];
		[gatewayTable reloadData];
		[gatewayTable selectRow:[gatewayTable selectedRow]-1 byExtendingSelection:NO];
	}
}
- (IBAction)moveGatewayDown:(id)sender;
{
	NSLog(@"User request to moveGatewayDown");
	if([gatewayTable selectedRow] >= 0) {
		[lists moveGatewayDownFromIndex:[gatewayTable selectedRow] forGame:currGame];
		//[gatewayTable deselectRow:[gatewayTable selectedRow]];
		[gatewayTable reloadData];
		[gatewayTable selectRow:[gatewayTable selectedRow]+1 byExtendingSelection:NO];
	}
}

// TabView delegate methods
- (void)tabView:(NSTabView *)aTabView willSelectTabViewItem:(NSTabViewItem *)viewItem {
	//NSLog(@"Tab view changed to %@",[viewItem identifier]);
	if(![[viewItem identifier] isEqualToString:@"about"]) {
		currGame = [[viewItem identifier] retain];
		[lists setCurrentGame:[viewItem identifier]];
		[gatewayTable reloadData];
		}
}
@end
