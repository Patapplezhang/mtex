function [ori,omega] = orientation(f,varargin)
% generate a list of orientation out of a fibre
%
% Syntax
%   ori = orientations(f,'points',1000)
%
% Input
%  f - @fibre
%
% Output
%  ori - @orientation
%
% Options
%  points - number of points that are generated
%

npoints = get_option(varargin,'points',1000);
omega = linspace(0,2*pi,npoints);

ori = rotation.id(npoints,length(f.h));
for i = 1:length(f.h)
  
  r = f.r(i);
  if isempty(f.o1)
    o1 = rotation('map',f.h(i),f.r(i));  %#ok<*PROPLC>
  else
    o1 = f.o1(i);
    
    if ~isempty(f.o2)
      maxOmega = angle(o1,f.o2(i),'noSymmetry');
      if maxOmega > 0
        r = axis(f.o2(i).*inv(o1),'noSymmetry');
        omega = linspace(0,maxOmega,npoints);
      end
    end
  end
  
  % compute orientations
  ori(:,i) = rotation('axis',r,'angle',omega) .* o1;
  
end



if isa(f.CS,'crystalSymmetry') || isa(f.SS,'crystalSymmetry')
  ori = orientation(ori,f.CS,f.SS);
end

end