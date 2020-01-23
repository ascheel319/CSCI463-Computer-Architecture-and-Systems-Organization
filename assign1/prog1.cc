/*NOTE: I could not get the subtraction to work properly, it is always 1 number off even after I add the 1 for the 2's compliment. I looked at
		the functions for hours on end and could not find where the problem was and the TA said he could not help.

	I also decided to use the 240 documentation standards as I do not know how to use Doxygen, I asked a dozen or 2 people if they knew,
		both fellow student and past students that have jobs and people who do not go to NIU, and only 2 people have heard about it.
		If you want everyone to use it then please show us how to use it, I don't believe simply giving a link to a manual is enough
		for something like this.
*/

/********************************************************************
CSCI 463 - Assignment 1 - Semester (Fall) Year

Progammer: Andrew Scheel
Section:   1
TA:        Chenyi Ni
Professor: John Winans
Date Due:  9/24/19

Purpose:   In this assignment, you will write a program that can add
	   and subtract two's compliment and unsigned binary numbers
	   up to 512 bits long.
*********************************************************************/

#include <iomanip>
#include <iostream>
#include <string>
#include <cstring>
#include <sstream>
#include <fstream>
#include <bits/stdc++.h>

using namespace std;

bool carry = false;

//these will be the variables for the incoming binary values
string num1;
string num2;

//for the 2's compliment
string flipper;

//to flip the bits and the addition
string zero = "0";
string one = "1";

//for the flags
string flags = "   ";

//this will be used for the answer
string answer;

//for the parity
string parity;

//prototypes
string addition(string, string, string, string);
void subtraction();
void parityCheck(string);
void flagZero(string);
void flagUnsigned();
void flagSigned();
void flippingNum2();

int main()
{
	while(cin >> num1 && cin >> num2)
	{
		parityCheck(num1);

		//starting the output for just stating the values from the file
		cout << "v1   " << parity << "     " << num1 << endl;

		parityCheck(num2);
		cout << "v2   " << parity << "     " << num2 << endl;

		//add the numbers together
		carry = false;
		answer = addition(num1, num2, answer, "add");

		//reset the flags for the sum
		flags = "   ";
		//checks for the 0, the Z
		flagZero(answer);
		//checks for the unsigned overflow, the U
		flagUnsigned();
		//checking for signed overflow, the S
		flagSigned();
		//checks the number of 1s in the number
		parityCheck(answer);

		cout << "sum  " << parity << " " << flags << " " << answer << endl;

		subtraction();

		//reset the flags for the diff
		flags = "   ";
		flagZero(answer);
		parityCheck(answer);
		flagSigned();
		flagUnsigned();

		cout << "diff " << parity << " " << flags << " " << answer << endl;

		//the new number doesn't have a carry yet
		carry = false;
		cout << endl;
	}

	return 0;
}

/***************************************************************
Function: addition

Use:      adds the numbers that are put into the function and
	puts them in the 3rd agrument

Arguments: 1. anum1: Addition Number 1: the top number
           2. anum2: Addition Number 2: the bottom number
	   3. aanswer: Addition Answer: where the number will be sent to
	   4. type: if we are doing subtraction or not

Returns:   the string aanswer
***************************************************************/
string addition(string anum1, string anum2, string aanswer, string type)
{
	aanswer = anum1;//so it gets the size correct
	carry = false;

	for(unsigned int i = 0; i <= anum1.size(); ++i)
	{
		//0 0 0
		if((anum1.compare(anum1.size()-i, 1, "0") == 0 && anum2.compare(anum2.size()-i, 1, "0") == 0) && carry == false)
		{
			if(aanswer.size() - i <= 0)
				aanswer.replace(0,1,zero);
			else
				aanswer.replace(aanswer.size()-i,1,zero);
			carry = false;
		}
		//0 0 1
		else if((anum1.compare(anum1.size()-i, 1, "0") == 0 && anum2.compare(anum2.size()-i, 1, "0") == 0) && carry == true)
		{
			if(aanswer.size() - i <= 0)
				aanswer.replace(0,1,one);
			else
				aanswer.replace(aanswer.size()-i,1,one);
			carry = false;
		}
		//0 1 0
		else if((anum1.compare(anum1.size()-i, 1, "0") == 0 && anum2.compare(anum2.size()-i, 1, "1") == 0) && carry == false)
		{
			if(aanswer.size() - i <= 0)
				aanswer.replace(0,1,one);
			else
				aanswer.replace(aanswer.size()-i,1,one);
			carry = false;
		}
		//0 1 1
		else if((anum1.compare(anum1.size()-i, 1, "0") == 0 && anum2.compare(anum2.size()-i, 1, "1") == 0) && carry == true)
		{
			if(aanswer.size() - i <= 0)
				aanswer.replace(0,1,zero);
			else
				aanswer.replace(aanswer.size()-i,1,zero);
                        carry = true;
		}
		//1 0 0
		else if((anum1.compare(anum1.size()-i, 1, "1") == 0 && anum2.compare(anum2.size()-i, 1, "0") == 0) && carry == false)
		{
			if(aanswer.size() - i <= 0)
				aanswer.replace(0,1,one);
			else
				aanswer.replace(aanswer.size()-i,1,one);
                        carry = false;
		}
		//1 0 1
		else if((anum1.compare(anum1.size()-i, 1, "1") == 0 && anum2.compare(anum2.size()-i, 1, "0") == 0) && carry == true)
                {
			if(aanswer.size() - i <= 0)
				aanswer.replace(0,1,zero);
			else
	                        aanswer.replace(aanswer.size()-i,1,zero);
                        carry = true;
                }
		//1 1 0
		else if((anum1.compare(anum1.size()-i, 1, "1") == 0 && anum2.compare(anum2.size()-i, 1, "1") == 0) && carry == false)
                {
			if(aanswer.size() - i <= 0)
				aanswer.replace(0,1,zero);
			else
	                        aanswer.replace(aanswer.size()-i,1,zero);
                        carry = true;
                }
		//1 1 1
		else if((anum1.compare(anum1.size()-i, 1, "1") == 0 && anum2.compare(anum2.size()-i, 1, "1") == 0) && carry == true)
                {
			if(aanswer.size() - i <= 0)
				aanswer.replace(0,1,one);
			else
	                        aanswer.replace(aanswer.size()-i,1,one);
                        carry = true;
                }
	}//end of for

	//second for loop only for subtracting, doing the second addition before it leaves the function
	if(type.compare(0,3, "sub") == 0)
	{
		string temp = aanswer;//to get the size
//cout << "Flipper: " << flipper << endl << "aanswer: " << aanswer << endl;
		//aanswer + flipper = temp
		for(unsigned int i = 0; i <= aanswer.size(); ++i)
		{
			//0 0 0
			if((aanswer.compare(aanswer.size()-i, 1, "0") == 0 && flipper.compare(flipper.size()-i, 1, "0") == 0) && carry == false)
			{
				if(temp.size() - i <= 0)
                        	        temp.replace(0,1,zero);
                	        else
                	                temp.replace(temp.size()-i,1,zero);
                	        carry = false;
                	}
	                //0 0 1
	                else if((aanswer.compare(aanswer.size()-i, 1, "0") == 0 && flipper.compare(flipper.size()-i, 1, "0") == 0) && carry == true)
	                {
	                        if(temp.size() - i <= 0)
	                                temp.replace(0,1,one);
	                        else
	                                temp.replace(temp.size()-i,1,one);
	                        carry = false;
	                }
	                //0 1 0
	                else if((aanswer.compare(aanswer.size()-i, 1, "0") == 0 && flipper.compare(flipper.size()-i, 1, "1") == 0) && carry == false)
	                {
	                        if(temp.size() - i <= 0)
	                                temp.replace(0,1,one);
	                        else
	                                temp.replace(temp.size()-i,1,one);
	                        carry = false;
	                }
	                //0 1 1
			else if((aanswer.compare(aanswer.size()-i, 1, "0") == 0 && flipper.compare(flipper.size()-i, 1, "1") == 0) && carry == true)
	                {
	                        if(temp.size() - i <= 0)
	                                temp.replace(0,1,zero);
	                        else
	                                temp.replace(temp.size()-i,1,zero);
	                        carry = true;
	                }
	                //1 0 0
	                else if((aanswer.compare(aanswer.size()-i, 1, "1") == 0 && flipper.compare(flipper.size()-i, 1, "0") == 0) && carry == false)
	                {
	                        if(temp.size() - i <= 0)
	                                temp.replace(0,1,one);
	                        else
	                                temp.replace(temp.size()-i,1,one);
	                        carry = false;
	                }
	                //1 0 1
	                else if((aanswer.compare(aanswer.size()-i, 1, "1") == 0 && flipper.compare(flipper.size()-i, 1, "0") == 0) && carry == true)
	                {
	                        if(temp.size() - i <= 0)
	                                temp.replace(0,1,zero);
	                        else
	                                temp.replace(temp.size()-i,1,zero);
	                        carry = true;
	                }
	                //1 1 0
	                else if((aanswer.compare(aanswer.size()-i, 1, "1") == 0 && flipper.compare(flipper.size()-i, 1, "1") == 0) && carry == false)
	                {
	                        if(temp.size() - i <= 0)
	                                temp.replace(0,1,zero);
	                        else
	                                temp.replace(temp.size()-i,1,zero);
	                        carry = true;
	                }
	                //1 1 1
			else if((aanswer.compare(aanswer.size()-i, 1, "1") == 0 && flipper.compare(flipper.size()-i, 1, "1") == 0) && carry == true)
                	{
	                        if(temp.size() - i <= 0)
	                                temp.replace(0,1,one);
	                        else
	                                temp.replace(temp.size()-i,1,one);
	                        carry = true;
	                }

		}//end of for loop
		aanswer = temp;
	}//end of if statement

	return aanswer;
}

/***************************************************************
Function: flippingNum2

Use:      to flip the numbers in a number for the 1's compliment

Arguments: None

Returns:   nothing
***************************************************************/
void flippingNum2()
{
	//flipping the bits
        for(unsigned int i = 0; i <= num2.size(); ++i)
        {
                if(num2.compare(num2.size()-i, 1, "1") == 0)
                {
                        if(num2.size() - i <= 0)
                                num2.replace(0,1,zero);
                        else
                                num2.replace(num2.size()-i,1,zero);
                }
                else if(num2.compare(num2.size()-i, 1, "0") == 0)
                {
                        if(num2.size() - i <= 0)
                                num2.replace(0,1,one);
                        else
                                num2.replace(num2.size()-i,1,one);
                }
        }//end of for

	//making the flipper = to something to get size correct
	flipper = num2;
        flipper.replace(flipper.size()-1, 1, one);
        for(unsigned int i = 2; i <= flipper.size(); ++i)
        {
                flipper.replace(flipper.size()-i,1, zero);
        }
}

/***************************************************************
Function: subtraction

Use:      calls flippingNum2 and then calls addition to do the
	  2s compliement and the addition

Arguments: None

Returns:   nothing
***************************************************************/
void subtraction()
{
	flippingNum2();

	answer = addition(num1, num2, answer, "sub");
}

/***************************************************************
Function: parityCheck

Use:      counts the number of ones in a string

Arguments: parityNum: The string that it will check

Returns:   nothing
***************************************************************/
void parityCheck(string parityNum)
{
	//checks to see if its even or odd, the number of 1's in the number
	int ones = 0;
	for(unsigned int i = 0; i < parityNum.size(); i++)
	{
		if(parityNum.compare(i,1,"1") == 0)
			ones++;
	}

	if(ones % 2 == 0)
		parity = "even";
	else
		parity = "odd ";
}

/***************************************************************
Function: flagZero

Use:      checks to see if the number it is passed is all 0s or not
	  if it is then it will throw a flag

Arguments: number: the string that it will check

Returns:   nothing
***************************************************************/
void flagZero(string number)
{
	int count = 0;
	//starts at column 11 and only on lines that start sum or diff

	for(unsigned int i = 0; i <= number.size(); ++i)
	{
		if(number.compare(number.size()-i, 1, "1") == 0)
		{
			count++;
		}
	}
	if(count == 0)
		flags.replace(2,1,"Z");
}

/***************************************************************
Function: flagUnsigned

Use:      checks to see if unsigned overflow has happened or not
          if it is then it will throw a flag

Arguments: number: the string that it will check

Returns:   nothing
***************************************************************/
void flagUnsigned()
{
	if(carry == true)
	{
		flags.replace(1,1,"U");
	}
}

/***************************************************************
Function: flagSigned

Use:      checks to see if signed overflow has happened or not
          if it is then it will throw a flag

Arguments: number: the string that it will check

Returns:   nothing
***************************************************************/
void flagSigned()
{
	if((num1.compare(0, 1, "0") == 0 && num2.compare(0, 1, "0") == 0 && answer.compare(0,1,"1") == 0))
	{
		flags.replace(0,1,"S");
	}
	if((num1.compare(0, 1, "1") == 0 && num2.compare(0, 1, "1") == 0 && answer.compare(0,1,"0") == 0))
	{
		flags.replace(0,1,"S");
	}
}
