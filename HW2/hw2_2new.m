p1 = imread('under_exposed_sample.bmp');
p2 = imread('under_exposed_sample2.bmp');

[Height,Width] = size(p1);
[m,Binsx]= imhist(p1); 
m = m/(Height*Width);
H1 = sum(-m.*log2(m));

[Height,Width] = size(p2);
[m,Binsx]= imhist(p2); 
m = m/(Height*Width);
H2 = sum(-m.*log2(m));

imshow(p1);
figure,imshow(p2);
p1 = rgb2ycbcr(p1);
p2 = rgb2ycbcr(p2);
%gamma version
P1 = imadjust(p1(:,:,1),[],[],0.25);
P2 = imadjust(p2(:,:,1),[],[],0.45);

p1(:,:,1) = P1-65;
p2(:,:,1) = P2-45;

a1 = ycbcr2rgb(p1);
a2 = ycbcr2rgb(p2);
figure,imshow(a1);
figure,imshow(a2);
imwrite(a1,'new.jpg'),imwrite(a2,'new1.jpg');
a1 = imread('new.jpg');
a2 = imread('new1.jpg');



[Height,Width] = size(a1);
[m,Binsx]= imhist(a1); 
m = m/(Height*Width);
H3 = sum(-m.*log2(m));

[Height,Width] = size(a2);
[m,Binsx]= imhist(a2); 
m = m/(Height*Width);
H4 = sum(-m.*log2(m));