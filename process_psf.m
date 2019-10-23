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
## @deftypefn {} {@var{retval} =} process_psf (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Curt Corum <curt.corum@champaignimaging.com>
## Created: 2019-10-13

function [psf, fileName, filePath] = process_psf( varargin)
  [filePath] = uigetdir( "*.hdr", "please choose a directory containing nifti psf image files");
  oldDir = cd( filePath);
  warning off; nii = get_nifti( "mag.hdr"); warning on;
  cd( oldDir);
  
  center = ceil( size( nii.img)/2);
  max_val = array_max( nii.img); 
  
  x_psf = 1+nii.hdr.dime.dim(2)/2;
  y_psf = 1+nii.hdr.dime.dim(3)/2;
  z_psf = 1+nii.hdr.dime.dim(4)/2;
  
  xrange = (-15:16);
  yrange = (-15:16);
  zrange = (-15:16);
  
  xc = x_psf+xrange;
  yc = y_psf+yrange;
  zc = z_psf+zrange;
  
  psf.img = nii.img( xc, yc, zc);
  
  xvrange = (-7:8);
  yvrange = (-7:8);
  zvrange = (-7:8);
  
  xv = x_psf+xvrange;
  yv = y_psf+yvrange;
  zv = z_psf+zvrange;
  
  psf_volume = nii.img( xv, yv, zv);
  
  volume = sum( psf_volume(:));
  
  ## close previous figure windows
  close all;
  
  ## display slices through center
  figure;
  slice (xrange, yrange, zrange, log10( psf.img), .5, .5, .5);
  colormap ("gray"); brighten( +0.0); colorbar();
  caxis( [-4.5, 0]); 
  title ("log10 PSF");
  xlabel ("X"); ylabel ("Y"); zlabel ("Z");
  
##  # display slice through slant plane
##  figure;
##  [xi, yi] = meshgrid (linspace (-15, 16, 64));
##  zi = xi + yi;
##  slice (xrange, yrange, zrange, log10(psf), xi, yi, zi);
##  colormap ("gray"); brighten( +.5); colorbar();
##  caxis( [-4.5, 0]); 
##  title ("log10 PSF");
##  xlabel ("X"); ylabel ("Y"); zlabel ("Z");
  
  figure;
  surf( xrange, yrange, log10( squeeze( psf.img(:, :, end/2))));
  colormap ("gray"); brighten( +0.0); colorbar();
  zlim( [-4.5, 0]);
  title ("log10 PSF XY-Plane");
  xlabel ("X"); ylabel ("Y");
  
  figure;
  surf( xrange, yrange, log10( squeeze( psf.img(:, end/2, :))));
  zlim( [-4.5, 0]);
  colormap ("gray"); brighten( +0.0); colorbar();
  title ("log10 PSF XZ-Plane");
  xlabel ("X"); ylabel ("Z");
  
##  figure;
##  surf( xrange, yrange, log10( squeeze( psf(end/2, :, :))));
##  zlim( [-4.5, 0]);
##  colormap ("gray"); brighten( +.5); colorbar();
##  title ("log10 PSF YZ-Plane");
##  xlabel ("Y"); ylabel ("Z");
  
##  figure;
##  surf( xrange, yrange, psf(:, :, end/2));
##  colormap ("gray")

  ## 3D Nonlinear fit of PSF
  ## https://octave.sourceforge.io/optim/function/nonlin_curvefit.html
  pkg load optim
  
  [xx, yy, zz] = meshgrid ( xrange, yrange, zrange);
  indep = [xx(:) yy(:) zz(:)];  % flatten each and format as matrix
  obs = psf.img(:); % flatten array of data
  
  ## model function
  f = @ (p, X) p(7) * exp ( -((X(:,1)-p(1))/p(2)).^2/2 -((X(:,2)-p(3))/p(4)).^2/2 -((X(:,3)-p(5))/p(6)).^2/2 );
  ## initial values:
  init = [0.0; 0.5; 0.0; 0.5; 0.0; 0.5; 1.0];
  ## linear constraints, A.' * parametervector + B >= 0
##  A = [1; -1]; B = 0; # p(1) >= p(2);
##  settings = optimset ("inequc", {A, B});
  
  ## start curvefit
##  [p, model_values, cvg, outp] = nonlin_curvefit (f, init, indep, obs, settings);
  [p, model_values, cvg, outp] = nonlin_curvefit (f, init, indep, obs);
  
  psf.info.filePath = filePath; # not working for some reason, filePath is always working directory?! *** CAC 191014
  psf.info.X0 = [p(1) p(3) p(5)];
  psf.info.W = 2*sqrt( 2* log(2))*[p(2) p(4) p(6)];
  psf.info.amp = p(7);
  psf.info.max_val = max_val;
  psf.info.Center = center;
  psf.info.volume = volume;
  #psf.fit = psf_fit;
endfunction
