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
## @deftypefn {} {@var{rawviews} =} generate3DRadialTrajectory4 (@var{Nres}, @var{varargin})
##
##  function rawviews = generate3DRadialTrajectory4( Nres, Nframe, L, scheme, comment);
##
##  Nres = 1d resolution parameter...total views will be Nres^2
##
##  Nframe = number of frames in an aquisition grouping, default = Nres.
##
##  L = number of segments, default 1 for no grouping) ...ignored
##
##  scheme = 'spiral', 'cubed_sphere', 'mesh_icos', 'fibonacci', 'hammersley'
##      'healpix', 'icos_0', or 'oct' from the "spherepts" package
##
##      '2d_golden', or 'random' from Magnetic Resonance in Medicine 61:354 –363 (2009)
##
##  comment = string to be appended to the filename, default is timespamp
##
##  saves silent_grad_Nres*.txt file in current dirctory
##
##  rawviews.N_pad is the padding paramter used, rawviews.data is view table in array
##
## @seealso{}
## @end deftypefn

## Author: Curt Corum <curt.corum@champaignimaging.com>
## Created: 2019-01-10

function [rawviews] = generate3DRadialTrajectory4( Nres, varargin);
% function rawviews = generate3DRadialTrajectory4( Nres, varargin);
% function rawviews = generate3DRadialTrajectory4( Nres, Nframe, L, scheme, comment);
%   Nres = 1d resolution parameter...total views will be Nres^2
%   Nframe = number of frames in an aquisition grouping, default = Nres.
%   L = number of segments, default 1 for no grouping) ...ignored
%   scheme 'spiral', 'cubed_sphere', 'mesh_icos', 'fibonacci', 'hammersley'
%       'healpix', 'icos_0', 'oct'
%       from the "spherepts" package
%       '2d_golden', 'random'
%       from Magnetic Resonance in Medicine 61:354 –363 (2009)
%
%       
%   comment = string to be appended to the filename, default is timespamp
%
%   saves silent_grad_Nres*.txt file in current dirctory
%
%   rawviews.N_pad is the padding paramter used, rawviews.data is view table in array
%
%   Curt Corum
%   Champaign Imaging LLC
%   1/10/2019
%
% CAC 191005, updated to latest silent_grad.txt header format

comment = datestr( now, 30);
switch nargin
    case 1
        Nframe = Nres; L = 1; scheme = 'spiral';
    case 2
        Nframe = varargin{1}; L = 1; scheme = 'spiral';
    case 3
        Nframe = varargin{1}; L = varargin{2}; scheme = 'spiral'; 
    case 4
        Nframe = varargin{1}; L = varargin{2}; scheme = varargin{3};
    case 5
        Nframe = varargin{1}; L = varargin{2}; scheme = varargin{3}; comment = strcat( varargin{4}, '_', comment);
    otherwise
        error( 'Too many or few arguments');
end

% schemes
zN_flag = 0;
rotate = 0;


MAX_PG_IAMP = 32767.0;
tmp_scale = MAX_PG_IAMP;
totalSpoke = Nres * Nres;

switch scheme
    case 'spiral'
        gS = tmp_scale*getGenSpiralNodes_cac( totalSpoke);
        N_pad = 0;
        N_out = totalSpoke;
    case 'cubed_sphere'
        p_param = floor( Nres/sqrt(6));
        N_out = 6*p_param^2 - 12*p_param + 8;
        N_pad = totalSpoke - N_out;
        gS = tmp_scale*getCubedSphNodes( p_param);
        gS = [gS; gS((end - N_pad+1):end, :)];
        %size(gS)
    case 'mesh_icos'
        % for m = n only
        m_param = floor( Nres/sqrt(30));    n_param = m_param;
        N_out = 30*m_param^2 + 2;
        N_pad = totalSpoke - N_out;
        N_pad2 = 0;
        if N_pad > N_out; N_pad2 = N_pad - N_out; N_pad = N_out; end 
        gS = tmp_scale*getEqualAreaMeshIcosNodes( m_param, n_param);
        gS = [gS; gS((end - N_pad+1):end, :)];
        gS = [gS; gS((end - N_pad2+1):end, :)];
        N_pad = N_pad + N_pad2;
    case 'fibonacci'
        % odd only
        n_param = totalSpoke - 1;
        N_out = n_param;
        N_pad = totalSpoke - N_out;
        gS = tmp_scale*getFibonacciNodes( n_param);
        gS = [gS; gS((end - N_pad+1):end, :)];
    case 'hammersley'
        gS = tmp_scale*getHammersleyNodes( totalSpoke);
        N_pad = 0;
        N_out = totalSpoke;
    case 'healpix'
        n_param = floor( Nres/sqrt(12));
        N_out = 12*n_param^2;
        N_pad = totalSpoke - N_out;
        gS = tmp_scale*getHEALPixNodes( n_param);
        gS = [gS; gS((end - N_pad+1):end, :)];
    case 'icos_0'
        %   TYPE=0:
        % not working foe many inputs..., CAC 190110 ***
        n_param = floor( log2(Nres/sqrt(10)));
        N_out = 10*pow2(2*n_param) + 2;
        N_pad = totalSpoke - N_out;
        gS = tmp_scale*getIcosNodes( n_param, 0);
        gS = [gS; gS((end - N_pad+1):end, :)];
    case 'oct'
        n_param = floor( Nres/2 -.5);
        N_out = 4*n_param^2 + 2;
        N_pad = totalSpoke - N_out;
        gS = tmp_scale*getOctNodes( n_param);
        gS = [gS; gS((end - N_pad+1):end, :)];
    case '2d_golden'
        gS = tmp_scale*calc_3d_radial_gm_views( totalSpoke);
        N_pad = 0;
        N_out = totalSpoke;
    case 'random'
        gS = tmp_scale*calc_3d_radial_random_views( totalSpoke);
        N_pad = 0;
        N_out = totalSpoke;
    otherwise
        error('scheme <%s> not recognized', scheme);
end

%[delta,eta] = separationCoveringRadius(X)

size_gS = size( gS);  N_views_gS = size_gS(1);

rawviews.N_pad = N_pad;

rawviews.data(:, 1) = 0:(totalSpoke-1);
rawviews.data(:, 2) = fix( gS(:, 1));
rawviews.data(:, 3) = fix( gS(:, 2));
rawviews.data(:, 4) = fix( gS(:, 3));

size_raw = size( rawviews.data);  N_col = size_raw( 2); N_views = size_raw( 1);
segSize = N_out/L;
N_views = totalSpoke;
N_iso = N_out;
N_seg = segSize;
N_rem = N_pad;
N_nav = 0;

% long vieworder, make dups > 1 *** CAC 180816
dups = 1;
fp = fopen('silent_grad.txt', 'w');
fprintf(fp,"#%d\n", N_views);
fprintf(fp,"#%d\n", N_iso);
fprintf(fp,"#%d\n", N_seg);
fprintf(fp,"#%d\n", N_rem);
fprintf(fp,"#%d\n", N_nav);
fprintf(fp,"%8s%8s%8s%8s\n","Index","Gx","Gy","Gz");
for dupidx = 1:dups
    fprintf(fp,"%8d%8d%8d%8d\n",rawviews.data');
end
fclose(fp);

command = sprintf( 'mv silent_grad.txt silent_grad_%d_%d_%d_%s_%s.txt', Nres, Nframe, L, scheme, comment);

[status, output] = system( command);
if status == 0
    % everything ok
else
    1024
end

% Plot Gradient Waveforms
figure; hold on;
plot( rawviews.data( 1:(segSize*L), 2), 'r');
plot( rawviews.data( 1:(segSize*L), 3), 'g');
plot( rawviews.data( 1:(segSize*L), 4), 'b');
legend('G_X', 'G_Y', 'G_Z');
title('Gradient Waveforms');
hold off;


figure; hold on; xlabel('G_X'); ylabel('G_Y'); zlabel('G_Z');
% plot3( rawviews.data(1:segSize, 2), rawviews.data(1:segSize, 3), rawviews.data(1:segSize, 4), 'r. ');
% if L >= 2;
%     plot3( rawviews.data((1:segSize)+1*segSize, 2), rawviews.data((1:segSize)+1*segSize, 3), rawviews.data((1:segSize)+1*segSize, 4), 'g. ');
% end
% if L >= 4;
%     plot3( rawviews.data((1:segSize)+2*segSize, 2), rawviews.data((1:segSize)+2*segSize, 3), rawviews.data((1:segSize)+2*segSize, 4), 'b. ');
%     plot3( rawviews.data((1:segSize)+3*segSize, 2), rawviews.data((1:segSize)+3*segSize, 3), rawviews.data((1:segSize)+3*segSize, 4), 'y. ');
% end
if L >= 5
    for cnt = 5:L
        mlt = cnt - 1;
        plot3( rawviews.data((1:segSize)+mlt*segSize, 2), rawviews.data((1:segSize)+mlt*segSize, 3), rawviews.data((1:segSize)+mlt*segSize, 4), 'k. ');
    end
end
if L >= 1
    for cnt = 1:L
        mlt = cnt - 1;
        plot3( rawviews.data((1:segSize)+mlt*segSize, 2), rawviews.data((1:segSize)+mlt*segSize, 3), rawviews.data((1:segSize)+mlt*segSize, 4), 'k. ');
    end
end
hold off;
