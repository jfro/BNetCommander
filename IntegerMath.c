/*
 *  IntegerMath.c
 *  Popup Dock
 *
 *  Created by Nathan Day on Sun Jun 29 2003.
 *  Copyright (c) 2003 Nathan Day. All rights reserved.
 *
 */

#include "IntegerMath.h"

unsigned short log10I( const unsigned long aValue )
{
	unsigned short		theExp = 0;
	unsigned long		theCmpValue[] = {10U,100U,1000U,10000U,100000U,1000000U,10000000U,100000000U,1000000000U};
	
	while( aValue >= theCmpValue[theExp] && theExp < sizeof(theCmpValue)/sizeof(unsigned long int) )
		theExp++;

	return theExp;
}

unsigned long greatestCommonDivisor( unsigned long a, unsigned long b )
{
	return b == 0 ? a : greatestCommonDivisor( b, a%b);
}

