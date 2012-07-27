//
//  ErrorController.m
//  MacBNetGatewayEditor
//
//  Created by Jeremy Knope on Sun May 16 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ErrorController : NSObject
{
    IBOutlet id errorDesc;
    IBOutlet id errorSheet;
    IBOutlet id errorTitle;
}
- (void)displayError:(NSString *)title onWindow:(NSWindow *)win;
- (void)displayError:(NSString *)title onWindow:(NSWindow *)win withDescription:(NSString*)desc;
- (IBAction)closeError:(id)sender;
@end
