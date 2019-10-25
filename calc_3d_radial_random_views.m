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
## @deftypefn {} {@var{gS} =} calc_3d_radial_random_views (@var{size_param})
## Random points on sphere vieworder from Magnetic Resonance in Medicine 61:354 –363 (2009)
##
##  size_param = number of views
##
##  gS = size_param x 3 array of gradient values
##
## @seealso{}
## @end deftypefn

## Author: Curt Corum <curt.corum@champaignimaging.com>
## Created: 2019-10-09

function gS = calc_3d_radial_random_views( size_param)
%function gS = calc_3d_radial_random_views( size_param)
% Random points on sphere vieworder
%   from Magnetic Resonance in Medicine 61:354 –363 (2009)
%
%   size_param = number of views
%
%   gS = size_param x 3 array of gradient values

X_temp = zeros( size_param, 1);
Y_temp = zeros( size_param, 1);
Z_temp = zeros( size_param, 1);
rand_j = rand( size_param, 1);
rand_k = rand( size_param, 1);
%for l = 1:size_param
parfor m = 1:size_param
    cos_beta = 2*rand_j(m)-1;
    sin_beta = sqrt( 1 - cos_beta*cos_beta);
    alpha = 2*pi*rand_k(m);
    X_temp(m) = sin_beta*cos( alpha);
    Y_temp(m) = sin_beta*sin( alpha);
    Z_temp(m) = cos_beta;
end
% diable sorting
%     Weight_Z = Z_temp;
%     Weight_Y = 0*sqrt( size_param)*[0, diff( Y_temp).^2];
%     Weight_X = 0*sqrt( size_param)*[0, diff( X_temp).^2];
%     Weight = Weight_X + Weight_Y + Weight_Z;
%     [Weight_sort, I] = sort( Weight);
%     X = [X, X_temp(I)];
%     Y = [Y, Y_temp(I)];
%     Z = [Z, Z_temp(I)];

%end
gS = [X_temp, Y_temp, Z_temp];

%plot3( gS(:, 1), gS(:, 2), gS(:, 3), 'k. ');

end

