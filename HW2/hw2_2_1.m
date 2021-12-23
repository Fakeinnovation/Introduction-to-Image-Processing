p1 = imread('origin_sample.jpg');
p2 = imread('origin_sample2.jpg');

P1 = imadjust(p1,[],[],0.65);
P2 = imadjust(p2,[],[],0.65);
imwrite(P1,'enhancemant_samplea.jpg'),imwrite(P2,'enhancemant_sampleb.jpg');
N1 = (p1+P1)/2;
imwrite(N1,'fusion0.jpg');
N2 = (p2+P2)/2;
imwrite(N2,'fusion1.jpg');

P1 = imread('enhancemant_samplea.jpg');
P2 = imread('enhancemant_sampleb.jpg');
N1 = imread('fusion0.jpg');
N2 = imread('fusion1.jpg');

imshow(P1),figure,imshow(P2),figure,imshow(N1),figure,imshow(N2);

[Height,Width] = size(P1);
[m,Binsx]= imhist(P1); 
m = m/(Height*Width);
H1 = sum(-m.*log2(m));

[Height1,Width1] = size(P2);
[m1,Binsx1]= imhist(P2); 
m1 = m1/(Height1*Width1);
H2 = sum(-m1.*log2(m1));

[Height2,Width2] = size(N1);
[m2,Binsx2]= imhist(N1); 
m2 = m2/(Height2*Width2);
H3 = sum(-m2.*log2(m2));


[Height3,Width3] = size(N2);
[m3,Binsx3]= imhist(N2); 
m3 = m3/(Height3*Width3);
H4 = sum(-m3.*log2(m3));