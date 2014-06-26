function [  ] = naprawa(X,skalar,qim,seed,seed_permutacji)
X=imread(X);
seed_permutacji=22432;
%X = imread('lenaPrzerobiona.jpg'); %Wczytuje obrazek 
%odniesienie = double(X);  %Odniesienie do zdjêcia w celu wyznaczenia PSNR

X = double(X);
N = size(X,1);
M = size(X,2);
% rozmiar
krok = 8; 

Y = zeros(N,M);
Z = zeros(8,8); %macierz do odczytu znaku wodnego
U = zeros(N,M); % pomocna macierz przy dct

%wspó³czynniki
a1 = 2;
a2 = 2.2;
a3 = 2.2;
a4 = 2.1;

[macierzLosowa] = Losowanie(seed);

%% Transformata dct do ka¿dego bloku
for i=1:krok:N
    for j=1:krok:N
        U(i:i+krok-1,j:j+krok-1) = dct2(X(i:i+krok-1,j:j+krok-1));
    end
end
tymczasoweX = zeros(4,1);
[ X_przes Y_przes ] = losowanie_skladnikow(seed_permutacji,N/krok,M/krok )  ; 

%stat = 6;
for i=1:krok:N
    for j=1:krok:M
      il = 0;
      q = 1;
      for k = 1:krok
           for l = 1:krok                 
              if macierzLosowa(k,l) == 2
                 pozX = (X_przes(floor(i/krok)+1)-1) * krok + k;
                 pozY = (Y_przes(floor(j/krok)+1)-1) * krok + l;
                 tymczasoweX(q) = U(pozX,pozY)/skalar;
                 q = q + 1;
              else
                 a = mod(U(i+k-1,j+l-1),2*qim);
                 if a > qim/2 && a < 3*qim/2
                    il = il + 1;
                 end
              end
           end
      end        
      if il > 6
      Z(1,1) = a1*(sum(tymczasoweX));
      Z(1,2) = a2*(tymczasoweX(1) - tymczasoweX(2) + tymczasoweX(3) - tymczasoweX(4));
      Z(2,1) = a3*(tymczasoweX(1) + tymczasoweX(2) - tymczasoweX(3) - tymczasoweX(4));
      Z(2,2) = a4*(tymczasoweX(1) - tymczasoweX(2) - tymczasoweX(3) + tymczasoweX(4));
      Z = idct2(Z);
      else
        Z = U(i:i+krok-1,j:j+krok-1);
		Z = idct2(Z);
      end
          
      Y(i:i+krok-1,j:j+krok-1) = Z;
      Z(:,:) = 0;
    end
end

figure,
colormap gray;
imagesc(uint8(Y))
%imshow(uint8(Y));
%imwrite(Y,'odzyskana.jpg','jpg','Quality',100);
%[psnr] = measerr(odniesienie,Y)
end

