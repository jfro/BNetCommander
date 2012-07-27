//
//  BNGateway.m
//  MacBNetGatewayEditor
//
//  Created by Jeremy Knope on Sun May 16 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import "BNGateway.h"


@implementation BNGateway
- (id)init {
	//[super init];
	[self initWithName:[[NSString alloc] init]];
	return self;
}

- (id)initWithName:(NSString *)newName {
	//[super init];
	[self initWithName:newName address:[NSString stringWithString:@""]];
	return self;
}
- (id)initWithName:(NSString *)newName address:(NSString *)newAddr {
	[self initWithName:newName address:newAddr zone:0 vdefault:NO];
	return self;
}
- (id)initWithName:(NSString *)newName address:(NSString *)newAddr zone:(int)newZone {
	[super init];
	
	name = [newName retain];
	address = [newAddr retain];
	zone = newZone;
	return self;
}
- (id)initWithName:(NSString *)newName address:(NSString *)newAddr zone:(int)newZone vdefault:(BOOL)newDefault {
	[super init];
	
	name = [newName retain];
	address = [newAddr retain];
	zone = newZone;
	vdefault = NO;
	return self;
}

- (void)dealloc {
	[name release];
	[address release];
	[super dealloc];
}

- (void)setName:(NSString *)newName {
	name = [newName retain];
}

- (NSString *)name {
	return name;
}

- (void)setAddress:(NSString *)newAddr {
	address = [newAddr retain];
}

- (NSString *)address {
	return address;
}

- (void)setZone:(int)newZone {
	zone = newZone;
}

- (int)zone {
	return zone;
}

- (void)setDefault:(bool)newDefault {
	vdefault = newDefault;
}

- (BOOL)vdefault {
	return vdefault;
}

@end
