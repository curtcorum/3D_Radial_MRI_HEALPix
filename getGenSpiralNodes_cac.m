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
## @deftypefn {} {@var{X} =} getGenSpiralNodes_cac (@var{n})
##
##  Generates n generalized spiral points on the sphere. Output is an n x 3 matrix
##
##  GE scheme, not the https://github.com/gradywright/spherepts spiral scheme
##
## @seealso{}
## @end deftypefn

## Author: Curt Corum <curt.corum@champaignimaging.com>
## Created: 2019-01-10

function [ X ]=getGenSpiralNodes_cac(n)
%% Generates generalized n spiral points on the sphere. Output is an N x 3 
% matrix. 
% 
% [X,tri] returns a triangulation of the nodes.
%
% GE scheme, not the https://github.com/gradywright/spherepts spiral scheme
% no tri in octave

%%

MAX_PG_IAMP = 32767;
tmp_scale = MAX_PG_IAMP;
totalSpoke = n;
nOver2 = totalSpoke/2;

% these are vestigial, CAC 190110 ***
segvar = 0; seg_idx = 0;
segSize = totalSpoke;
L = 1;


%     /* calculate trajectory "velocity" squared */
c2 = 2*nOver2*pi;

% test for power of 2
test2 = log2(L);
round2 = round(test2);
if test2 == round2
    % ok
else
    error('n must be divisible by 2');
end

for seg = segvar
    % for seg = 0:(L-1);
    seg_idx = seg_idx + 1;
    segOff = segSize*seg_idx;
    %     /* calculate a hemisphere of points */
    % note that fix( X); is equivalant to the c-cast (short)X and is not round,
    % ceil or floor! *** CAC 180324
    angle = 0;
    
    % rotate by angle
    gxS(nOver2+1) = tmp_scale*cos( angle);
    gyS(nOver2+1) = tmp_scale*sin( angle);
    gzS(nOver2+1) = 0;
    
    for idx = 1:(nOver2-1)
        cT = idx/nOver2;
        sT2 = 1.0-cT*cT;
        angle = angle + sqrt( c2*sT2-0.25)/sT2/nOver2;
        tmp_dvalue = tmp_scale * sqrt( sT2);
        gxS(1+nOver2-idx) = fix( tmp_dvalue*cos( angle));
        gyS(1+nOver2-idx) = fix( tmp_dvalue*sin( angle));
        gzS(1+nOver2-idx) = fix( tmp_scale*cT);
    end
    
    gxS(1) = 0;
    gyS(1) = 0;
    gzS(1) = fix( tmp_scale);
    
    %     /* reflect the second hemisphere */
    for idx = 1:(nOver2-1)
        gxS(1+nOver2+idx) =  gxS(1+nOver2-idx);
        gyS(1+nOver2+idx) = -gyS(1+nOver2-idx);
        gzS(1+nOver2+idx) = -gzS(1+nOver2-idx);
    end
    
end     % seg

X = [gxS' gyS' gzS']/tmp_scale;



%Triangulate the nodes
##tri = delaunay(X);
##tri = freeBoundary(TriRep(tri,X));

end