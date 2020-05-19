# 3D_Radial_MRI_HEALPix

## Repository for preprint and ISBI 2020 abstract.
HEALPix View-order for 3D Radial Self-Navigated Motion-Corrected ZTE MRI https://arxiv.org/abs/1910.10276

IEEE International Symposium on Biomedical Imaging 2020 http://2020.biomedicalimaging.org/


## Requires:
1. GNU Octave v5.1.0 https://www.gnu.org/software/octave/
- optim https://octave.sourceforge.io/optim/
2. ImageJ or Fiji  https://imagej.nih.gov/ij/  https://imagej.net/Fiji
- Slanted Edge MTF https://imagej.nih.gov/ij/plugins/se-mtf/index.html


## To Install:
  cd your_src_directory

  git clone git://github.com/curtcorum/3D_Radial_MRI_HEALPix.git

  cd 3D_Radial_MRI_HEALPix

  git submodule update --init
  

## To run:
  octave
  
    or
    
  octave_gui
  
octave:1> help generate3DRadialTrajectory4

    'generate3DRadialTrajectory4' is a function from the file /home/curt/src/3D_Radial_MRI_HEALPix/generate3DRadialTrajectory4.m

    RAWVIEWS = generate3DRadialTrajectory4 (NRES, VARARGIN)

     function rawviews = generate3DRadialTrajectory4( Nres, Nframe, L,
     scheme, comment);

     Nres = 1d resolution parameter...total views will be Nres^2

     Nframe = number of frames in an aquisition grouping, default =
     Nres.

     L = number of segments, default 1 for no grouping) ...ignored

     scheme = 'spiral', 'cubed_sphere', 'mesh_icos', 'fibonacci',
     'hammersley' 'healpix', 'icos_0', or 'oct' from the "spherepts"
     package

     '2d_golden', or 'random' from Magnetic Resonance in Medicine 61:354
     –363 (2009)

     comment = string to be appended to the filename, default is
     timespamp

     saves silent_grad_Nres*.txt file in current dirctory

     rawviews.N_pad is the padding paramter used, rawviews.data is view
     table in array

octave:2> rawviews_test = generate3DRadialTrajectory4( 16, 1, 1, 'spiral', 'test');


  
