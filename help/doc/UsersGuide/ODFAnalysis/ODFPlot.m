%% Visualizing ODFs
% Explains all possibilities to visualize ODfs, i.e. pole figure plots,
% inverse pole figure plots, ODF sections, fibre sections.
%
%% Open in Editor
%
%% Contents
%
%%
% Let us first define some model ODFs to be plotted later on.

cs = symmetry('-3m'); ss = symmetry('-1');
mod1 = orientation('euler',30*degree,40*degree,10*degree,'ZYZ');
mod2 = orientation('euler',10*degree,80*degree,70*degree,'ZYZ');
odf = 0.7*unimodalODF(mod1,cs,ss) + 0.3*unimodalODF(mod2,cs,ss);

%%
% and lets switch to the LaboTex colormap
setpref('mtex','defaultColorMap',LaboTeXColorMap);


%% Pole Figures
% Plotting some pole figures of an <ODF_index.html ODF> is straight forward
% using the <ODF.plotpdf.html plotpdf> command. The only mandatory
% arguments are the ODF to be plotted and the <Miller_index.html Miller
% indice> of the crystal directions you want to have pole figures for.

plotpdf(odf,[Miller(1,0,-1,0),Miller(0,0,0,1)])

%%
% By default the <ODF.plotpdf.html plotpdf> command plots the upper as well
% a the lower hemisphere of each pole sphere. In order to superpose
% antipodal directions you have to use the option *antipodal*.

plotpdf(odf,[Miller(1,0,-1,0),Miller(0,0,0,1)],'antipodal')


%% Inverse Pole Figures
% Plotting inverse pole figures is analogously to plotting pole figures
% with the only difference that you have to use the command
% <ODF.plotipdf.html plotipdf> and you to specify specimen directions and
% not crystal directions.

plotipdf(odf,[xvector,zvector],'antipodal')

%%
% By default MTEX alway plots only the Fundamental region with respect to
% the crystal symmetry. In order to plot the complete inverse pole figure
% you have to use the option *complete*.

plotipdf(odf,[xvector,zvector],'antipodal','complete')

%% ODF Sections
%
% Plotting an ODF in two dimensional sections through the orientation space
% is done using the command <ODF.plotodf.html plot>.

plot(odf,'sections',12,'silent')

%%
% By default ODFs are plotted in sigma sections. One can plot ODF
% sections along any of the Euler angles
%
% * SIGMA (alpha+gamma)
% * ALPHA
% * GAMMA
% * PHI1
% * PHI2
%
%%
% It is also possible to section along the rotation angle of a rotation axis
%
% * axisangle
%
%%
% Adapting <SphericalProjection_demo.html spherical projection> and
% <ColorCoding_demo.html color coding> one can produce any standard ODF plot.

plot(odf,'alpha','sections',12,...
  'projection','plain','contourf','FontSize',10,'silent')
mtexColorMap white2black

%%
%One can also specify the sectioning angles direct

plot(odf,'alpha',[25 30 35]*degree,...
  'projection','plain','contourf','FontSize',10,'silent')
mtexColorMap white2black

%% 3D Euler Space
% Instead of Sectioning one could plot the Euler Angles in 3D
%
% * contour3
% * surf3
% * slice3
%

plot(odf,'sigma','surf3')

%% One Dimensional ODF Sections and Fibres
% In the case you have a simple ODF it might be helpfull to plot one
% dimensional ODF sections.

plot(odf,'radially','LineWidth',2)

%%
% More generaly, one can plot the ODF along a certain fibre

plotfibre(odf,Miller(1,2,2),vector3d(2,1,1),'LineWidth',2);

%% Fourier Coefficients
% A last way to visualize an ODF is to plot its Fourier coefficients

close all;
plotFourier(odf,'bandwidth',32)

%% Axis / Angle Distribution
% Let us consider the uncorrelated missorientation ODF corresponding to our
% model ODF.

mdf = calcMDF(odf)

%%
% Then we can plot the distribution of the rotation axes of this
% missorienation ODF

plotAxisDistribution(mdf)

%%
% and the distribution of the missorientation angles and compare them to a
% uniform ODF

plotAngleDistribution(mdf)
hold all
plotAngleDistribution(uniformODF(cs,cs))
hold off
legend('model ODF','uniform ODF')



%%
% Finally, lets set back the default colormap.

setpref('mtex','defaultColorMap',WhiteJetColorMap);

