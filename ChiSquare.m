G =imread('pout.png')    %uint8(finalstego);
%G=rgb2gray(G);
% G=f;
Bins=zeros([256,1]);
tsize=size(G);
Chis(tsize(1))=0;
P(tsize(1))=0;
fre=zeros([256,1]);
for i=1: tsize (1)
%count pixel frequencies
for j=1: tsize (2)
    Bins(G(i,j)+1)=Bins(G(i,j)+1)+1;
end
         %calculate chi squared
        chi2=0;
     for k=1:127
      nexp=(Bins(2*k-1)+Bins(2*k))/2;
           if nexp>5
             chi2=chi2+((Bins(2*k)-nexp)^2)/nexp;
           end
     end
Chis(i)=chi2 ;
%calculate 
xu=chi2;
r=127;
rOver2=0.5*r;
gammaval=gamma(rOver2);
 F=@(x)(x.^(rOver2-1).*exp(-0.5*x))/(gamma(rOver2)*2^rOver2);
if xu==inf
prob=1;
else
prob = quad(F,0,xu);
end
P(i)=1-prob;
end
% gra=chi('finalstego');
 plot(P)
xlabel('No of Rows');
ylabel('Probability of embedding');
