clc;
%myconvolve_2D is code designed in project2 for convolution

% reading the 2 images A1=foreground A2=background
%case1:colour image
A1=im2double(imread('C:\Users\venkatesh\Desktop\lena.png'));
A2=im2double(imread('C:\Users\venkatesh\Desktop\wolves.png'));

%case2:greyscale image
%  A1=im2double(rgb2gray(imread('C:\Users\venkatesh\Desktop\fish.jpg')));
%  A2=im2double(rgb2gray(imread('C:\Users\venkatesh\Desktop\bucket.jpg')));


%creating black background for A1 to match the size of A1
%the position of A2 can be manually changed in the function


A1=pic_resize(A1,size(A2),10,10);


%**********************GUI*******************************************************
%GUI to select region in the foreground that has to be merged(3 options
%provided)
x=input('Select type of Region selection \n1.Rectangualar\n2.Elliptical\n3.Freehand:');
figure(100);
imshow(A1);
title('Drag to select the region to merge with background'); 
if x==1
    h = drawrectangle('Color','k','FaceAlpha',0.4);
elseif x==2
    h = drawellipse('Color','k','FaceAlpha',0.4);
else
    h = drawfreehand('Color','k','FaceAlpha',0.4);
end

%mask that is created
BW1 = createMask(h);
BW=im2double(BW1);
figure(200); 
imshow(BW);
title('created Black and White mask');
%*********************************************************************************

%computing the Image pyramids for images and mask
[Gau1,Lap1]=ComputePyr(A1,6);
[Gau2,Lap2]=ComputePyr(A2,6);
[Gau3,Lap3]=ComputePyr(BW,6);


%Forming the combined laplacian pyramid(pyramid blending)
for i=1:length(Lap1)
    
X{i}=(Lap1{i}.*Gau3{i})+(Lap2{i}.*(1-Gau3{i}));

end

%collapsing the final laplacian pyramid to form merged image
%steps:interpolate,filter,add with previous layer
z=length(Lap1);
final = X{z};    

%For RGB
if size(A1,3==3);
for k = (z - 1) : -1 : 1
   final = my_interpolate(final);
   F=fspecial('gaussian', 3, 4/6);
   final=myconvolve_2D(final,F,1);   
  
   g = X{k};
   [p,q,~] = size(g);
   final = final(1:p,1:q,:) + g;
end

%For greyscale
else
    for k = (z - 1) : -1 : 1
   final = my_interpolate(final);
   F=fspecial('gaussian', 3, 4/6);
   final=myconvolve_2D(final,F,1);   
  
   g = X{k};
   [p,q] = size(g);
   final = final(1:p,1:q) + g;
end
end 

figure(300);
imshow(final);
title('Final Merged Image');

function [gPyr,lPyr]=ComputePyr(input_image,num_layers)

%***********Gaussian Pyramid*************************
input_image = im2double(input_image);
p = size(input_image,1);
q = size(input_image,2);

%finding defaiult number of layers 
lower_limit = 32;
lay1= min(floor(log2([p q]) - log2(lower_limit))) + 1;

%checking if input number of layers is valid
%selection between default number of layers and input argument based on
%validity
if num_layers>lay1
    num_layers=lay1;
else
    num_layers = min(num_layers, min(floor(log2([p q]))) + 2);
end

%Gaussian pyramid stored in cell array
gPyr= cell(1,num_layers);

%performing padding before pyramid computation 
smallest = [p q] / 2^(num_layers - 1);
smallest = ceil(smallest);
padded_size = smallest * 2^(num_layers - 1);
m=padded_size - [p q];

%for RGB image
if size(input_image,3)==3
p=size(input_image);
row=input_image(p(1),:,:);
for i=p(1):p(1)+m(1)
input_image(i,:,:)=row;
end

p=size(input_image);
col=input_image(:,p(2),:);
for i=p(2):p(2)+m(2)
input_image(:,i,:)=col;
end

%For grey image
else
p=size(input_image);
row=input_image(p(1),:);
for i=p(1):p(1)+m(1)
input_image(i,:)=row;
end

p=size(input_image);
col=input_image(:,p(2));
for i=p(2):p(2)+m(2)
input_image(:,i)=col;
end
end

%1st layer is input image
gPyr{1}=input_image;

%calculating remaining layers
for k = 2:num_layers
    
    F=fspecial('gaussian', 3, 1);
    B=myconvolve_2D(gPyr{k-1},F,1);   

    
B(2:2:end,:,:) = [];
B(:,2:2:end,:) = [];
gPyr{k}=B;

end

%printing the layers for reference
% figure(1);
% 
% for i=1:num_layers
%     figure(i);
%     imshow(gPyr{i});
% end



%*******************Laplacian Pyramid**************

    lPyr=cell(size(gPyr));
    
    %last laplacian layer is equal to last gaussian layer
    lPyr{num_layers} = gPyr{num_layers};
    
    %calculating remaining layers from gaussian pyramid
    
    %For RGB
    if size(input_image,3)==3
        for k = 1:(num_layers - 1)
    C= gPyr{k};
    B=my_interpolate(gPyr{k+1});
    F=fspecial('gaussian', 3, 4/6);
    B=myconvolve_2D(B,F,1);   
    [p,q,~] = size(C);
   lPyr{k} = C - B(1:p,1:q,:);
        end
    %For greyscale
    else
        for k = 1:(num_layers - 1)
    C= gPyr{k};
    B=my_interpolate(gPyr{k+1});
    F=fspecial('gaussian', 3, 4/6);
    B=myconvolve_2D(B,F,1);   
    [p,q] = size(C);
   lPyr{k} = C - B(1:p,1:q);
        end
    end
        
%display pyramid images for reference
% figure(1);
% 
% for i=1:num_layers
%     figure(i);
%     imshow(lPyr{i});
% end
 
 end

%function created to upsample image by 2(nearest neighbour)
function C = my_interpolate(D)
L=size(D);
C=[];

%for RGB
if size(D,3)==3
 for i=1:L(2)
     C =[C D(:,i,:) D(:,i,:)];
 end
 D=C;
 C=[];
 for j=1:L(1)
     C=[C;D(j,:,:);D(j,:,:)];
 end
 
 %for greyscale
else
    for i=1:L(2)
     C =[C D(:,i) D(:,i)];
 end
 D=C;
 C=[];
 for j=1:L(1)
     C=[C;D(j,:);D(j,:)];
 end
end
    
 
end

%function created to resize the foreground image with black background
function B=pic_resize(A,B_size,startx,starty)
   
    s=size(A);
B=zeros(B_size);

%for RGB
if size(A,3)==3   
for k=1:3
    for i=startx:startx+s(1)-1
        for j=starty:starty+s(2)-1
            B(i,j,k)=A(i-startx+1,j-starty+1,k);
        end
    end
end
%for greyscale
else
    for i=startx:startx+s(1)-1
        for j=starty:starty+s(2)-1
            B(i,j)=A(i-startx+1,j-starty+1);
        end
    end
end
end
