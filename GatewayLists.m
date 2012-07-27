//
//  GatewayLists.m
//  MacBNetGatewayEditor
//
//  Created by Jeremy Knope on Sun May 16 2004.
//  Copyright (c) 2004 JfroWare. All rights reserved.
//

#import "GatewayLists.h"
#import "BNGateway.h"
#import "NDResourceFork.h"

@implementation GatewayLists
#pragma mark Initialization
- (id)init {
	[super init];
	W3gateways = [[NSMutableArray alloc] init];
	SCgateways = [[NSMutableArray alloc] init];
	D2gateways = [[NSMutableArray alloc] init];
	hasSC = NO;
	changedSC = NO;
	portLong = 0;
	changedport = NO;
	hasD2 = NO;
	changedD2 = NO;
	hasW3 = NO;
	changedW3 = NO;
	[self loadResourceData];
	return self;
}

- (void)dealloc {
	[W3gateways release];
	[SCgateways release];
	[D2gateways release];
	[war3Fork release];
	[bnetFork release];
	[super dealloc];
}

#pragma mark -
#pragma mark Data Access
- (void)loadResourceData {
	ResType type = 'HKEY';
	
	// access resource forks
	war3Fork = [NDResourceFork resourceForkForReadingAtPath:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),kWar3PrefsPath]];
	bnetFork = [NDResourceFork resourceForkForReadingAtPath:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),kBNetPrefsPath]];
	starFork = [NDResourceFork resourceForkForReadingAtPath:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),kStarPrefsPath]];

	if(war3Fork == nil) 
	    { // no war3 prefs
		NSLog(@"*** No WarCraft 3 preferences file");
		hasW3 = NO;
	    }
	else 
	    { // we got a pref file
		NSLog(@"Got war3 prefs");
		hasW3 = YES;
		NSData *w3data = [war3Fork dataForType:type named:kWar3RegPath];
		
		if(w3data != nil) {
			NSLog(@"Got WarCraft III data");
			w3Header = [[self processGatewayData:w3data intoArray:W3gateways] retain];
			NSLog(@"Done with w3 gateways");
		}
		else 
		    {
			// no data, but file is there... 
			NSLog(@"Error");
			error = YES;
			lastError = [NSString stringWithString:@"Unable to load gateways from Warcraft III Prefs, try launching Warcraft III once or connecting to Battle.net once with it"];
		}
	}
	
	// load sc/d2 now
	if(bnetFork == nil) {
		hasSC = NO; // neither, both are in same file now, as of 1.10
		hasD2 = NO;
	}
	else {
		// load both data chunks
		NSData *scData = [bnetFork dataForType:type named:kSCRegPath];
		if([scData length] > 11) {
			hasSC = YES;
			//NSLog(@"Loading into SCgateways");
			scHeader = [[self processGatewayData:scData intoArray:SCgateways] retain];
			//NSLog(@"Confirmed load into SCgateways");
			// Also load StarCraft Game Data Port if present
			NSData *scPort = [bnetFork dataForType:type named:kSCGameDataPort];
			// 00 00 00 04 00 00 3F 48
			hasSCport = NO;
			if ([scPort length] > 4) {
				hasSCport = YES;
				//NSLog(@"Loading StarCraft Game Data port");
				NSRange range = {4, [scPort length]-4}; 
				//NSLog(@"Loading StarCraft Game Data port %@", scPort); // <00000004 00003f48 >
				scGamePort = [scPort subdataWithRange:range];
				//NSLog(@"Loading StarCraft Game Data port %@", scGamePort); // <00003f48 > = 16200
			
				portLong = *((long*)[scGamePort bytes]);
				//uint8_t* scGamePortBytes = (uint8_t*)[scGamePort bytes]; 
				//uint32_t* scGamePortInt = (uint32_t*) scGamePortBytes; 
				//uint32_t port = *scGamePortInt; 
				//NSLog(@"Loading StarCraft Game Data port %d", portLong);
			} 
		} else {
			hasSC = NO;
			//NSLog(@"*** No data to load into SCgateways");
		}
		//NSLog(@"Check for Dialow registry entries");
		NSData *d2Data = [bnetFork dataForType:type named:kD2RegPath];
		if([d2Data length] > 11) {
			hasD2 = YES;
			//NSLog(@"Loading into D2gateways");
			d2Header = [[self processGatewayData:d2Data intoArray:D2gateways] retain];
			//NSLog(@"Confirmed load into D2gateways");
		} else {
			hasD2 = NO;
			//NSLog(@"*** No data to load into D2gateways");
		}
	}
	//NSLog(@"Done loading resources");
}

- (BOOL)saveResourceData {
	ResType type = 'HKEY';
	BOOL ret = YES;
	short scId = 0;
	short sxId = 0;
    short d2Id = 0;
    short w3Id = 0;
NSLog(@"%@", NSFileTypeForHFSTypeCode(type));
	//NSLog(@"####################");
	//NSLog(@"#Data save requested");
	//[war3Fork release];
	//[bnetFork release];
	//[starFork release];
	
	war3Fork = [NDResourceFork resourceForkForWritingAtPath:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),kWar3PrefsPath]];
	bnetFork = [NDResourceFork resourceForkForWritingAtPath:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),kBNetPrefsPath]];
  	starFork = [NDResourceFork resourceForkForWritingAtPath:[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),kStarPrefsPath]];

/*!
	@method getId:ofResourceType:named:
	@abstract Gets a named resource's resource id.
	@discussion Returns a resources id in a pointer to a <TT>short int</TT> and returns <TT>YES</TT> if retrieval of the id is succeeded. If <TT>getId:ofResourceType:named:</TT> returns <TT>NO</TT> then the value returned through the pointer <TT><I>anId</I></TT> is garabage.
	@param anID A pointer to an <TT>short int</TT> that on return contains the resources id, if the returned value is <TT>YES</TT>.
	@param aType The resource type of the resource for which you wish to retrieve the id.
	@param aName The resource name of the resource for which you wish to retrieve the id.
	@result A <TT>YES</TT> if retrieval was successful.
 */
//- (BOOL)getId:(short int *)anId ofResourceType:(ResType)aType named:(NSString *)aName;

	if(hasSC) {
	    if(![bnetFork getId:&scId ofResourceType:type named:kSCRegPath])
		    {NSLog(@"_saveResourceData Failed to get ResourceID for %@",kSCRegPath);}
	    if(![starFork getId:&sxId ofResourceType:type named:kSCRegPath])
		    {NSLog(@"_saveResourceData Failed to get ResourceID for %@",kSCRegPath);}
		}
    if(hasD2) {
	    if(![bnetFork getId:&d2Id ofResourceType:type named:kD2RegPath])
		{NSLog(@"_saveResourceData Failed to get ResourceID for %@",kD2RegPath);}
		}
    if(hasW3) {
	    if(![war3Fork getId:&w3Id ofResourceType:type named:kWar3RegPath]) {
			NSLog(@"_saveResourceData Failed to get ResourceID for %@",kWar3RegPath);
		}
	}

//	short scId = [bnetFork idForResourceType:type named:kSCRegPath];
//	short sxId = [starFork idForResourceType:type named:kSCRegPath];
//  short d2Id = [bnetFork idForResourceType:type named:kD2RegPath];
//  short w3Id = [war3Fork idForResourceType:type named:kWar3RegPath];
	// got ids, now start storin'
	if(changedW3 && hasW3) {
		if(w3Id != 0) {
			ret = [self saveGateways:W3gateways toFork:war3Fork withHeader:w3Header name:kWar3RegPath resId:w3Id];
		}
		else {
			NSLog(@"ERROR: Invalid war3 ID returned! %i",w3Id);
		}
	}
	if(changedSC && hasSC) {
		//NSLog(@"Starcraft configuration has changed - save requested");
		NSLog(@"Saving Starcraft data to Battle.net Preferences");
		ret = [self saveGateways:SCgateways toFork:bnetFork withHeader:scHeader name:kSCRegPath resId:scId];
		NSLog(@"Saving Starcraft data to Srarcraft Prefs");
		ret = [self saveGateways:SCgateways toFork:starFork withHeader:scHeader name:kSCRegPath resId:sxId];
		// the above line writes an identical copy of the data to the Starcraft Prefs file. From one of the 
		// releases around 1.11 if the battle.net preferences and Starcraft prefs differed the install
		// default settings would be used.
		
		//changedport = YES;
		//newPortLong = port;
	}
	
	if (changedport && hasSC) {
		NSLog(@"Saving Starcraft PORT data to Srarcraft Prefs");
		ret = [self savePort:newPortLong toFork:bnetFork name:kSCGameDataPort];
	}

	if(changedD2 && hasD2) {
		ret = [self saveGateways:D2gateways toFork:bnetFork withHeader:d2Header name:kD2RegPath resId:d2Id];
	}

	//NSLog(@"#Data save completed");
	//NSLog(@"####################");

	return ret;
}

- (BOOL)savePort:(int)port toFork:(NDResourceFork *)aFork name:(NSString *)aName {
	BOOL ret = NO;
	ResType type = 'HKEY';
	NSMutableString *str;
	short portId;
	//char nullByte = 0x00;
//	NSMutableData	*portData;
//	unsigned char	*aBuffer; 
	NSScanner		*scan;
	unsigned		val;
	
	//NSLog(@"_savePort aName>%@<", aName);
	//NSLog(@"_savePort saving new port value %i %X",port, port);
	
	// 00 00 00 04 00 00 3F 48
	str = [[NSMutableString alloc] init];
	[str appendString:@"\x00"];
	[str appendString:@"\x00"];
	[str appendString:@"\x00"];
	[str appendString:@"\x04"];

	NSMutableData *data = [[NSMutableData alloc] init];
	[data appendData:[str dataUsingEncoding:NSASCIIStringEncoding]];
	
	scan = [NSScanner scannerWithString:[NSString stringWithFormat:@"%X", port]];
	if ([scan scanHexInt:&val]) {
		[data appendBytes:&val length:4];
	}
	
	//NSLog(@"_savePort Preparing data for port data %@", data);

	if(![bnetFork getId:&portId ofResourceType:type named:aName]) {
		//NSLog(@"_savePort Failed to get ResourceID for %@",aName);
	}

	if([aFork addData:data type:type Id:portId name:aName]) {
		ret = YES;  
		//NSLog(@"Port Data Successfully saved! For: %@",aName);
		//NSLog(@"Port Data Successfully saved! For: %i",portId);
	}		
	
	[data release];
	[str release];
	return ret;
}

- (BOOL)saveGateways:(NSArray *)arr toFork:(NDResourceFork *)aFork withHeader:(NSData *)aHeader name:(NSString *)aName resId:(int)theId {
	int i=0;
	BOOL ret;
	ResType type = 'HKEY';
	NSMutableString *str;
	BNGateway *gate;
	short int resourceAtt = 0;
	int defZoneNumber = 0;
	
	//NSLog(@"Saving to fork: %@",aFork);
	str = [[NSMutableString alloc] init];
	i=0;
	while(i<[arr count]) {
		gate = [arr objectAtIndex:i];
		[str appendFormat:@"%@\x00",[gate address]];
		[str appendFormat:@"%i\x00",[gate zone]];
		[str appendFormat:@"%@\x00",[gate name]];
		// need to know which zone is the default and set this in the header
		// set defZoneNumber
		if([gate vdefault]) {
		    defZoneNumber = i+1;
		}
		i++;
	}
	[str appendString:@"\x00"]; // one last null byte...

	// dgwilson65
	// Setup the default gateway - it's in the array, we need to recreate the header with the exact details.
	//
	// header (Starcraft Battle.Net Preferences)
	// hex   - 0000 0007 3130 3031 0030 3500 

	NSMutableData *data = [[NSMutableData alloc] init];
	NSMutableData *localHeader = [[NSMutableData alloc] init];
	NSRange headerRange1 = {0,9};
	[localHeader appendData:[aHeader subdataWithRange:headerRange1]];

	NSString* tempStr = [[NSString alloc] initWithFormat: @"%02d", defZoneNumber];
	[localHeader appendBytes:[tempStr cString] length:[tempStr cStringLength]+1];
	[tempStr release];
	
	//old  0000 0007 3130 3031 0030 3500
	//new  0000 0007 3130 3031 0030 3300
	
	[data appendData:localHeader];
	//NSLog(@"Got header data: %@",data);
	[data appendData:[str dataUsingEncoding:NSASCIIStringEncoding]];

	//NSLog(@"Got all data: %@",data);
	if([aFork getAttributeFlags:&resourceAtt forResourceType:type Id:theId]) {
		if(resourceAtt & resLocked) {
			//NSLog(@"Resource is Locked: %@",aName);
			// need to unlock resource as we're about to re-write it
			resourceAtt |= resLocked;
			if(![aFork setAttributeFlags:resourceAtt forResourceType:type Id:theId]) {
				//NSLog(@"UnLocking of Resource failed!! Will let code continue and see what happens: %@",aName);
			}
		} else {
			//NSLog(@"Resource is _NOT_ Locked: %@",aName);
		}
	}
	if([aFork addData:data type:type Id:theId name:aName])
		{
		ret = YES;  
		//NSLog(@"Data Successfully saved! For: %@",aName);
		//NSLog(@"Data Successfully saved! For: %i",theId);
		// need to protect resource so that It cannot be modified by the Battle.Net client software
		// we'll only do this for Starcraft as that is the one known to have this problem
		if(aName = kSCRegPath) {
			resourceAtt |= resLocked;
			if(![aFork setAttributeFlags:resourceAtt forResourceType:type Id:theId]) {
				//NSLog(@"Lock of Resource failed!! Will let code continue and see what happens: %@",aName);
			}
		}
	} else {
		ret = NO;
		//NSLog(@"Failed to save resource, STOP - This might have resulted in some corruption");
		//NSLog(@"Inspect the following resource, especially it's length: %@",aName);
	}
	[data release];
	[str release];
	return ret;
}

- (BOOL)error {
	return error;
}

- (NSString *)lastError {
	// i guess clear it when fetched
	NSString *err;
	err = lastError;
	[err autorelease];
	[lastError autorelease];
	lastError = [[NSString alloc] init];
	error = NO;
	return err;
}

#pragma mark -
#pragma mark Checks
- (BOOL)hasD2 {
	return hasD2;
}

- (BOOL)hasW3 {
	return hasW3;
}

- (BOOL)hasSC {	
	return hasSC;
}

- (int)port {
	return portLong;
}

- (void)gameDataPortHasChanged:(long)port {
	changedport = YES;
	newPortLong = port;
}

#pragma mark -
#pragma mark Modification
- (NSData *)processGatewayData:(NSData *)data intoArray:(NSMutableArray *)arr {
	NSData *sub;
	NSData *header;
	BNGateway *aGate;
	int len;
	int defZoneNumber = 1;
	int gatecount;
	
	//NSLog(@"processGatewayData");
	// Need to save off the first 12 bytes of data. 
	// First 12 bytes go to 'header', remainder goes to 'sub'
	// It's important.
	// It's also important that it's written back when the resource fork is re-written.
	// It possibly contains the default gateway and we need to load this into defZoneNumber
	
	// A note about the default gateway
	// The previously played or used gateway is recorded in the "header"
	
	// dgwilson65
	
	len = [data length]-12;
    NSRange range = {12, len-2};
	sub = [[data subdataWithRange:range] retain];
	NSRange range2 = {0,12};
	header = [[data subdataWithRange:range2] retain];
	//NSLog(@"processGatewayData");
	
	// header (Starcraft Battle.Net Preferences)
	// hex   - 0000 0007 3130 3031 0030 3500 

	// 
	// sub
	// hex   - 7573776573742E626174746C652E6E6574003800552E532E2057657374007573656173742E626174746C652E6E6574003600552E532E204561737400617369612E626174746C652E6E6574002D390041736961006575726F70652E626174746C652E6E6574002D31004575726F7065003139322E3136382E31302E31393800313200446178202D20496E7465726E616C0000

	
	// lets get the index entry for the default gateway
	NSString *hstr = [[NSString alloc] initWithData:header encoding:NSASCIIStringEncoding];
	NSArray *hbits = [hstr componentsSeparatedByString:@"\x00"];
	defZoneNumber = [[hbits objectAtIndex:4] intValue];
			
	// lets get the gateway details
	NSString *str = [[NSString alloc] initWithData:sub encoding:NSASCIIStringEncoding];
	NSArray *bits = [str componentsSeparatedByString:@"\x00"];
	gatecount=1;
	int i=0;
	while(i<[bits count]) {
		
	    aGate = [[BNGateway alloc] init];
	    [aGate setAddress:[bits objectAtIndex:i]];
	    [aGate setZone:[[bits objectAtIndex:i+1] intValue]];
	    [aGate setName:[bits objectAtIndex:i+2]];
		if(gatecount == defZoneNumber) {
			//this is the default zone
		    [aGate setDefault:YES];
		} else {
			[aGate setDefault:NO];
			}
	    //NSLog(@"Done with server #%i data: %@",i,aGate);
	    [arr addObject:aGate];
	    //NSLog(@"Added object, count: %i",[W3gateways count]);
	    i=i+3;
		gatecount=gatecount+1;
	    [aGate release];
	    //NSLog(@"Released count: %i",[W3gateways count]);
		
	}
	
	[str release];
	//[bits release];
	[sub release];
	//NSLog(@"Autoreleasing header, returning header");
	[header autorelease];
	return header;
	//NSLog(@"processGatewayData exit -1; incoming data length was <%i>", [data length]);
	
}
- (void)setCurrentGame:(NSString *)aGame {
	currentGame = [aGame retain];
	if([currentGame isEqualToString:@"starcraft"])
		currentArray = SCgateways;
	else if([currentGame isEqualToString:@"diablo2"])
		currentArray = D2gateways;
	else if([currentGame isEqualToString:@"warcraft3"])
		currentArray = W3gateways;
}

- (void)addGateway:(BNGateway *)gate forGame:(NSString *)game {
	if([game isEqualToString:@"starcraft"])
		changedSC = YES;
	else if([game isEqualToString:@"diablo2"])
		changedD2 = YES;
	else if([game isEqualToString:@"warcraft3"])
		changedW3 = YES;
	[currentArray addObject:gate];
}

- (void)removeGatewayAtIndex:(int)index forGame:(NSString *)game {
	if([game isEqualToString:@"starcraft"])
		changedSC = YES;
	else if([game isEqualToString:@"diablo2"])
		changedD2 = YES;
	else if([game isEqualToString:@"warcraft3"])
		changedW3 = YES;
	[currentArray removeObjectAtIndex:index];
}

// this procedure added by dgwilson65
// intention is that the default gateway is selected by the user and this information is
// written back to the header when the user saves the gateway list.

- (void)setDefaultGatewatAtIndex:(int)index forGame:(NSString *)game {

	int i=0;
	BNGateway *gate;

	//NSLog(@"Changing default gateway");
	while(i<[currentArray count]) {
		if(i==index) {
		    // no change to the default setting for this index entry
		} else {
		    // need to turn off the default setting - do it for all
			gate = [currentArray objectAtIndex:i];
			[gate setDefault:NO];
			// currentArray gets the change above because gate is only a pointer to the array (i think)
			// hell it seems to work anyway!
		}
		i++;
	}
	//NSLog(@"manipulation of default gateway completed");
}

- (void)moveGatewayUpFromIndex:(int)index forGame:(NSString *)game {

//	NSLog(@"Moving gateway entry UP");
	[currentArray exchangeObjectAtIndex:index withObjectAtIndex:index-1];
//	NSLog(@"Gateway entry moved DOWN");
}

// insertObject
- (void)moveGatewayDownFromIndex:(int)index forGame:(NSString *)game {

//	NSLog(@"Moving gateway entry DOWN");
	[currentArray exchangeObjectAtIndex:index withObjectAtIndex:index+1];
//	NSLog(@"Gateway entry moved DOWN");
}

#pragma mark -
#pragma mark NSTableView DataSource Protocol
// NSTableView data source 
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
	id g = nil;
	BNGateway *obj;
	//NSLog(@"Fetching");
	//NSLog(@"Fetching value for row: %i columns: %@",rowIndex,[aTableColumn identifier]);

	if([currentGame isEqualToString:@"starcraft"]) {
        g = SCgateways;
        //changedSC = YES;
    }
    else if([currentGame isEqualToString:@"diablo2"]) {
        g = D2gateways;
        //changedD2 = YES;
    }
	else if([currentGame isEqualToString:@"warcraft3"]) {
		g = W3gateways;
		//changedW3 = YES;
	}
	else
		NSLog(@"Got table value change without valid game set");
	
	obj = [g objectAtIndex:rowIndex];
	if([[aTableColumn identifier] isEqualToString:@"zone"])
		return [NSNumber numberWithInt:[obj zone]];
	else if([[aTableColumn identifier] isEqualToString:@"address"])
		return [obj address];
	else if([[aTableColumn identifier] isEqualToString:@"name"])
		return [obj name];
	else if([[aTableColumn identifier] isEqualToString:@"vdefault"])
		return [NSNumber numberWithInt:[obj vdefault]]; 
	else
		return @"";
	return @"";
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:anObject forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
    id g = nil;
	BNGateway *obj;
	
    if([currentGame isEqualToString:@"starcraft"]) {
        g = SCgateways;
        changedSC = YES;
    }
    else if([currentGame isEqualToString:@"diablo2"]) {
        g = D2gateways;
        changedD2 = YES;
    }
	else if([currentGame isEqualToString:@"warcraft3"]) {
		g = W3gateways;
		changedW3 = YES;
	}
	else
		NSLog(@"Got table value change without valid game set");
	obj = [g objectAtIndex:rowIndex];
    if([[aTableColumn identifier] isEqualToString:@"zone"]) {
		[obj setZone:[anObject intValue]];
	}
	else if([[aTableColumn identifier] isEqualToString:@"address"]) {
		[obj setAddress:anObject];
	}		
	else if([[aTableColumn identifier] isEqualToString:@"name"]) {
		[obj setName:anObject];
	}
	else if([[aTableColumn identifier] isEqualToString:@"vdefault"]) {
		[obj setDefault:anObject];
	}
		NSLog(@"No game set");
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
    id g;

	//NSLog(@"Returning table count for game: %@",currentGame);
	if([currentGame isEqualToString:@"starcraft"]) {
		g = SCgateways;
	}
	else if([currentGame isEqualToString:@"diablo2"]) {
		g = D2gateways;
	}
	else if([currentGame isEqualToString:@"warcraft3"]) {
		g = W3gateways;
		//NSLog(@"Count %i",[W3gateways count]);
	}
	else
		return 0;
	//NSLog(@"Returning %i",[g count]);
    return [g count];
}
@end
