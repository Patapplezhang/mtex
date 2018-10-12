function [S2G, W, M2] = quadratureS2Grid(bandwidth, varargin)
%
% Syntax
%   [S2G, W, M2] = quadratureS2Grid(M) quadrature grid of type gauss
%   [S2G, W, M2] = quadratureS2Grid(M, 'chebyshev') quadrature grid of type chebyshev
%


persistent S2G_p;
persistent W_p;
persistent M2_p;

if check_option(varargin, 'gauss')
  load(fullfile(mtexDataPath,'quadratureS2Grid_gauss.mat'),'gridIndex');
else
  load(fullfile(mtexDataPath,'quadratureS2Grid_chebyshev.mat'),'gridIndex');
end
index = find(gridIndex.bandwidth >= bandwidth, 1);
if isempty(index)
  index = size(gridIndex,1);
  warning('M is too large, instead we are giving you the largest quadrature grid we got.');
end

M2 = gridIndex.bandwidth(index);

if ~isempty(M2_p) && M2_p == M2
  S2G = S2G_p;
  W = W_p;
  M2 = M2_p;
  
else
  name = cell2mat(gridIndex.name(index));
  if check_option(varargin, 'gauss')
    data = load(fullfile(mtexDataPath,'quadratureS2Grid_gauss.mat'),name);
  else
    data = load(fullfile(mtexDataPath,'quadratureS2Grid_chebyshev.mat'),name);
  end

  eval(['data = data.' name ';']);
  S2G = vector3d('polar', data(:, 1), data(:, 2));
  
  if check_option(varargin, 'gauss')
    W = data(:,3);
  else
    W = 4*pi/size(data, 1) .* ones(size(S2G));
  end  
  
  
  % store the data
  S2G_p = S2G;
  W_p = W;
  M2_p = M2;    
end

end
