I =[4 4 2 1;4 9 3 4;6 8 7 6;7 3 5 3]
[row col]= size(I);
EI = zeros(row,col);
xenergy=0;
yenergy=0;
% for pixels at the four corners of the image:
for i = 1 : row
for j = 1 : col
if  i == 1 && j==1
xenergy = xenergy +((- 2)* I(i,j+1))-I(i+1,j+1);
yenergy = yenergy +((- 2) * I(i+1,j)) - I(i+1,j+1);
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
end 
if  i == 1 && j==col
xenergy = 2* I(i,j-1) + I(i+1,j-1);
yenergy = - I(i+1,j-1)  - 2 * I(i+1,j);
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
end
 if  i == row && j==1
xenergy = - I(i-1,j+1) - (2* I(i,j+1));
yenergy =  2* I(i-1,j) + I(i-1,j+1);
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
 end
 if  i == row && j==col
xenergy = I(i-1,j-1) + 2* I(i,j-1);
yenergy = I(i-1,j-1) + 2* I(i-1,j);
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
 end
 end 
end
% for the pixels which are not present at the edges at all:
for i= 2:(row-1)
for j= 2:(col-1)
xenergy = I(i-1,j-1) + 2* I(i,j-1) + I(i+1,j-1) - I(i-1,j+1) - 2* I(i,j+1) -I(i+1,j+1);
yenergy = I(i-1,j-1) + 2* I(i-1,j) + I(i-1,j+1) - I(i+1,j-1)  - 2 * I(i+1,j) - I(i+1,j+1);
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
end
end
% for pixels which are not at the edges except the four corners (for top and bottom row):
for i = 1: row
for j = 2: col-1
if (i==1)
xenergy = 2* I(i,j-1) + I(i+1,j-1) - 2* I(i,j+1) -I(i+1,j+1);
yenergy = - I(i+1,j-1)  - 2 * I(i+1,j) - I(i+1,j+1);
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
end
if i==row
xenergy = I(i-1,j-1) + 2* I(i,j-1) - I(i-1,j+1) - 2* I(i,j+1);
yenergy = I(i-1,j-1) + 2* I(i-1,j) + I(i-1,j+1) ;
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
end
end
end
% for pixels which are not at the edges except the four corners (forleftmost and rightmost column):
for i = 2: row-1
for j = 1: col
if (j==1)
xenergy = - I(i-1,j+1) - 2* I(i,j+1) -I(i+1,j+1);
yenergy = 2* I(i-1,j) + I(i-1,j+1) - 2 * I(i+1,j) - I(i+1,j+1);
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
end
if (j==col)
xenergy = I(i-1,j-1) + 2* I(i,j-1) + I(i+1,j-1);
yenergy = I(i-1,j-1) + 2* I(i-1,j) - I(i+1,j-1)  - 2 * I(i+1,j) ;
E = sqrt(double(xenergy).^2 + double(yenergy).^2);
EI(i,j) = E;
end
end
end
disp(EI);
% cost of the pixel
[row col]= size(EI);
for i=1:row
    for j=1:col
        [row col] = size(EI);
cost = zeros (row,col);
for i = 1:row 
 for j = 1:col  
 if (i==1)
 cost(i,j) = EI(i,j);  
 end
 if (i>1)
    if (j==1)
    if (cost(i-1,j)) < (cost(i-1,j+1))
    small = cost(i-1,j);
   else
         small = cost(i-1,j+1);
    end
   cost(i,j) = EI(i,j) + small;
     end      
 if (j>1) && (j<col)
 if (cost(i-1,j-1) < cost(i-1,j)) && (cost(i-1,j-1) < cost(i-1,j+1))
      small = cost(i-1,j-1);
 elseif (cost(i-1,j) < cost(i-1,j-1)) && (cost(i-1,j) < cost(i-1,j+1))
         small = cost(i-1,j);
 else
  small = cost(i-1,j+1);
 end
 cost(i,j) = EI(i,j) + small;
 end
 if (j==col)
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
%max will store the pixel value corresponding to the maximum cost 
%temp will store the maximum cost 
msg=[1 0 0 1 0 0 1 1 0 0 1 1];%for all the 64 by 64 blocks
disp(msg);
p=1;
%max will store the pixel value corresponding to the maximum cost 
%temp will store the maximum cost 
temp=zeros(1,4);
max=zeros(1,4);
s=1;
t=1;
  q=3;
  temp(1)=cost(1,1);
  max(1)=I(1,1);
for i= 1:4
     if(i==1)
    for j=1:3
            if temp(1)<cost(1,j+1)
temp(1)=cost(1,j+1);
max(1)=I(1,j+1);
%I(1,j+1)=max(1);
            end 
    end
     else
       if (temp(s)==cost(i-1,1))
if(cost(i,1)>cost(i,2))
temp(s+1)=cost(i,1);
max(t+1)=I(i,1);
%I(i,1)=max(t+1);
else
temp(s+1)=cost(i,2);
max(t+1)=I(i,2);
%I(i,2)=max(t+1);
end
     elseif (temp(s)==cost(i-1,4))
if(cost(i,3)>cost(i,4))
temp(s+1)=cost(i,3);
max(t+1)=I(i,3);
%I(i,3)=max(t+1);
else
temp(s+1)=cost(i,4);
max(t+1)=I(i,4);
%I(i,4)=max(t+1);
end
    elseif (temp(s)==cost(i-1,2))
if(cost(i,2)>cost(i,3) && cost(i,2)>cost(i,1))
temp(s+1)=cost(i,2);
max(t+1)=I(i,2);
%I(i,2)=max(t+1);
elseif (cost(i,3)>cost(i,1)&& cost(i,3)>cost(i,2))
temp(s+1)=cost(i,3);
max(t+1)=I(i,3);
%I(i,3)=max(t+1);
else
temp(s+1)=cost(i,1);
max(t+1)=I(i,1);
%I(i,1)=max(t+1);
end
elseif (temp(s)==cost(i-1,3))
if(cost(i,3)>cost(i,2) && cost(i,3)>cost(i,4))
temp(s+1)=cost(i,3);
max(t+1)=I(i,3);
%I(i,3)=max(t+1);
elseif (cost(i,2)>cost(i,4)&& cost(i,2)>cost(i,3))
temp(s+1)=cost(i,2);
max(t+1)=I(i,2);
%I(i,2)=max(t+1);
else
temp(s+1)=cost(i,4);
max(t+1)=I(i,4);
%I(i,4)=max(t+1);
end  
    end
       s=s+1;
       t=t+1;
     end  
end
disp(temp);
disp(max);
