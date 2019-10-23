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
## @deftypefn {} {@var{nii} =} get_nifti( @var{varargin})
##
##               {@var{nii} =} get_nifti( @var{fileName}, @var{filePath})
##
##               {@var{fileName =} name of nifti file to read, dialog if none},
##
##               {@var{filePath =} path to directory containing file, optional}
##
##               {@var{nii} =} nifti object: nii.header, nii.img, ...
##               
## @seealso{https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image}
## @end deftypefn

## Author: Curt Corum <curt.corum@champaignimaging.com>
## Created: 2019-10-12

function [nii, fileName, filePath] = get_nifti( varargin)
  
  if nargin == 0
    [fileName, filePath] = uigetfile( "*.hdr", "please choose a nifti.hdr file")
    oldDir = cd( filePath);
  elseif nargin == 1
    fileName = varargin{1};
    filePath = pwd;
    oldDir = pwd;
  elseif nargin == 2
    fileName = varargin{2};
    filePath = varargin{1};
    oldDir = cd( filePath);
  endif

  nii = load_nii( fileName);
  
  # check if header is consistent
  size_img = size( nii.img);
  ndims_img = ndims( nii.img);
  size_hdr = nii.hdr.dime.dim;
  size_hdr = size_hdr(2:(ndims_img+1));
  if size_img ~= size_hdr
    warning( "size_hdr does not match size_img");
  endif
  
  cd( oldDir);
  
endfunction
