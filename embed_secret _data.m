1.EMBEDDING A SECRET MESSAGE INSIDE  COVER IMAGE,CALCULATION OF MEAN SQUARE     ERROR AND PSNR FOR THE OBTAINED STEGO IMAGE


I=imread('cameraman.tif');
%I=rgb2gray(I);
I=imresize(I,[128 128]);
[row col]= size(I);
figure,imshow(I);
EI = zeros(row,col);
xenergy=0;
yenergy=0;
% for pixels at the four corners of the image:
for m = 1 :4:row-3
for n = 1 : 4: col-3
    for i=m:m+3
        for j=n:n+3
if  i ==m  && j==n
xenergy = xenergy +((- 2)* I(i,j+1))-I(i+1,j+1);
yenergy = yenergy +((- 2) * I(i+1,j)) - I(i+1,j+1);
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
end 
if   i==m && j==n+3
xenergy = 2* I(i,j-1) + I(i+1,j-1);
yenergy = - I(i+1,j-1)  - 2 * I(i+1,j);
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
end
 if  i ==m+3 && j==n
xenergy = - I(i-1,j+1) - (2* I(i,j+1));
yenergy =  2* I(i-1,j) + I(i-1,j+1);
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
 end
 if  i ==m+3 && j==n+3
xenergy = I(i-1,j-1) + 2* I(i,j-1);
yenergy = I(i-1,j-1) + 2* I(i-1,j);
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
 end
 end 
end
% for the pixels which are not present at the edges at all:
for i= m+1:m+2
for j= n+1:n+2
xenergy = I(i-1,j-1) + 2* I(i,j-1) + I(i+1,j-1) - I(i-1,j+1) - 2* I(i,j+1) -I(i+1,j+1);
yenergy = I(i-1,j-1) + 2* I(i-1,j) + I(i-1,j+1) - I(i+1,j-1)  - 2 * I(i+1,j) - I(i+1,j+1);
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
end
end
% for pixels which are not at the edges except the four corners (for top and bottom row):
for i = m:m+3
for j = n+1:n+2
if (i==m)
xenergy = 2* I(i,j-1) + I(i+1,j-1) - 2* I(i,j+1) -I(i+1,j+1);
yenergy = - I(i+1,j-1)  - 2 * I(i+1,j) - I(i+1,j+1);
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
end
if i==(m+3)
xenergy = I(i-1,j-1) + 2* I(i,j-1) - I(i-1,j+1) - 2* I(i,j+1);
yenergy = I(i-1,j-1) + 2* I(i-1,j) + I(i-1,j+1) ;
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
end
end
end
% for pixels which are not at the edges except the four corners (forleftmost and rightmost column):
for i = m+1:m+2
for j = n:n+3
if (j==n)
xenergy = - I(i-1,j+1) - 2* I(i,j+1) -I(i+1,j+1);
yenergy = 2* I(i-1,j) + I(i-1,j+1) - 2 * I(i+1,j) - I(i+1,j+1);
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
end
if (j==n+3)
xenergy = I(i-1,j-1) + 2* I(i,j-1) + I(i+1,j-1);
yenergy = I(i-1,j-1) + 2* I(i-1,j) - I(i+1,j-1)  - 2 * I(i+1,j) ;
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
end
end
end
end
end
disp(EI);
% cost of the pixel
[row col]= size(EI);
cost = zeros (row,col);
for m = 1:4:row-3 
 for n = 1:4:col-3
     for i=m:m+3
            for j=n:n+3
 if (i==m)
 cost(i,j) = EI(i,j);  
 end
 if (i>m)
    if (j==n)
    if (cost(i-1,j)) < (cost(i-1,j+1))
    small = cost(i-1,j);
   else
         small = cost(i-1,j+1);
    end
   cost(i,j) = EI(i,j) + small;
     end      
 if (j>n) && (j<n+3)
 if (cost(i-1,j-1) < cost(i-1,j)) && (cost(i-1,j-1) < cost(i-1,j+1))
      small = cost(i-1,j-1);
 elseif (cost(i-1,j) < cost(i-1,j-1)) && (cost(i-1,j) < cost(i-1,j+1))
         small = cost(i-1,j);
 else
  small = cost(i-1,j+1);
 end
 cost(i,j) = EI(i,j) + small;
 end
 if (j==n+3)
  if (cost(i-1,j-1)) < (cost(i-1,j))
       small = cost(i-1,j-1);
  else
    small = cost(i-1,j);
  end 
 cost(i,j) = EI(i,j) + small;
 end
 end
 end
end
    end 
end
disp(cost);
%dynamic_programming and embedding secret bits
q=1;
p=1;
msg = randi([0,1],1,32*32*4*q); %for all the 64 by 64 blocks
disp(msg);
%max will store the pixel value corresponding to the maximum cost 
%temp will store the maximum cost 
temp=zeros(1,4);
max=zeros(1,4);
  for m=1:4:row-3
      for n=1:4:col-3 
          s=1;
          t=1;
           temp(1)=cost(m,n);
for i= m:m+3
     if(i==m)
    for j=n:n+2
            if temp(1)<cost(i,j+1)
temp(1)=cost(i,j+1);
max(t)=I(i,j+1);
J= de2bi(max(t));
            J(1:q) = fliplr(msg(p:p+q-1));
            I(i,j+1) = bi2de(J);
            end
    end
     else
       if (temp(s)==cost(i-1,n))
if(cost(i,n)>cost(i,n+1))
temp(s+1)=cost(i,n);
max(t)=I(i,n);
J= de2bi(max(t));
            J(1:q) = fliplr(msg(p:p+q-1));
            I(i,n) = bi2de(J);
else
temp(s+1)=cost(i,n+1);
max(t)=I(i,n+1);
J= de2bi(max(t));
            J(1:q) = fliplr(msg(p:p+q-1));
            I(i,n+1) = bi2de(J);
end
     elseif (temp(s)==cost(i-1,n+3))
if(cost(i,n+2)>=cost(i,n+3))
temp(s+1)=cost(i,n+2);
max(t)=I(i,n+2);
J= de2bi(max(t));
            J(1:q) = fliplr(msg(p:p+q-1));
            I(i,n+2) = bi2de(J);
else
temp(s+1)=cost(i,n+3);
max(t)=I(i,n+3);
J= de2bi(max(t));
            J(1:q) = fliplr(msg(p:p+q-1));
            I(i,n+3) = bi2de(J);
end
    elseif (temp(s)==cost(i-1,n+1))
if(cost(i,n+1)>=cost(i,n+2) && cost(i,n+1)>cost(i,n))
temp(s+1)=cost(i,n+1);
max(t)=I(i,n+1);
J= de2bi(max(t));
            J(1:q) = fliplr(msg(p:p+q-1));
            I(i,n+1) = bi2de(J);
elseif (cost(i,n+2)>cost(i,n)&& cost(i,n+2)>cost(i,n+1))
temp(s+1)=cost(i,n+2);
max(t)=I(i,n+2);
J= de2bi(max(t));
            J(1:q) = fliplr(msg(p:p+q-1));
            I(i,n+2) = bi2de(J);
else
temp(s+1)=cost(i,n);
max(t)=I(i,n);
J= de2bi(max(t));
            J(1:q) = fliplr(msg(p:p+q-1));
            I(i,n) = bi2de(J);
end
elseif (temp(s)==cost(i-1,n+2))
if(cost(i,n+2)>cost(i,n+1) && cost(i,n+2)>=cost(i,n+3))
temp(s+1)=cost(i,n+2);
max(t)=I(i,n+2);
J= de2bi(max(t));
            J(1:q) = fliplr(msg(p:p+q-1));
            I(i,n+2) = bi2de(J);
elseif (cost(i,n+1)>=cost(i,n+3)&& cost(i,n+1)>=cost(i,n+2))
temp(s+1)=cost(i,n+1);
max(t)=I(i,n+1);
J= de2bi(max(t));
            J(1:q) = fliplr(msg(p:p+q-1));
            I(i,n+1) = bi2de(J);
else
temp(s+1)=cost(i,n+3);
max(t)=I(i,n+3);
J= de2bi(max(t));
            J(1:q) = fliplr(msg(p:p+q-1));
            I(i,n+3) = bi2de(J);
end
       end
     end 
     s=s+1;
     t=t+1; 
     p=p+q;
end
      end
  end
figure,imshow(I);
R=imread('cameraman.tif');
%R=rgb2gray(R);
R=imresize(R,[128 128]);
[row col]= size(R);
figure,imshow(R);
for m = 1:row
    for n = 1:col
        err1(m,n) = R(m,n) - I(m,n);           % error after simple LSB
    end
end
mse1 = 0;
psnr = 0;
i2=double(I);
i4=double(R)
for m = 1:row
    for n = 1:col
        mse1 = mse1 + (i4(m,n) - i2(m,n))^2;
    end
end
im0=double(i2);
im1=double(i4);
[m n]=size(im1);
mse=sum(sum((im0-im1).^2))./(m.*n);
psnr=10*log10(65025/mse);
mse1 = mse1/(row*col);
disp(mse1);
