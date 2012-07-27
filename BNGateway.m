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
	self = [self initWithName:[[NSString alloc] init]];
    if(self) {
        
    }
	return self;
}

- (id)initWithName:(NSString *)newName {
	self = [self initWithName:newName address:[NSString stringWithString:@""]];
    if(self) {
        
    }
	return self;
}
- (id)initWithName:(NSString *)newName address:(NSString *)newAddr {
	self = [self initWithName:newName address:newAddr zone:0 vdefault:NO];
    if(self) {
        
    }
	return self;
}
- (id)initWithName:(NSString *)newName address:(NSString *)newAddr zone:(int)newZone {
	self = [super init];
    if(self) {
        name = [newName retain];
        address = [newAddr retain];
        zone = newZone;
    }
	return self;
}
- (id)initWithName:(NSString *)newName address:(NSString *)newAddr zone:(int)newZone vdefault:(BOOL)newDefault {
	self = [super init];
	if(self) {
        name = [newName retain];
        address = [newAddr retain];
        zone = newZone;
        vdefault = NO;
    }
	return self;
}

- (void)dealloc {
	[name release];
	[address release];
	[super dealloc];
}

- (void)setName:(NSString *)newName {
    [newName retain];
    [name release];
	name = newName;
}

- (NSString *)name {
	return name;
}

- (void)setAddress:(NSString *)newAddr {
    [newAddr retain];
    [address release];
	address = newAddr;
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
