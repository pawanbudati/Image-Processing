
function output_value = Load_DB()
im_hight = 400;
im_width = 300;

persistent loaded;
persistent numeric_image;
folder_count = 5;
images_per_folder = 15;
if (isempty(loaded))
    all_Images = zeros( im_hight*im_width ,images_per_folder);
    for i = 1:folder_count
        cd(strcat('s',num2str(i)));
        for j = 1:images_per_folder
            image_container = imread(strcat(num2str(j),'.bmp'));
            image_container = rgb2gray(image_container);
            all_images(:,(i-1)*10+j) = reshape(image_container,size(image_container,1)*size(image_container,2),1);
        end
        display('Loading Database');
        cd ..
    end
    numeric_image = uint8(all_images);
end
loaded = 1;
output_value = numeric_image;