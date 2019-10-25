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
## @deftypefn {} {@var{gS} =} calc_3d_radial_gm_views (@var{size_param})
## 2d Golden Means points on sphere vieworder from Magnetic Resonance in Medicine 61:354 –363 (2009)
##
##  size_param = number of views
##
##  gS = size_param x 3 array of gradient values
##
## @seealso{}
## @end deftypefn

## Author: Curt Corum <curt.corum@champaignimaging.com>
## Created: 2019-01-03

function gS = calc_3d_radial_gm_views( size_param)
%function gS = calc_3d_radial_gm_views( size_param)
% Approximate 2-d golden means
%   from Magnetic Resonance in Medicine 61:354 –363 (2009)
%
%   size_param = number of views
%
%   gS = size_param x 3 array of gradient values

% solve for phi1 and ph2 using eignvectors of 2d generalized fibonacci
% sequence, as in Chan et al. MRM 2009
Mfib = [0 1 0; 0 0 1; 1 0 1];
[Vfib, Dfib] = eig( Mfib);
phi1 = real( Vfib(1, 1)/Vfib(3, 1));
phi2 = real( Vfib(2, 1)/Vfib(3, 1));
%phi1 = 0.4656;
%phi2 = 0.6823;
%phi1 = 0.465571231876768;
%phi2 = 0.682327803828019;
%gold = 0.61803398874989568;

X_temp = zeros( size_param, 1);
Y_temp = zeros( size_param, 1);
Z_temp = zeros( size_param, 1);
% initialize
prms = primes( 256);
%k1 = phi1; l1 = 0; 
%k2 = phi2; l2 = 0;
k1 = 1; l1 = 0;
k2 = 1; l2 = 0;
%for l = 1:size_param
parfor m = 1:size_param
    n1 = double( k1*m + l1);
    n2 = double( k2*m + l2);
    cos_beta = mod( 2.0*n1*phi1, 2.0) - 1;
    sin_beta = sqrt( 1.0 - cos_beta*cos_beta);
    alpha = 2.0*pi*n2*phi2;
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

