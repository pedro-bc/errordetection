--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package DigEng is

function log2 (x : natural ) return natural;

function divInput (x : natural; inputSize : natural) return natural; -- divide x by inputSize to have remainder equal to or smaller than 0.

function min ( x : natural; y : natural ) return natural;

function max ( x : natural; y : natural ) return natural;

end DigEng;

package body DigEng is

function log2 ( x : natural ) return natural is
        --variable temp : natural := x;
	variable i : natural := 0;
        --variable n : natural := 0 ;
    begin
      while (2**i < x) loop
         i := i + 1;
      end loop;
      return i;
end function log2;

function divInput ( x : natural; inputSize : natural ) return natural is

	variable i : natural := 0;

    begin
      while (inputSize*i < x) loop
         i := i + 1;
      end loop;
      return i;
end function divInput;

function min ( x : natural; y : natural ) return natural is
begin
	if x < y then
		return x;
	else return y;
	end if;
end function min;	

function max ( x : natural; y : natural ) return natural is
begin
	if x > y then
		return x;
	else return y;
	end if;
end function max;	


end DigEng;
