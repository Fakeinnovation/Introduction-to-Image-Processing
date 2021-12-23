p1 = imread('Galaxy.png');
p1 = rgb2gray(p1);
%imshow(p1); % original img

%filter
filter_bicubic = [1 4 6 4 1;4 16 26 16 4;6 24 36 24 6;4 16 24 16 4;1 4 6 4 1]/64;
filter_bilinear = [1 2 1;2 4 2;1 2 1]/4;

Img_enl_S = imenlarge(p1,filter_bicubic);
Img_enl_F = imenlarge_fre(p1,'filter_bicubic');
figure
montage({Img_enl_S, Img_enl_F}), title('enlarged image by spatial filtering (left) vs enlarged image by filtering in frequency domain');

% rescale the enlarged image
Img_re_S = imresize(Img_enl_S, 1/2, 'bicubic');
Img_re_F = imresize(Img_enl_F, 1/2, 'bicubic');
figure
montage({Img_re_S, Img_re_F}), title('rescaled image of spatial filtered image (left) vs rescaled image of frequency filtered image');

PSNR_1 = psnr(p1, Img_re_S);
PSNR_2 = psnr(p1, uint8(Img_re_F*255));

imwrite(Img_enl_S,'test1.png');
imwrite(Img_enl_F,'test2.png');
imwrite(Img_re_S,'test3.png');
imwrite(Img_re_F,'test4.png');

function output = imenlarge_fre(image,filt)
filter_bicubic = [1 4 6 4 1;4 16 26 16 4;6 24 36 24 6;4 16 24 16 4;1 4 6 4 1]/64;
filter_bilinear = [1 2 1;2 4 2;1 2 1]/4;
% enlarge img by zero-interleaved matrix
[r,c] = size(image);
new_img = zeros(2*r,2*c); % x2
new_img(1:2:2*r,1:2:2*c) = image;
%Freq. domain interpolation
fnew_img = fft2(new_img); %F(M)

pad = zeros(2*r,2*c);
pad(1:5,1:5) = filter_bicubic;
fpad = fft2(pad); %F(S')
fout = fnew_img.*fpad;
out = ifft2(fout);

pad1 = zeros(2*r,2*c);
pad1(1:3,1:3) = filter_bilinear;
fpad1 = fft2(pad1); %F(S')
fout1 = fnew_img.*fpad1;
out1 = ifft2(fout1);

if strcmp(filt,'filter_bicubic')
    output = mat2gray(out);   
elseif strcmp(filt,'filter_bilinear')
    output = mat2gray(out1);
end
end

function output = imenlarge(image,filt)
% enlarge img by zero-interleaved matrix
[r,c] = size(image);
P = zeros(2*r,2*c);
P(1:2:2*r,1:2:2*c) = image;
%figure,imshow(P);
    p1 = imfilter(P,filt); %double type
    p1 = uint8(p1); %dou2uint8
    output = p1;
end