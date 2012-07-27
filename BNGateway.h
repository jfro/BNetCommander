//
//  BNGateway.h
//  MacBNetGatewayEditor
//
//  Created by Jeremy Knope on Sun May 16 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BNGateway : NSObject {
	NSString *name;
	NSString *address;
	int zone;
	BOOL vdefault;
}
- (id)init;
- (id)initWithName:(NSString *)newName;
- (id)initWithName:(NSString *)newName address:(NSString *)newAddr;
- (id)initWithName:(NSString *)newName address:(NSString *)newAddr zone:(int)newZone;
- (id)initWithName:(NSString *)newName address:(NSString *)newAddr zone:(int)newZone vdefault:(BOOL)newDefault;

- (void)setName:(NSString *)newName;
- (NSString *)name;

- (void)setAddress:(NSString *)newAddr;
- (NSString *)address;

- (void)setZone:(int)newZone;
- (int)zone;

- (void)setDefault:(bool)newDefault;
- (BOOL)vdefault;

@end
