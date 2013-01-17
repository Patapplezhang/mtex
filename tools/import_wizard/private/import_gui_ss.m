function handles = import_gui_ss(wzrd)
% page for setting specimen symmetry

pos = get(wzrd,'Position');
h = pos(4);
w = pos(3);
ph = 270;

handles = getappdata(wzrd,'handles');

this_page = get_panel(w,h,ph);
handles.pages = [handles.pages,this_page];
setappdata(this_page,'pagename','Set Specimen Geometry');

set(this_page,'visible','off');

scs = uibuttongroup('title','Specimen Coordinate System',...
  'Parent',this_page,...
  'units','pixels','position',[0 140 w-20 130]);


handles.specimeText = uicontrol(...
 'Parent',scs,...
  'String','specimen symmetry:',...
  'HitTest','off',...
  'Style','text',...
  'HorizontalAlignment','left',...
  'Position',[10 50  150 15]);

handles.specime = uicontrol(...
  'Parent',scs,...
  'BackgroundColor',[1 1 1],...
  'FontName','monospaced',...
  'HorizontalAlignment','left',...
  'Position',[160 50 170 20],...
  'String',blanks(0),...
  'Style','popup',...
  'String',symmetries(1:3),...
  'Value',1);


handles.rotate = uicontrol(...
  'Parent',scs,...
  'Style','text',...
  'HorizontalAlignment','left',...
  'String','rotate data by Euler angles (Bunge) in degree',...
  'position',[10 80 300 20]);



handles.rotateAngle(1) = uicontrol(...
  'Parent',scs,...
  'BackgroundColor',[1 1 1],...
  'FontName','monospaced',...
  'HorizontalAlignment','right',...
  'Position',[310 80 30 25],...
  'String','0',...
  'Style','edit');

handles.rotateAngle(2) = uicontrol(...
  'Parent',scs,...
  'BackgroundColor',[1 1 1],...
  'FontName','monospaced',...
  'HorizontalAlignment','right',...
  'Position',[350 80 30 25],...
  'String','0',...
  'Style','edit');

handles.rotateAngle(3) = uicontrol(...
  'Parent',scs,...
  'BackgroundColor',[1 1 1],...
  'FontName','monospaced',...
  'HorizontalAlignment','right',...
  'Position',[390 80 30 25],...
  'String','0',...
  'Style','edit');

handles.euler2spatial(1) = uicontrol(...
  'Parent',scs,...
  'Style','radio',...
  'String',' apply rotation to Euler angles and spatial coordinates',...
  'Value',1,...
  'position',[10 54 400 20]);

handles.euler2spatial(2) = uicontrol(...
  'Parent',scs,...
  'Style','radio',...
  'String',' apply rotation only to Euler angles',...
  'Value',0,...
  'position',[10 32 400 20]);

handles.euler2spatial(3) = uicontrol(...
  'Parent',scs,...
  'Style','radio',...
  'String',' apply rotation only to spatial coordinates',...
  'Value',0,...
  'position',[10 10 400 20]);

% handles.euler2spatialText = uicontrol(...
%   'Parent',scs,...
%   'Style','text',...
%   'ForeGroundColor','r',...
%   'HorizontalAlignment','left',...
%   'String',' The format uses incosistent conventions for the Euler and spatial reference frame.',...
%   'position',[10 5 400 20]);

%'String',' Warning: This format is known to have incosistent conventions for the Euler angle and the spatial reference',...

plotg = uibuttongroup('title','MTEX Plotting Convention',...
  'Parent',this_page,...
  'SelectionChangeFcn',@updateAxes,...
  'units','pixels','position',[0 51 w-20 80]);

imageNames = {'1xyz','2xyz','3xyz','4xyz','1yxz','4yxz','3yxz','2yxz'};
for j = 1:8
  handles.xyz(j) = uicontrol(...
    'parent',plotg,...
    'style','togglebutton',...
    'cdata',loadpng([imageNames{j} '.png']),...    
    'Position',[5+(j-1)*59 5 54 54]);
end

handles.ssText = uicontrol(...
   'String',['Use the "Plot" button to verify that the coordinate' ...
   ' system is properly aligned to the data!'],...
   'Parent',this_page,...
   'HitTest','off',...
   'Style','text',...
   'HorizontalAlignment','left',...
   'Position',[5 5 w-20 35]);



setappdata(this_page,'goto_callback',@goto_callback);
setappdata(this_page,'leave_callback',@leave_callback);
setappdata(wzrd,'handles',handles);


%% -------------- Callbacks ---------------------------------

function goto_callback(varargin)

% set specimen symmetry 
get_ss(gcbf);

% set xyz convention
xaxis = NWSE(getpref('mtex','xAxisDirection'));
zaxis = UpDown(getpref('mtex','zAxisDirection'));
direction = xaxis + 4*(zaxis-1);

handles = getappdata(gcbf,'handles');
set(handles.xyz(direction),'value',1);
set(handles.xyz(1:8 ~= direction),'value',0);

if isa(getappdata(gcf,'data'),'EBSD')
  set(handles.euler2spatial,'visible','on');  
  set([handles.specime,handles.specimeText],'visible','off');
else
  set(handles.euler2spatial,'visible','off');  
  set([handles.specime,handles.specimeText],'visible','on');
end


function leave_callback(varargin)

set_ss(gcbf);

handles = getappdata(gcbf,'handles');

% get xyz convention
direction = find(cell2mat(get(handles.xyz,'value')));

xaxis = 1 + mod(direction-1,4);
zaxis = 1 + (direction > 4);

setpref('mtex','xAxisDirection',NWSE(xaxis));
setpref('mtex','zAxisDirection',UpDown(zaxis));


function updateAxes(varargin)

handles = getappdata(gcbf,'handles');

% get xyz convention
direction = find(cell2mat(get(handles.xyz,'value')));

xaxis = 1 + mod(direction-1,4);
zaxis = 1 + (direction > 4);

setpref('mtex','xAxisDirection',NWSE(xaxis));
setpref('mtex','zAxisDirection',UpDown(zaxis));

% for all axes
ax = findobj(0,'type','axes');
fax = [];
for a = 1:numel(ax)

  if ~isappdata(ax(a),'projection'), continue;end  
  setCamera(ax(a),'xAxisDirection',NWSE(xaxis),'zAxisDirection',UpDown(zaxis));
  fax = [fax,ax(a)]; %#ok<AGROW>
  
end

%
fig = get(fax,'parent');
if iscell(fig), fig = [fig{:}];end
fig = unique(fig);
for f = 1:numel(fig)
  fn = get(fig(f),'ResizeFcn');
  fn(fig(f),[]);
end


%% ------------- Private Functions ------------------------------------------------

function set_ss(wzrd)
% set specimen symmetry

handles = getappdata(wzrd,'handles');
data = getappdata(wzrd,'data');

ss = symmetries(get(handles.specime,'Value'));
ss = strtrim(ss{1}(1:6));
ss = symmetry(ss);

% set data
data = set(data,'SS',ss);
setappdata(wzrd,'data',data);


function get_ss(wzrd)
% write ss to page

handles = getappdata(wzrd,'handles');
data = getappdata(wzrd,'data');

% get ss
ss = get(data,'SS');

% set specimen symmetry
ssname = strmatch(Laue(ss),symmetries);
set(handles.specime,'value',ssname(1));

% set alignment of the plotting coordinate system


%% ----------------------------------------------------------

% nv = uibuttongroup('title','Negative Values',...
%   'Parent',this_page,...
%   'units','pixels','position',[0 ph-210 380 100]);
%
% uicontrol(...
%   'Parent',nv,...
%   'Style','radi',...
%   'String','keep negative values',...
%   'Value',1,...
%   'position',[10 60 160 20]);
%
% handles.dnv = uicontrol(...
%   'Parent',nv,...
%   'Style','radi',...
%   'String','delete negative values',...
%   'Value',0,...
%   'position',[10 35 160 20]);
%
% handles.setnv = uicontrol(...
%   'Parent',nv,...
%   'Style','radi',...
%   'String','set negative values to',...
%   'Value',0,...
%   'position',[10 10 160 20]);
%
% handles.rnv = uicontrol(...
%   'Parent',nv,...
%   'BackgroundColor',[1 1 1],...
%   'FontName','monospaced',...
%   'HorizontalAlignment','right',...
%   'Position',[190 8 80 25],...
%   'String','0',...
%   'Style','edit');
%
%
% co = uibuttongroup('title','Comment',...
%   'Parent',this_page,...
%   'units','pixels','position',[0 0 380 54]);
%
% handles.comment = uicontrol(...
%   'Parent',co,...
%   'BackgroundColor',[1 1 1],...
%   'FontName','monospaced',...
%   'HorizontalAlignment','left',...
%   'Position',[10 8 360 25],...
%   'String',blanks(0),...
%   'Style','edit');

function cdata = loadpng(fname)

[cdata,map,alpha] = imread(fullfile(mtex_path,'help','general',fname)); %#ok<ASGLU>
%cdata = ind2rgb( cdata, map )

alpha = double(alpha);
alpha(alpha==0) = NaN;
cdata = repmat(alpha,[1,1,3]);
cdata = 1-(cdata+150)./(255+150);

