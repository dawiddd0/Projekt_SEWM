function [  ] = znakowanie(X,skalar,qim,seed,seed_permutacji)
X=imread(X);
seed_permutacji=22432;
%% Zmienne wejsciowe
%X = imread('johnny-depp1.jpg'); %Wczytuje obrazek 
krok = 8;   % skok
[N,M]= size(X);
odniesienie = double(X); %Odniesienie do zdjêcia w celu wyznaczenia PSNR


%% Wymiary obrazka

if size(X,1) ~= size(X,2) && mod(size(X,1),8) ~= 0
    error('Z³y rozmiar - proszê podaæ inne zdjêcie');
end
%% Algorytm pocz¹tek - zmienne pierwotne
X2 = double(X);
X = double(X);
Y = zeros(N,M);


[macierzLosowa] = Losowanie(seed);

%% transformata kosinusowa do ka¿dego bloku 
for i=1:krok:N
    for j=1:krok:M
        Y(i:i+krok-1,j:j+krok-1) = dct2(X(i:i+krok-1,j:j+krok-1));
    end
end  

tymczasoweX = zeros(4,1); % pomoc w tworzeniu tymczasowych bloków 4x4 i ich normalizaji
[ X_przes Y_przes ] = losowanie_skladnikow(seed_permutacji,N/krok,M/krok )  ;      
for i=1:krok:N
    for j=1:krok:N
        %% normalizacja bloków 4x4
        tymczasoweX(1) = mean2(X2(i:i+krok/2-1,j:j+krok/2-1)) * skalar;
        tymczasoweX(2) = mean2(X2(i:i+krok/2-1,j+krok/2:j+krok-1)) * skalar;
        tymczasoweX(3) = mean2(X2(i+krok/2:i+krok-1,j:j+krok/2-1)) * skalar;
        tymczasoweX(4) = mean2(X2(i+krok/2:i+krok-1,j+krok/2:j+krok-1)) * skalar;
        q = 1;
        for k = 1:krok
            for l = 1:krok
                % znakowanie dla autentykacji i rekonstrukcji
                 if macierzLosowa(k,l) == 2
                     posX = (X_przes(floor(i/krok)+1)-1)*krok + k ;
                     posY = (Y_przes(floor(j/krok)+1)-1)*krok + l ;
                     Y(posX,posY) = tymczasoweX(q);
                     q = q + 1;              
                 elseif macierzLosowa(k,l) == 1
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


for i=1:krok:N
    for j=1:krok:N
        X(i:i+krok-1,j:j+krok-1) = idct2(Y(i:i+krok-1,j:j+krok-1));
    end
end
%% Wstawianie znakow wodnych
Y = X;
Y = uint8(Y);

imwrite(Y,'Przerobione.jpg','jpg','Quality',100);

figure,
colormap gray;
%imagesc(X)
imshow(uint8(X));
[psnr] = measerr(X,odniesienie)

end




