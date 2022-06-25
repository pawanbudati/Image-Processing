clc
clear all
close all
t=61;c=150;

im_hight = 400;
im_width = 300;


% cam=webcam('HD camera ');
cam=webcam('Iriun Webcam');
faceDetector = vision.CascadeObjectDetector('MergeThreshold',15);
pause(4);
while true
    pause(0.3)
    e=cam.snapshot;
    bboxes = step(faceDetector,e);
    for i=1:size(bboxes)
        for j = 1:4
            if j==1 || j==2
                bboxes(i,j) = bboxes(i,j)-20;
            else
                bboxes(i,j) = bboxes(i,j)+40;
            end
        end
    end
    if(sum(sum(bboxes))~=0)
    if(t>c)
        break;
    else
    es=imcrop(e,bboxes(1,:));
    es=imresize(es,[im_hight,im_width]);
    imwrite(es, strcat(num2str(t),'.bmp') );
    t=t+1;
    imshow(es);
    drawnow;
    end
    else
        imshow(e);drawnow;
    end
end