function [  ] = rekonstrukcja(  )

X = imread('lenaPrzerobiona.jpg'); %Wczytuje obrazek 
%if( size(X,3) > 1)
%    X = rgb2gray(X);
%end
ref = X;
X = double(X);

N = size(X,1);
Y = zeros(N);
step = 8;

%%Scalar

scalar = 0.13;


Y = zeros(N);
Z = zeros(8,8);
U = zeros(N);

a1 = 2;
a2 = 2.2;
a3 = 2.2;
a4 = 2.1;

[ RandX, przesX,przesY,qim] = GenerateRandX;

for i=1:step:N
    for j=1:step:N
        U(i:i+step-1,j:j+step-1) = dct2(X(i:i+step-1,j:j+step-1));
    end
end
tempX = zeros(4,1);
stat = 6;
for i=1:step:N
    for j=1:step:N
      il = 0;
      q = 1;
      for k = 1:step
           for l = 1:step                 
              if RandX(k,l) == 2
                 posX = mod(i + k - 1 + przesX,513) + floor((i + k - 1 + przesX)/513);
                 posY = mod(j + l - 1 + przesY,513) + floor((j + l - 1 + przesY)/513);
                 tempX(q) = U(posX,posY)/scalar;
                 q = q + 1;
              else
                 a = mod(U(i+k-1,j+l-1),2*qim);
                 if a > qim/2 && a < 3*qim/2
                    il = il + 1;
                 end
              end
           end
      end        
      stat = (stat + il)/2;
      Z(1,1) = a1*(sum(tempX));
      Z(1,2) = a2*(tempX(1) - tempX(2) + tempX(3) - tempX(4));
      Z(2,1) = a3*(tempX(1) + tempX(2) - tempX(3) - tempX(4));
      Z(2,2) = a4*(tempX(1) - tempX(2) - tempX(3) + tempX(4));
      Z = idct2(Z);
      Y(i:i+step-1,j:j+step-1) = Z;
      Z(:,:) = 0;
    end
end
stat
colormap gray;
imshow(uint8(X-Y));

%imagesc(X-Y)
imwrite(uint8(X-Y),'odzyskana.jpg');

[PSNR,MSE,MAXERR,L2RAT] = measerr(ref,Y);
PSNR

end

