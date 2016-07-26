function demo(varargin)
% demo runs a demonstration version of the object tracking vision system.
%
% Usage:
% demo                       : list all the registered functions
% demo('function_name')      : execute a specific test
% demo('all')                : execute all the registered functions

% Adds source path
addpath(genpath('../src'));

% Settings to make sure images are displayed without borders.
orig_imsetting = iptgetpref('ImshowBorder');
iptsetpref('ImshowBorder', 'tight');
temp1 = onCleanup(@()iptsetpref('ImshowBorder', orig_imsetting));

fun_handles = {@testTTW, @testTTR, @testTTBB};

% Call test harness
runTests(varargin, fun_handles);

%--------------------------------------------------------------------------
% Tests for tracking with color histogram template
%--------------------------------------------------------------------------

%%
function testTTW()
%-------------------
% Parameters
%-------------------
data_params.data_dir = 'walking_person';
data_params.out_dir = 'walking_person_result';
data_params.frame_ids = [1:20];
data_params.genFname = @(x)([sprintf('frame%d.png', x)]);

% NOTE: Uncomment the below line (and comment the line below that) to manually
%       choose the target.
% tracking_params.rect = chooseTarget(data_params);
tracking_params.rect = [202 69 28 106];

% Half size of the search window
tracking_params.search_half_window_size = 30;
% Number of bins in the color histogram
tracking_params.bin_n = 30;

% Pass the parameters to trackingTester (partial implementation below)
trackingTester(data_params, tracking_params);
end

%%
function testTTR()
%-------------------
% Parameters
%-------------------
data_params.data_dir = 'rolling_ball';
data_params.out_dir = 'rolling_ball_result';
data_params.frame_ids = [1:20];
data_params.genFname = @(x)([sprintf('frame%d.png', x)]);

% NOTE: Uncomment the below line (and comment the line below that) to manually
%       choose the target.
% tracking_params.rect = chooseTarget(data_params);
tracking_params.rect = [157 135 38 40];

% Half size of the search window
tracking_params.search_half_window_size = 40;
% Number of bins in the color histogram
tracking_params.bin_n = 60;           

% Pass the parameters to trackingTester (partial implementation below)
trackingTester(data_params, tracking_params);
end

%%
function testTTBB()
%-------------------
% Parameters
%-------------------
data_params.data_dir = 'basketball';
data_params.out_dir = 'basketball_result';
data_params.frame_ids = [1:20];
data_params.genFname = @(x)([sprintf('frame%d.png', x)]);

% NOTE: Uncomment the below line (and comment the line below that) to manually
%       choose the target.
% tracking_params.rect = chooseTarget(data_params);
tracking_params.rect = [500 220 19 74];

% Half size of the search window
tracking_params.search_half_window_size = 40;
% Number of bins in the color histogram
tracking_params.bin_n = 60;           

% Pass the parameters to trackingTester (partial implementation below)
trackingTester(data_params, tracking_params);
end


%%
function rect = chooseTarget(data_params)
% chooseTarget displays an image and asks the user to drag a rectangle
% around a tracking target
% 
% arguments:
% data_params: a structure contains data parameters
% rect: [xmin ymin width height]

% Reading the first frame from the focal stack
img = imread(fullfile(data_params.data_dir,...
    data_params.genFname(data_params.frame_ids(1))));

% Pick an initial tracking location
imshow(img);
disp('===========');
disp('Drag a rectangle around the tracking target: ');
h = imrect;
rect = round(h.getPosition);

% To make things easier, let's make the height and width all odd
if mod(rect(3), 2) == 0, rect(3) = rect(3) + 1; end
if mod(rect(4), 2) == 0, rect(4) = rect(4) + 1; end
str = mat2str(rect);
disp(['[xmin ymin width height]  = ' str]);
disp('===========');
end
% demo end
end