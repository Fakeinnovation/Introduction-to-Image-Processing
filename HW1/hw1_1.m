p1 = imread('John Wick.bmp');
imwrite(p1,'John Wick.jpg');
[y,map] = rgb2ind(p1,256); imwrite(y,map,'John Wick.gif');
p2 = imread ('John Wick.jpg');
p3 = imread ('John Wick.gif');

%task1
imwrite(p2,'John WickQF100.jpg','Quality',100);
imwrite(p2,'John WickQF0.jpg','Quality',0);
t1 = imread ('John WickQF100.jpg');
t2 = imread ('John WickQF0.jpg');
%task2
imshow(t1),figure,imshow(t2),figure,imshow(p1),figure,imshow(p3); %QF100,QF0,bmp,gif
colormap(map);
%task4
%bmp -> QF100
s = 0;
for i = 1:849
    for j =1:1566
        for k = 1:3
            m = (int32(p1(i,j,k))-int32(t1(i,j,k)))^2;
            s = s+m;
        end
    end
end
mse = double(s)/(2160*3840*3);
psnr = 10*log10(255*255/mse);%49.2337

%bmp -> QF0
s1 = 0;
for i = 1:849
    for j =1:1566
        for k = 1:3
            m = (int32(p1(i,j,k))-int32(t2(i,j,k)))^2;
            s1 = s1+m;
        end
    end
end
mse1 = double(s1)/(2160*3840*3);
psnr1 = 10*log10(255*255/mse1);%28.7706

%bmp -> gif
pnew = double(p1(:,:,1)*0.299)+double(p1(:,:,2)*0.587)+double(p1(:,:,3)*0.114);
s2 = 0;
for i = 1:849
    for j =1:1566
            m = (double(pnew(i,j))-double(p3(i,j)))^2;
            s2 = s2+m;
    end
end
mse2 = double(s2)/(2160*3840*3);
psnr2 = 10*log10(255*255/mse2);%13.4990


