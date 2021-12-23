p = imread('John Wick.bmp');
p = rgb2gray(p);
newp =p>120;% turned to binary image

imshow(p);

posx = [0 1 2 0 1 2 0 1]/3;
posy = [2 2 2 1 1 1 0 0]/3;
figure
for i = 1:8
    subplot("position",[posx(i),posy(i),0.3,0.3]);
    imshow(logical(bitget(p,i)));
end

figure
for i = 1:7
    subplot("position",[posx(i),posy(i),0.3,0.3]);
    imshow(logical(xor(bitget(p,i),bitget(p,i+1))));
end
subplot("position",[posx(8),posy(8),0.3,0.3]);
imshow(logical(bitget(p,8)));



