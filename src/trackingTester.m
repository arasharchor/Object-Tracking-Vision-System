function trackingTester(data_params, tracking_params)
%  Estimates the location of an object in video frames using the object's color
%  histogram.

%  Check if output folder exists.  If it does not, then create it.
if ~exist(data_params.out_dir, 'dir')
    mkdir(data_params.out_dir);
end

%  Initialize tracking parameters locally.
rect = tracking_params.rect;
win_size = tracking_params.search_half_window_size;
bin_n = tracking_params.bin_n;

%  Initialize data parameters locally.
frame_ids = data_params.frame_ids;

%  Compute color histogram for specified frame on first image.
img1 = getImage(1);
obj = img1(rect(2) : rect(2) + rect(4), rect(1) : rect(1) + rect(3), :);
[obj_index, color_map] = rgb2ind(obj, bin_n);
%  Gets the best result of hist, histc, histogram, histcounts.
obj_hist = histc(obj_index(:), 1 : bin_n);
obj_hist_mean_reduced = obj_hist - mean(obj_hist);

%  Preallocation for loop.
frame_num = size(frame_ids, 2);

for i = 2 : frame_num
    %  Get the ith image.
    img = getImage(i);
    
    %  Set the lower and upper bounds for x and y.
    x_min = max(1, rect(1) - win_size);
    x_max = min(size(img,2) - rect(3), rect(1) + win_size);
    y_min = max(1, rect(2) - win_size);
    y_max = min(size(img,1) - rect(4), rect(2) + win_size);
    
    %  Initialize max values to lower bounds.
    corr_max = -Inf;
    rect_max = [-Inf, -Inf, rect(3), rect(4)];
    
    %  Get maximum correlated color histogram.
    for x = x_min : x_max
        for y = y_min : y_max
            %  Get the frame window from the image.
            frame_window = img(y : y + rect(4), x : x + rect(3), :);
            %  Get the color index map.
            index_map = rgb2ind(frame_window, color_map);
            %  Get color histogram.
            color_hist = histc(index_map(:), 1 : bin_n);
            color_hist_mean_reduced = color_hist - mean(color_hist);
            
            %  Compare histograms.
            %  Get current histogram correlation.
            curr_corr = sum(sum(obj_hist_mean_reduced .* ...
                color_hist_mean_reduced) / (sqrt(sum(obj_hist_mean_reduced .^2)) .* ...
                sqrt(sum(color_hist_mean_reduced .^2))));
            
            %  If new maximum correlated color histogram, set as max and set
            %  as max rect.
            if curr_corr > corr_max || curr_corr == 1
                rect_max(1) = x;
                rect_max(2) = y;
                corr_max = curr_corr;
            end
        end
    end
    %  Final rect to rect_max.
   rect = rect_max;
   
   %  Draw needle map.
   annotated_img = drawBox(img, rect_max, [0, 255, 0], 3);
   figure, imshow(annotated_img);
   
   %  Save the annotated image.
   saveImage(annotated_img,i);
end

%  Helper functions for loading and saving images.

%  Get image frame i from specified directory.
function image = getImage(i)
    image = imread([data_params.data_dir '/' ...
    data_params.genFname(data_params.frame_ids(i))]);
end

%  Save image in specified directory.
function saveImage(im, i)
    imwrite(im, [data_params.out_dir '/' data_params.genFname(data_params.frame_ids(i))]);
end
end