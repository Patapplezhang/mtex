%% Align EBSD data to a reference frame
% How to align EBSD correctly to certain reference frames
%%
% This article discusses how 
%
%% Open in Editor
%
%% Contents
%
%%
% First, let us import some example <mtexdata.html EBSD data> and plot
% the raw data

plotx2east; plotzup
mtexdata aachen;
figure('position',[100 100 800 400])
plot(ebsd)

%%
% as well as some pole figure data
plotpdf(ebsd('Fe'),Miller(1,2,3),'contourf','points',10000)

%% Altering the graphical output
%
% If you are unsatisfied with the orientation of your EBSD map in the
% graphical output this might be simply because the alignment of
% the reference frame of your data on your plot is not correct. In the
% above picture the x-axis is plotted to east and the z-axis is plotted out
% of plane. Assume you want to change this to z-axis into plane you need to
% do

plotzdown;
figure('position',[100 100 800 400])
plot(ebsd)

%%
% Observe, how the y-axis is inverted but the x-axis is still plotted in
% east direction. This change of the alignment of the reference frame does
% not only effect spatial EBSD plots but also all pole figure plots.

plotpdf(ebsd('Fe'),Miller(1,2,3),'contourf','points',10000)

%%
% However, by changing the alignment of the reference frame in the
% graphical output non of the imported spatial coordinats nor the Euler
% angles are changed. In particular any estimated ODF is not effected by
% those changes of the alignment of the reference frame in the plots.

%% Rotatating the data - realigning the reference frame
% Sometimes it is necessary to realing the EBSD data to another
% external reference frame, or to  change the external
% reference frame from one to the other, e.g. if one wants to concatenate
% several ebsd data sets where the mounting was not done in perfect
% coincidence. In these cases the data has to be rotated or shifted by the
% commands <EBSD.rotate.html rotate> and <EBSD.shift.html shift>. The
% following commands rotate the reference frame of the entire data set by 5
% degree about the z-axis.

% define a rotation
rot = rotation('axis',zvector,'angle',5*degree);

% rotate the EBSD data
ebsd_rot = rotate(ebsd,rot);

% plot the rotated EBSD data
close
figure('position',[100 100 800 400])
plot(ebsd_rot)

%%
% It should be stressed that this rotation on does not only effect the
% spatial data, i.e. the x, y values, but also the Euler angles are
% rotated accordingly. 

plotpdf(ebsd_rot('Fe'),Miller(1,2,3),'contourf','points',10000)

%% See also
% EBSD/rotate EBSD/shift EBSD/affinetrans

%% Correcting for different reference frames in spatial data and Euler angles
% Sometimes the imported spatial data and the imported Euler angles do not
% coresspond to the same reference frame. Since MTEX always assumes these
% reference frames to be the same it might be necessary to correct for this
% misalignment. This can be done by rotating the spatial data or the Euler
% angles seperately using the options |keepXY| or |keepEuler|. E.g. the
% following command only effect the spatial coordinates but not the Euler
% angles

% rotate the EBSD data
ebsd_rot = rotate(ebsd,rot,'keepEuler');

% plot the rotated EBSD data
close
figure('position',[100 100 800 400])
plot(ebsd_rot)

%%
% The pole figure remains unchanged:

plotpdf(ebsd_rot('Fe'),Miller(1,2,3),'contourf','points',10000)

%% Correcting HKL and CTF files
% Both *.ctf and *.ang data files are known to use different reference
% frames for spatial data and Euler angles. To corrrect for misalignment
% the interface supports the options |convertSpatial2EulerReferenceFrame|
% and |convertEuler2SpatialReferenceFrame|, e.g.,
%
%   loadEBSD('fname.ang','convertSpatial2EulerReferenceFrame')
%   loadEBSD('fname.ang','convertEuler2SpatialReferenceFrame')
%
% In the first case the spatial data are changed such that the Euler angles
% referene frame coincides with the spatial reference frame and in the
% second case the Euler angles are altered to get coincidence.
