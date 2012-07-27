/*!
	@header IntegerMath.h
	@abstract Function to perform integer maths.
	@discussion Contains function that are integer version of float math opperations, e.g. <tt>log10I</tt> or function that are really only applicaple as integer opperations, e.g. <tt>greatestCommonDivisor</tt>

	Created by Nathan Day on Sun Jun 29 2003.
	Copyright &#169; 2003 Nathan Day. All rights reserved.
 */

/*!
	@function log10I
	@abstract Returns the base 10 logarithm for <tt><i>num</i></tt>.
	@discussion <tt>log10I</tt> returns the largest integer less than 10 base logarithm of the unsigned long int <tt><i>num</i></tt>. It is equivelent to <code>(int)logf( num )</code>
	@param num The integer for which the logarithm is desired. 
	@result largest integer less than 10 base logarithm.
 */
unsigned short log10I( const unsigned long num );

/*!
	@function greatestCommonDivisor
	@abstract Return the greatest common divisor
	@discussion The function <tt>greatestCommonDivisor</tt> returns the greatest common divisor of the two integers <tt><i>a</i></tt> and <tt><i>b</i></tt>.
	@param a A <tt>unsigned long int</tt>
	@param b A <tt>unsigned long int</tt>
	@result The greatest common divisor.
 */
unsigned long greatestCommonDivisor( unsigned long a, unsigned long b );
