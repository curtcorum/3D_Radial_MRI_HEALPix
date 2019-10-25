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
## @deftypefn {} {@var{views} =} plotViewsSilentGrad_octave (@var{varargin})
##
##  Gets the views and plots from silent_grad_xxx_yyy_ccc.txt files
##
##  file dialog if no path givien in varargin
##
## @seealso{}
## @end deftypefn

## Author: Curt Corum <curt@sagan>
## Created: 2019-10-15

function views = plotViewsSilentGrad_octave( varargin);
%function views = plotViewsSilentGrad_octave( varargin);
% Gets the views and plots from silent_grad_xxx_yyy_ccc.txt files
%   C. Corum 10/5/2019 curt.corum@champaignimaging.com
%   Copyright 2019 Champaign Imaging LLC

% copied from getViewsSilentGrad
% octave specific version, CAC 191015

# Plot defaults
set (0, "defaultlinelinewidth", 1.25);
set (0, "defaultaxesfontsize", 14);
set (0, "defaultlinemarkersize", 1.25);

DEBUG_FLAG = 2;

close all;

if nargin == 0
    [filename, pathname, filterindex] = uigetfile( ...
        {'silent_grad*.txt', 'silent_grad*.txt files'}, ...
        'Pick a silent_grad vieworder file');
    filePath = fullfile( pathname, filename);
elseif nargin == 1
    filePath = varargin(1);
else
    error( 'Too many arguments, accepts a file path and nothing else.');
end

if ( DEBUG_FLAG >= 2 )
    gvsg_timer = tic;
end

% write switches
% unflip_navigators = 1;
unflip_navigators = 0; % as in the silent_grad.txt file
if (DEBUG_FLAG >= 2)
    fprintf( 'unflip_navigators = %d\n', unflip_navigators);
end

% read switches
%put more here...

startPath = pwd;
cd( pathname);

% legacy
if strncmp( filename, 'silent_grad_s', 13)
    warning( '\nselected vieworder is for WASPI lowres');
end

% load data from file
if (DEBUG_FLAG >= 2)
    fprintf( 'Loading silent_grad views from %s, ', filename);
end
if (DEBUG_FLAG >=3)
    fprintf( '\n%s DEBUG reading silent_grad tables from: %s, ', mfilename( 'fullpath'), filePath);
end
[dataStruct DELIM NHEADERLINES] = importdata(filename);    %%% add check for file integrity at some point, *** CAC 180110
endpoints_tmp = dataStruct.data(:, 2:end);
size_et = size( endpoints_tmp);
Nviews = size_et(1);
Nframes = sqrt( Nviews); % dummy placeholder, CAC 191005 

% return to starting directory
cd( startPath)

% parse header data
Nviews_header = 0;
Nviews_header_iso = 0;
Nviews_header_seg = 0;
Nviews_header_rem = 0;
Nviews_header_nav = 0;
if (NHEADERLINES > 1)
    Nviews_header = sscanf( dataStruct.textdata{1,1}, '#%d');
    Nviews_header_iso = Nviews_header;
    Nviews_header_seg = Nviews_header;
end
if (NHEADERLINES > 2)
    Nviews_header_iso = sscanf( dataStruct.textdata{2,1}, '#%d');
    Nviews_header_seg = Nviews_header_iso;
end
if (NHEADERLINES > 3)
    Nviews_header_seg = sscanf( dataStruct.textdata{3,1}, '#%d');
end
if (NHEADERLINES > 4)
    Nviews_header_rem = sscanf( dataStruct.textdata{4,1}, '#%d');
end
if (NHEADERLINES > 5)
    Nviews_header_nav = sscanf( dataStruct.textdata{5,1}, '#%d');
end
if (DEBUG_FLAG >= 3)
    fprintf( '\n%s DEBUG silent_grad table header lines: %d, ', mfilename( 'fullpath'), NHEADERLINES);
end

NframesDynamic = floor( Nviews_header_iso/Nviews_header_seg);
frameSizeDynamic = Nviews_header_seg + Nviews_header_nav;

##if NframesDynamic == 1;
##    warning( 'selected vieworder is for not dynamic');
##end

% write to views4
views.NframesDynamic = NframesDynamic;
views.Nviews_header = Nviews_header;
views.Nviews_header_iso = Nviews_header_iso;
views.Nviews_header_seg = Nviews_header_seg;
views.Nviews_header_rem = Nviews_header_rem;
views.Nviews_header_nav = Nviews_header_nav;
views.frameSize = sqrt( Nviews_header);
views.frameSizeDynamic = frameSizeDynamic;
endpoints_tmp = dataStruct.data(1:(end-Nviews_header_rem), 2:end);
endpoints_tmp = endpoints_tmp';
% size( endpoints_tmp)     % *** CAC 180226 debug

%return
fprintf( '\n%s\n', filename);
view
size( endpoints_tmp)

views.endpoints = reshape( endpoints_tmp, 3, frameSizeDynamic, NframesDynamic);
%size_ep = size( views.endpoints)
views.endpoints_seg = views.endpoints(:, 1:Nviews_header_seg, :);
views.endpoints_nav = views.endpoints(:, (Nviews_header_seg + 1):end, :);

% if (DEBUG_FLAG >=4)
%     figure( 'name', 'getViewsSilentGrad DEBUG views.endpoints'); hold on; title('frame 1');
%     plot( views.endpoints(1, :, 1), 'r. ');
%     plot( views.endpoints(2, :, 1), 'g. ');
%     plot( views.endpoints(3, :, 1), 'b. ');
%     hold off;
%     figure( 'name', 'getViewsSilentGrad DEBUG views.endpoints'); hold on; title('frame 2');
%     plot( views.endpoints(1, :, 2), 'r. ');
%     plot( views.endpoints(2, :, 2), 'g. ');
%     plot( views.endpoints(3, :, 2), 'b. ');
%     hold off;
%     figure( 'name', 'getViewsSilentGrad DEBUG views.endpoints'); hold on; title('all');
%     plot( views.endpoints(1, :), 'r. ');
%     plot( views.endpoints(2, :), 'g. ');
%     plot( views.endpoints(3, :), 'b. ');
%     hold off;
% end

% re-order navigator coordinates
views.unflip_nav = zeros( NframesDynamic, 1); % initialize to zeros (false)
if unflip_navigators && ( Nviews_header_nav > 0 )
    if (DEBUG_FLAG >=3)
        fprintf( '\n%s DE4BUG unflipping navigator frames, ', mfilename( 'fullpath'));
    end
    for sidx = 1:NframesDynamic
        if ( views.endpoints_nav(3, 1, sidx) > 0 )
            views.unflip_nav(sidx) = 1; % set true for flip, needed later for data
            views.endpoints_nav(:, :, sidx) = flip( views.endpoints_nav(:, :, sidx), 2);
        end
    end
end


if (DEBUG_FLAG >=3)
    fprintf( '\n%s DEBUG silent_grad table Nviews: %d Nframes: %d NframesDynamic: %d Nviews_header: %d Nviews_header_iso: %d Nviews_header_seg: %d Nviews_header_rem: %d, ', mfilename( 'fullpath'), Nviews, Nframes, NframesDynamic, Nviews_header, Nviews_header_iso, Nviews_header_seg, Nviews_header_rem);
end

% dynamic segments and navigators

% setup parameters
% get from P-file eventually, *** CAC 180112
pars.MaxMultx = max( abs( endpoints_tmp(1, :)));
pars.MaxMulty = max( abs( endpoints_tmp(2, :)));
pars.MaxMultz = max( abs( endpoints_tmp(3, :)));
%obj.pars.nv = frameSize;
%obj.pars.Nspiral = Nframes;
%obj.pars.rffraction = 0;
%obj.pars.np = 2*NviewsSqrt; % varian convention
%obj.pars.os = 1;

if (DEBUG_FLAG >= 1)
    close all;
    if Nviews_header_seg < Nviews_header_iso
        figure( 'name', 'getViewsSilentGrad DEBUG views.endpoints_seg'); hold on; %title('seg 1');
        plot( views.endpoints_seg(1, :, 1), 'r'); plot( views.endpoints_seg(2, :, 1), 'g'); plot( views.endpoints_seg(3, :, 1), 'b');
        legend( 'G_X', 'G_Y', 'G_Z');
        hold off;
        figure( 'name', 'getViewsSilentGrad DEBUG views.endpoints_seg'); hold on; %title('seg 2');
        plot( views.endpoints_seg(1, :, 2), 'r'); plot( views.endpoints_seg(2, :, 2), 'g'); plot( views.endpoints_seg(3, :, 2), 'b');
        legend( 'G_X', 'G_Y', 'G_Z');
        hold off;
    end
    figure( 'name', 'getViewsSilentGrad DEBUG views.endpoints_seg'); hold on; axis( [0 200], "square"); %title('all');
    plot( views.endpoints_seg(1, :), 'k -'); plot( views.endpoints_seg(2, :), 'k --'); plot( views.endpoints_seg(3, :), 'k :');
    legend( 'G_X', 'G_Y', 'G_Z'); grid on;
    hold off;
    if numel( views.endpoints_nav) > 0
        figure( 'name', 'getViewsSilentGrad DEBUG views.endpoints_nav'); hold on; %title('seg 1');
        plot( views.endpoints_nav(1, :, 1), 'r'); plot( views.endpoints_nav(2, :, 1), 'g'); plot( views.endpoints_nav(3, :, 1), 'b');
        legend( 'G_X', 'G_Y', 'G_Z');
        hold off;
        figure( 'name', 'getViewsSilentGrad DEBUG views.endpoints_nav'); hold on; %title('all');
        plot( views.endpointsplot_nav(1, :), 'r'); plot( views.endpoints_nav(2, :), 'g'); plot( views.endpoints_nav(3, :), 'b');
        legend( 'G_X', 'G_Y', 'G_Z');
        hold off;
    end
    if Nviews_header_seg < Nviews_header_iso
        figure( 'name', 'getViewsSilentGrad DEBUG views.endpoints_seg'); hold on; %title('seg 1 and 2');
        hold on; xlabel( 'G_X'); ylabel( 'G_Y'); zlabel( 'G_Z');
        plot3( views.endpoints_seg(1, :, 1), views.endpoints_seg(2, :, 1), views.endpoints_seg(3, :, 1), 'r. ');
        plot3( views.endpoints_seg(1, :, 2), views.endpoints_seg(2, :, 2), views.endpoints_seg(3, :, 2), 'g. ');
        hold off;
    end
    figure( 'name', 'getViewsSilentGrad DEBUG views.endpoints_seg'); hold on; %title('all');
    hold on; xlabel( 'G_X'); ylabel( 'G_Y'); zlabel( 'G_Z'); grid on; axis( 'equal'); view( 22.5, 22.5); % 3D iso
    %comet3( views.endpoints_seg(1, :), views.endpoints_seg(2, :), views.endpoints_seg(3, :));
    plot3( views.endpoints_seg(1, :), views.endpoints_seg(2, :), views.endpoints_seg(3, :), 'ko ', 'markersize', 2);
    %scatter3( views.endpoints_seg(1, :), views.endpoints_seg(2, :), views.endpoints_seg(3, :), 4, "filled");
    %view( 0, 0); % equatorial
    hold off;
end

if ( DEBUG_FLAG >= 2 )
    fprintf( 'views.endpoints_seg array size is %d %d %d, ', size( views.endpoints_seg));
    fprintf( 'views.endpoints_nav array size is %d %d %d, ', size( views.endpoints_nav));   toc( gvsg_timer)
end

return
