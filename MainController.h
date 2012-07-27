//
//  MainController.h
//  MacBNetGatewayEditor
//
//  Created by Jeremy Knope on Sun May 16 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class GatewayLists;
@class ErrorController;

@interface MainController : NSObject
{
    IBOutlet id gatewayView;
	IBOutlet id gatewayTable;
    IBOutlet id mainWindow;
    IBOutlet id tabView;
	
	IBOutlet id gamedataportScreen;
	
	IBOutlet id err;
	NSString *currGame;
	
	GatewayLists *lists;
}
- (void)awakeFromNib;
- (IBAction)addGateway:(id)sender;
- (IBAction)removeGateway:(id)sender;
- (IBAction)saveGateways:(id)sender;
- (IBAction)moveGatewayUp:(id)sender;
- (IBAction)moveGatewayDown:(id)sender;

- (IBAction)vdefaultButtonChecked:(id)sender;

- (void)tabView:(NSTabView *)aTabView willSelectTabViewItem:(NSTabViewItem *)viewItem;
@end
