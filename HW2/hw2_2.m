p1 = imread('under_exposed_sample.bmp');
p2 = imread('under_exposed_sample2.bmp');
p1 = rgb2gray(p1);
p2 = rgb2gray(p2);

%p1 Piecewise linear stretching
a1 = [0 1 51 255]; 
b1 = [0 1 160 255];
T = interp1(a1,b1, 0:255 ,'linear');
p1_T = uint8(T(p1+1));
imwrite(p1_T,'enhancemant_sample.jpg'),imwrite(p1,'origin_sample.jpg');
p1 = imread('origin_sample.jpg');
p1_T = imread('enhancemant_sample.jpg');

%p2 Piecewise linear stretching
a2 = [0 1 100 255]; 
b2 = [0 1 250 255];
U = interp1(a2,b2, 0:255 ,'linear');
p2_U = uint8(U(p2+1));
imwrite(p2_U,'enhancemant_sample2.jpg'),imwrite(p2,'origin_sample2.jpg');
p2 = imread('origin_sample2.jpg');
p2_U = imread('enhancemant_sample2.jpg');

%show
%plot(T),axis tight
%figure,histogram(p1),figure,histogram(p1_T);
%figure,imshowpair(p1,p1_T,'montage')
%figure,plot(U),axis tight
%figure,histogram(p2),figure,histogram(p2_U);
%figure,imshowpair(p2,p2_U,'montage')

%calculate entropy
%p1 picture
% imhist(I) calculates the histogram for the grayscale image I.
% The imhist function returns the histogram counts in counts and the bin locations in binLocations.
% The number of bins in the histogram is determined by the image type.
[Height,Width] = size(p1);
[m,Binsx]= imhist(p1); 
m = m/(Height*Width);
H1 = sum(-m.*log2(m));

[Height1,Width1] = size(p1_T);
[m1,Binsx1]= imhist(p1_T); 
m1 = m1/(Height1*Width1);
H2 = sum(-m1.*log2(m1));
sprintf('the entropy of the original is = %g',H1)
sprintf('the entropy of the enhancement is = %g',H2)
%p2 picture
[Height2,Width2] = size(p2);
[m2,Binsx2]= imhist(p2); 
m2 = m2/(Height2*Width2);
H3 = sum(-m2.*log2(m2));

[Height3,Width3] = size(p2_U);
[m3,Binsx3]= imhist(p2_U); 
m3 = m3/(Height3*Width3);
H4 = sum(-m3.*log2(m3));
sprintf('the entropy of the original is = %g',H3)
sprintf('the entropy of the enhancement is = %g',H4)
