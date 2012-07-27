//
//  ErrorController.m
//  MacBNetGatewayEditor
//
//  Created by Jeremy Knope on Sun May 16 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//
#import "ErrorController.h"

@implementation ErrorController

- (void)displayError:(NSString *)title onWindow:(NSWindow *)win {
	[self displayError:title onWindow:win withDescription:@""];
}

- (void)displayError:(NSString *)title onWindow:(NSWindow *)win withDescription:(NSString*)desc {
	[errorTitle setStringValue:title];
	[errorDesc setStringValue:desc];
	[NSApp beginSheet:errorSheet modalForWindow:win modalDelegate:self didEndSelector:NULL contextInfo:nil];
}

- (IBAction)closeError:(id)sender {
	[errorSheet orderOut:nil];
	[NSApp endSheet:errorSheet];
}

@end
