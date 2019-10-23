## Copyright (C) 2019 Champaign Imaging LLC
## 
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} array_max (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Curt Corum <curt@sagan>
## Created: 2019-10-13

## finding coordinate not working yet 191013

function [maxval, maxcoord] = array_max ( array_in)
  maxval = array_in;
  array_ndims = ndims( array_in);
  #maxcoord_tmp{array_ndims+1} = 1;
  maxcoord = -999;
  for idx = 1:array_ndims
    [maxval, maxcoord_tmp{idx}] = max( maxval, [], idx);
  endfor
##  for idx = array_ndims:-1:1
##    for jdx = idx:-1:array_ndims
##      maxcoord_tmp1 = maxcoord_tmp{jdx}(maxcoord_tmp{jdx+1});
##    endfor
##    maxcoord(idx) = maxcoord_tmp1(maxcoord_tmp{idx+1})
##  endfor
endfunction
