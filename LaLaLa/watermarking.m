function [  ] = watermarking( )


%% Zmienne wejsciowe
X = imread('lena.jpg'); %Wczytuje obrazek 

step = 8;   % skok
N = size(X,1);
ref = double(X);


%% B³¹d jeœli niewymiarowy obrazek
if size(X,1) ~= size(X,2) && mod(size(X,1),8) ~= 0
  %  Disp('Wrong input');
    error('No way');
end
%% Jeœli nie,dawaj dalej
scalar = 0.13;
X2 = double(X);
X = double(X);
Y = zeros(N);
przesX=32;
przesY=64;
qim=5;
seed=23652;
[RandX] = GenerateRandX(seed);

for i=1:step:N
    for j=1:step:N
        Y(i:i+step-1,j:j+step-1) = dct2(X(i:i+step-1,j:j+step-1));
    end
end  

tempX = zeros(4,1);
        
for i=1:step:N
    for j=1:step:N
        tempX(1) = mean2(X2(i:i+step/2-1,j:j+step/2-1)) * scalar;
        tempX(2) = mean2(X2(i:i+step/2-1,j+step/2:j+step-1)) * scalar;
        tempX(3) = mean2(X2(i+step/2:i+step-1,j:j+step/2-1)) * scalar;
        tempX(4) = mean2(X2(i+step/2:i+step-1,j+step/2:j+step-1)) * scalar;
        q = 1;
        for k = 1:step
            for l = 1:step
                 if RandX(k,l) == 2
                     posX = mod(i + k - 1 + przesX,513) + floor((i + k - 1 + przesX)/513);
                     posY = mod(j + l - 1 + przesY,513) + floor((j + l - 1 + przesY)/513);
                     Y(posX,posY) = tempX(q);
                     q = q + 1;              
                 elseif RandX(k,l) == 1
                    u = mod(Y(i+k-1,j+l-1),2*qim);
                    if u <= qim
                        Y(i+k-1,j+l-1) = Y(i+k-1,j+l-1) - u + qim;
                    else
                        Y(i+k-1,j+l-1) = Y(i+k-1,j+l-1) + 1*qim - u;
                    end
                 else 
                    u = mod(Y(i+k-1,j+l-1),2*qim);
                    if u <= qim
                        Y(i + k - 1, j + l - 1) = Y(i+k-1,j+l-1) - u;
                    else
                        Y(i+k-1,j+l-1) = Y(i+k-1,j+l-1) + 2*qim - u;
                    end
                 end
            end
        end
    end
end


for i=1:step:N
    for j=1:step:N
        X(i:i+step-1,j:j+step-1) = idct2(Y(i:i+step-1,j:j+step-1));
    end
end
%% Wstaw watermarki

Y = X;
Y = uint8(Y);

imwrite(Y,'lenaPrzerobiona.jpg');

figure,
colormap gray;
imagesc(X)

[PSNR,MSE,MAXERR,L2RAT] = measerr(ref,X);
PSNR
end




