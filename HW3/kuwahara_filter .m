p = imread('cameraman.png');
p1 = imread('Goldengatebridge.png');
p = double(p);
p1 = double(p1);
cdm = imfilter(p,ones(3)/9,'symmetric'); % all the mean values
cd2f = imfilter(p.^2,ones(3)/9,'symmetric');
cdv = cd2f - cdm.^2; % contains all the variances
for i=2:255
    for j=2:255
        vars = [cdv(i-1,j-1),cdv(i-1,j+1),cdv(i+1,j-1),cdv(i+1,j+1)];
        means = [cdm(i-1,j-1),cdm(i-1,j+1),cdm(i+1,j-1),cdm(i+1,j+1)];

        for k=1:4
            if eq(min(vars),vars(k))
                p(i,j) = means(k);
            end
        end
    end
end
imshow(uint8(p));

cdm = imfilter(p1,ones(3)/9,'symmetric'); % all the mean values
cd2f = imfilter(p1.^2,ones(3)/9,'symmetric');
cdv = cd2f - cdm.^2; % contains all the variances
for i=2:399
    for j=2:599
        vars = [cdv(i-1,j-1),cdv(i-1,j+1),cdv(i+1,j-1),cdv(i+1,j+1)];
        means = [cdm(i-1,j-1),cdm(i-1,j+1),cdm(i+1,j-1),cdm(i+1,j+1)];

        for k=1:4
            if eq(min(vars),vars(k))
                p1(i,j) = means(k);
            end
        end
    end
end
figure,imshow(uint8(p1));
imwrite(uint8(p),'cameraman3x3.png'),imwrite(uint8(p1),'Goldengatebridge3x3.png');
p_new = imread('cameraman3x3.png');
p1_new = imread('Goldengatebridge3x3.png');
PSNR_p = psnr(uint8(p),p_new);
PSNR_p1 = psnr(uint8(p1),p1_new);