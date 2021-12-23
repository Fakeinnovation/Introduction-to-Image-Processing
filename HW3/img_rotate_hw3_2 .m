A = imread('complex_texture.png');
A = rgb2gray(A);
imshow(A);
A1 = imrotation_bilinear(A,120);
figure,imshow(A1);
A2 = imrotation_bilinear(A1,-120);
%figure,imshow(A2);
A3 = imrotation_neighbor(A,120);
%figure,imshow(A3);
A4 = imrotation_neighbor(A3,-120);
%figure,imshow(A4);
A5 = imrotation_bicubic(A,120);
%figure,imshow(A5);
A6 = imrotation_bicubic(A5,-120);
%figure,imshow(A6);

imwrite(A1,'test1.png');
imwrite(A2,'test2.png');
imwrite(A3,'test3.png');
imwrite(A4,'test4.png');
imwrite(A5,'test5.png');
imwrite(A6,'test6.png');

new_A2 = A2(562:1861,562:1861);
PSNR_A2 = psnr(A,new_A2);

new_A4 = A4(564:1863,564:1863);
PSNR_A4 = psnr(A,new_A4);

new_A6 = 255*A6(560:1859,560:1859);
PSNR_A6 = psnr(A,uint8(new_A6));

function output = imrotation_neighbor(A,angle)
%angle transfer
a = angle/180*pi;
R = [cos(a), -sin(a); sin(a), cos(a)]; %rotate matrix
R = R'; %inverse matrix

%create rotate img size
[H,W] = size(A);
newH = ceil(H*abs(cos(a)) + W*abs(sin(a)));  %順時針旋轉時,加ABS
newW = ceil(H*abs(sin(a)) + W*abs(cos(a)));
output = zeros(newH,newW); % Initialize
center1 = [H;W] / 2;
center2 = [newH;newW] / 2;

for i = 1:newH
       for j = 1:newW
          dst = [i;j]; %旋轉後的pixel位置，data為2*1
          src = round(R * (dst - center2) + center1); % 求得旋轉後的pixel點對應到原圖上的點座標
          if (src(1) >= 1 && src(1) <= H && src(2) >= 1 && src(2) <= W) % 有在原圖的範圍內直接將值複製到新座標點上
             output(i,j) = A(src(1),src(2));
          end
       end
end
output = uint8(output);
end

function output = imrotation_bilinear(A,angle)
%angle transfer
a = angle/180*pi;
R = [cos(a), -sin(a); sin(a), cos(a)]; %rotate matrix
R = R'; %inverse matrix

%create rotate img size
[H,W] = size(A);
newH = floor(H*abs(cos(a)) + W*abs(sin(a)));  %順時針旋轉時,加ABS
newW = floor(H*abs(sin(a)) + W*abs(cos(a)));
output = zeros(newH,newW); % Initialize
center1 = [H;W] / 2;
center2 = [newH;newW] / 2;

for newi = 1:newH
       for newj = 1:newW
          dst = [newi; newj]; %旋轉後的pixel位置，data為2*1
          src = round(R * (dst - center2) + center1); % 求得旋轉後的pixel點對應到原圖上的點座標
          %Bilinear interpolation
          a = floor(src); % 向下取整數
          offset = src - a; % 偏移量
          u = offset(1);% x方向偏移量
          v = offset(2);% y方向的偏移量
          i = a(1);
          j = a(2);
          if (src(1) >= 1 && src(1) <= H-1 && src(2) >= 1 && src(2) <= W-1) % 有在原圖的範圍內直接將值複製到新座標點上
             output(newi,newj) = (1-u)*(1-v)*A(i,j)+(1-u)*v*A(i,j+1)+u*(1-v)*A(i+1,j)+u*v*A(i+1,j+1);
          end
       end
end
output = uint8(output);
end

% Calculation formula of distance coefficient---It's used in rotation
% 　　  { 1-2*Abs(x)^2+Abs(x)^3　　　　　 , 0<=Abs(x)<1
% S(x)=｛ 4-8*Abs(x)+5*Abs(x)^2-Abs(x)^3 , 1<=Abs(x)<2
% 　　  { 0　　　　　　　　　　　　　　　   , Abs(x)>=2
function S=cubic_factor(x)
    if 0<=abs(x)<1
        S=1-2.*abs(x).^2+abs(x).^3;
    elseif 1<=abs(x)<2
        S=4-8.*abs(x)+5.*abs(x).^2-abs(x).^3;
    else
        S=0;
    end
end

function output = imrotation_bicubic(img,n)
img=double(img);
[height,width]=size(img);
angle=n*pi/180; 
Center = round([height/2, width/2]);   
R=[cos(angle),sin(angle);-sin(angle),cos(angle)]; 
R=R';
nw = round(([1, 1]-Center)*R + Center);
ne = round(([1, width]-Center)*R + Center);
sw = round(([height, 1]-Center)*R + Center);
se = round(([height, width]-Center)*R + Center);
h = max([nw(1), ne(1), sw(1), se(1)]) - min([nw(1), ne(1), sw(1), se(1)]);
w = max([nw(2), ne(2), sw(2), se(2)]) - min([nw(2), ne(2), sw(2), se(2)]);
newc = round([h/2, w/2]);
Imgnew1=zeros(h,w);
Imgnew2=zeros(h,w);
Imgnew3=zeros(h,w);
for u=1:h    
    for v=1:w 
            Q=[u,v];
            P = (Q-newc)*R +Center;
            x=P(1);
            y=P(2);           
           if (x>=1 && x<=height && y>=1 && y<=width)    
                x_low=floor(x);
                x_up=ceil(x); 
                y_low=floor(y);
                y_up=ceil(y);  
                if (x-x_low)<=(x_up-x)         
                    x=x_low; 
                else
                    x=x_up;     
                end
                if (y-y_low)<=(y_up-y)            
                    y=y_low;         
                else
                    y=y_up;            
                end                  
           end          
           if (x>=2 && x<=height-2 && y>=2 && y<=width-2)   
                x_1=floor(x)-1;           
                x_2=floor(x);              
                x_3=floor(x)+1;            
                x_4=floor(x)+2;            
                y_1=floor(y)-1;          
                y_2=floor(y);            
                y_3=floor(y)+1;          
                y_4=floor(y)+2;          
                A=[cubic_factor(1+x-x_2),cubic_factor(x-x_2),cubic_factor(1-(x-x_2)),cubic_factor(2-(x-x_2))];        
                C1=[cubic_factor(1+y-y_2),cubic_factor(y-y_2),cubic_factor(1-(y-y_2)),cubic_factor(2-(y-y_2))];        
                B=[ img(x_1,y_1),img(x_1,y_2),img(x_1,y_3),img(x_1,y_4);      
                    img(x_2,y_1),img(x_2,y_2),img(x_2,y_3),img(x_2,y_4);      
                    img(x_3,y_1),img(x_3,y_2),img(x_3,y_3),img(x_3,y_4);      
                    img(x_4,y_1),img(x_4,y_2),img(x_4,y_3),img(x_4,y_4)];   
                output(u,v)=A*B*C1';      
           end     
    end
end
output = mat2gray(output);
end
