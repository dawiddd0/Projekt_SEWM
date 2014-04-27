%Wczytanie zdjêcia
X=imread('john.jpg');
macierz_przewidywana=Losowanie();
colormap gray;
imagesc(X)
rozmiar=size(X,1);

%Sprawdzamy czy obrazek ma dobre wymiary
if size(X,1) ~= size(X,2) && mod(size(X,1),8) ~= 0
    error('Zly rozmiar zdjecia');
end

alfa=0.5;
T=10;
stala=1;

%Dodawanie znaku wodnego QIM
X2=double(X);
X=double(X);
for i=1:8:(rozmiar-8)
    for j=1:8:(rozmiar-8)
        X2(i:i+8/2-1,j:j+8/2-1)     = mean2(X2(i:i+8/2-1,j:j+8/2-1))/stala; %normalizacja bloków 4x4
        X2(i:i+8/2-1,j+8/2:j+8-1)   = mean2(X2(i:i+8/2-1,j+8/2:j+8-1))/stala;
        X2(i+8/2:i+8-1,j:j+8/2-1)   = mean2(X2(i+8/2:i+8-1,j:j+8/2-1))/stala;
        X2(i+8/2:i+8-1,j+8/2:j+8-1) = mean2(X2(i+8/2:i+8-1,j+8/2:j+8-1))/stala;        
        X(i:i+8-1,j:j+8-1)          = dct(X(i:i+8-1,j:j+8-1));
       
        for k=1:8
            for l=1:8
                r=mod(X(k+i-1,l+j-1),2*T);
                if macierz_przewidywana(k,l)==2
                    stala2=5;
                    X(i+k-1,j+l-1) = X2(i+k-1,j+l-1)/stala2;
                     elseif macierz_przewidywana(k,l) == 1
                         if r >= 3*T/2 && r < 2*T
                            X(i+k-1,j+l-1) = X(i+k-1,j+l-1) - r + 5*T/2;
                         elseif (r >= 0 && r < (T/2-alfa*T)) || ( r >= (T/2 + alfa*T) && r <= 3*T/2)
                                 X(i+k-1,j+l-1) = X(i+k-1,j+l-1) - r + T/2;
                         end
                     else
                    if ( r >= T/2 && r < ( 3*T/2 - alfa*T)) || (r >= (T/2 + alfa*T) && r < 2*T)
                        X(i+k-1,j+l-1) = X(i+k-1,j+l-1) - r + 3*T/2;
                    elseif  r >= 0 && r < T/2
                        X(i+k-1,j+l-1) = X(i+k-1,j+l-1) - r - T/2;
                    end
                 end
            end
        end
    end
end

for i=1:8:(rozmiar-8)
    for j=1:8:(rozmiar-8)
                X(i:i+8-1,j:j+8-1) = idct(X(i:i+8-1,j:j+8-1));
    end
end
imwrite(uint8(X),'john2.jpg');


[psnr,mse,maxerr,l2rat] = measerr(double(X),X);
psnr


