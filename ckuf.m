function [pic]=ckuf(file,krok,tryb,save)
im=imread(file);
j='.jpg';
save=[save j];
if tryb==0
[szum]=ukryj(im);
pic=kodowanie(im,szum,krok);
imwrite(uint8(pic),save,'jpg');
imshow(uint8(pic));
pic=uint8(pic);
else
pic=imread(file);
pic1=dekodowanie(pic,krok).*255;
w=fspecial('gaussian');
pic1=imfilter(pic1,w);
[A,V,H,D]=dwt2(pic,'haar');
pic11=idwt2(pic1,V,H,D,'haar');
w=fspecial('gaussian');
pic11=imfilter(pic11,w);
    if tryb == 1
imwrite(uint8(pic11),save,'jpg');
imshow(uint8(pic11));
pic=pic11;
else
imwrite(uint8(pic11)-pic,save,'jpg');
imshow(uint8(pic11)-pic);
pic=pic11;    
    end
end
function [pic21]=dekodowanie(im,krok)
%im=rgb2gray(im);
[A,V,H,D]=dwt2(im,'haar');
[m,n]=size(A);
szum=zeros(m,n);
s = RandStream('mt19937ar','Seed',0);
k=randperm(s,m); %przygotowanie permutacji
s = RandStream('mt19937ar','Seed',0);
l=randperm(s,n);
%%%Odczytywanie znaku wodnego%%%
for i=1:m 
    for j=1:n
        if (rem(A(i,j),2*krok)>(krok/2) && rem(A(i,j),2*krok)<(krok+krok/2))
            szum(i,j)=1;
        else
            szum(i,j)=0;
        end        
    end
end
for i=1:m     %u³o¿enie bitów w odpowiedniej kolejnoœci (odwrotna permutacja)
    for j=1:n
        pic1(i,j)=szum(k(i),l(j));
    end
end
macierz=losowanie(m,n);
pic2=xor(macierz,pic1);
imwrite((pic2),'odzyskano.jpg','jpg');
w=fspecial('gaussian');
pic21=imfilter((pic2),w);

function [pic]=kodowanie(im,szum,krok)
im=rgb2gray(im);
[A,V,H,D]=dwt2(im,'haar');
[m,n]=size(A);
Aemb=A; %Aemb macierz A, do ktrej zostanie dodany payload
%%%dodawanie payloadu%%%
for i=1:m
    for j=1:n
        if (rem(A(i,j),(2*krok))>(krok/2) && rem(A(i,j),(2*krok))<(krok+krok/2))
            Aemb(i,j)=2*krok*round(A(i,j)/(2*krok))+szum(i,j)*krok;
        else
            Aemb(i,j)=2*krok*round(A(i,j)/(2*krok))-szum(i,j)*krok;
        end
    end
end

pic=idwt2(double(Aemb),V,H,D,'haar'); %scalenie nowej macierzy A w jeden obrazek
imshow(uint8(pic));
imwrite(uint8(pic),'zakodowany.jpg','jpg');
function [picperm]=ukryj(im)
im=rgb2ntsc(im);
im=rgb2gray(im);
im=dither(im);
%imshow(im);
[LPLP,LPHP,HPLP,HPHP]=dwt2(im,'haar'); %dekompozycja falkowa
%imshow(LPLP);
[m,n]=size(LPLP);
macierz=losowanie(m,n);
pic=xor((LPLP),(macierz)); %XOR macierzy i dolnoprzepustowej sk³adowej dekompozycji falkowej
s = RandStream('mt19937ar','Seed',0);
k=randperm(s,m); %przygotowanie permutacji
s = RandStream('mt19937ar','Seed',0);
l=randperm(s,n);
picperm=zeros(m,n);
for i=1:m     %wykonanie permutacji
   for j=1:n
      picperm(k(i),l(j))=pic(i,j);
    end
end
imwrite(picperm,'szum.jpg','jpg'); %zapisanie obrazu zakodowanego
%%%rekonstrukcja
pic1=zeros(m,n);
for i=1:m     %u³o¿enie bitów w odpowiedniej kolejnoœci (odwrotna permutacja)
    for j=1:n
        pic1(i,j)=picperm(k(i),l(j));
    end
end
pic1=xor(macierz,pic1); % w³aœciwa rekonstrukcja
%imshow(pic1);   %obraz wynikowy, z rekonustrukcji otrzymany
imwrite(pic1,'rekonstrukcja.jpg','jpg'); %zapisanie obrazu zdekodowanego
function [y]=losowanie(h,b)
y=zeros(h,b);
m=10113904223;
a=1664525;
y(1)=rem(a+m,255);
for i=2:round(h/4)
    for j=2:round(b/4)
    y(i,j)=rem(y(i-1,j-1)*a+m,255);
    end
end

for i=round(h/4):round(h/2)
    for j=round(b/4):round(b/2)
    y(i,j)=rem(y(i-1,j-1)*a+m,255);
    end
end

for i=round(3/4*h):h
    for j=round(3/4*b):b
    y(i,j)=rem(y(i-1,j-1)*a+m,255);
    end
end

for i=round(h/2):round(3*h/4)
    for j=round(b/2):3*round(b/4)
    y(i,j)=rem(y(i-1,j-1)*a+m,255);
    end
end
