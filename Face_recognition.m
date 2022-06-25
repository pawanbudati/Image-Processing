

clc;
clear all;
close all;

im_hight = 400;
im_width = 300;

[file,path] = uigetfile('*.*','Select Video');
vfile = VideoReader(strcat(path,file));
Image_DB = Load_DB();
faceDetector = vision.CascadeObjectDetector();
faceDetector.MergeThreshold = 5;

nF = vfile.NumberOfFrames;
i = 1;
clc;
while i<=nF
    e=read(vfile,i);
    bboxes = step(faceDetector,e);
    s = size(bboxes);
    k = s(1);
    if(s(1)>=1)
        im = read(vfile,i);
        for p=1:size(bboxes)
            im = insertObjectAnnotation(im,'rectangle',bboxes(p,:),strcat('Face',num2str(p)));
        end
        imshow(im);
        title(strcat(num2str(s(1)),' Select one Face. Enter 0 to skip '),'Fontsize',12,'color','blue');
        k = input(' enter your choice :');
        if(sum(sum(bboxes)) ~= 0 && k ~= 0)
            es=imcrop(e,bboxes(k,:));
            drawnow;
            break;
        else
            imshow(e);
            drawnow;
            i = i + 10;
        end
    else
        imshow(e);
        drawnow;
        i = i + 1;
    end
end
es=imresize(es,[im_hight,im_width]);
imshow(es)
target_Image = rgb2gray(es);
target_Image = reshape(target_Image,size(target_Image,1)*size(target_Image,2),1);
image_Signature=15;
white_Image=uint8(ones(1,size(Image_DB,2)));
mean_value=uint8(mean(Image_DB,2));                
mean_Removed=Image_DB-uint8(single(mean_value)*single(white_Image)); 
L=single(mean_Removed)'*single(mean_Removed);
[V,D] = eig(L);
V=single(mean_Removed)*V;
V=V(:,end:-1:end-(image_Signature-1));          
all_image_Signatire=zeros(size(Image_DB,2),image_Signature);

for i=1:size(Image_DB,2);
    all_image_Signatire(i,:)=single(mean_Removed(:,i))'*V;  
end
subplot(121);
imshow(es);
title('Target Face  ','FontWeight','bold','Fontsize',12,'color','blue');
subplot(122);
p=target_Image-mean_value;
s=single(p)'*V;
z=[];
for i=1:size(Image_DB,2)
    z=[z,norm(all_image_Signatire(i,:)-s,2)];
    if(rem(i,image_Signature)==0)
        imshow(reshape(Image_DB(:,i),im_hight,im_width));
        title('Recognizing','FontWeight','bold','Fontsize',12,'color','blue');
    end;
    drawnow;
end
[a,i]=min(z);
if(a>=5.8e+05)
    subplot(122)
    imshow(white_Image);
    title('Not found in Database','FontWeight','bold','Fontsize',12,'color','blue');
else
    subplot(122);
    im = reshape(Image_DB(:,i),im_hight,im_width);
    imshow(im);
    title('Recognition Completed','FontWeight','bold','Fontsize',12,'color','blue');
end
