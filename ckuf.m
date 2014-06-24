function [pic]=ckuf(file,krok,tryb,save)
krok=14;
im=imread(file);
j='.jpg';
save=[save j];
[a,b,c]=size(im);
if a==3 | b==3 | c==3
   im=rgb2gray(im); 
end
if tryb==0
[szum]=ukryj(im);
pic=kodowanie(im,szum,krok);
imwrite(uint8(pic),save,'jpg');
imshow(uint8(pic));
pic=uint8(pic);
else
pic=imread(file);
[x,y,z]=size(pic);
pic1=dekodowanie(pic,krok);
pic11=imresize(pic1,[x y]);
[A,V,H,D]=dwt2(pic,'haar');
%pic11=idwt2(pic1,V,H,D,'haar','mode','sym');
    if tryb == 1
colormap gray;
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

[A,V,H,D]=dwt2(im,'haar','mode','sym');
MAX = max(A(:));
[m,n,k]=size(A);
zera=0:2*krok:MAX+krok;
jedynki=0+krok:2*krok:MAX;
%%%Odczytywanie znaku wodnego%%%
for i=1:m 
    for j=1:n
        q=min(abs(A(i,j)-jedynki));
        w=min(abs(A(i,j)-zera));
        if q>w
            szum(i,j)=0;
        else
            szum(i,j)=1;
        end
    end
end
szum = logical(szum);
[m,n,k]=size(szum);
rng(int32(940583),'twister'); 
macierz = randi([0 1],m,n,'uint8'); 
macierz=logical(macierz);
pic2=bitxor(macierz, szum);
rng(int32(940583),'twister'); 
pion = randperm(n);
rng(int32(940583),'twister');
poziom = randperm(m);

for i=1:n;
    for j=1:m;
        pion2(poziom(1,j),i)=pic2(j,i);
    end
end

for i=1:m;
    for j=1:n;
        pic1(i,pion(1,j))=pion2(i,j);
    end
end
pic1=uint8(pic1);
[r,k]=find(pic1);
for i=1:size(r)
    pic1(r(i),k(i))=255;
end

imwrite((pic1),'odzyskano.jpg','jpg');
w=fspecial('gaussian',[4 4],2);
pic21=imfilter((pic1),w,'same');

imshow(uint8(pic21))
function [pic]=kodowanie(im,szum,krok)

[A,H,V,D]=dwt2(im,'haar','mode','sym');
[a,b,c]=size(im);
[m,n,k]=size(A);
MAX = max(A(:));
zera=0:2*krok:MAX+krok;
jedynki=krok:2*krok:MAX;
Aemb=A; %Aemb macierz A, do ktrej zostanie dodany payload
%%%dodawanie payloadu%%%
for i=1:m
    for j=1:n
       if szum(i,j) == 0 
            [~,I]=min(abs(Aemb(i,j)-zera));
            Aemb(i,j)=zera(I);
        end
        
        if szum(i,j) == 1
            [~,I]=min(abs(Aemb(i,j)-jedynki));
            Aemb(i,j)=jedynki(I);
        end
    end
end

pic=idwt2(Aemb,H,V,D,'haar',[a b c]); %scalenie nowej macierzy A w jeden obrazek
imwrite(uint8(pic),'zakodowany.jpg','jpg');
[psnr] = measerr(double(pic),im)
pic=double(pic);
function [pic]=ukryj(im)
[LPLP]=dwt2(im,'haar','mode','sym'); %dekompozycja falkowa
im=mat2gray(LPLP);
im=dither((im));
[m, n]=size(im);

rng(int32(940583),'twister'); 
pion = randperm(n);
rng(int32(940583),'twister');
poziom = randperm(m);
for i=1:m 
    for j=1:n
        pion2(i,j) = im(i,pion(1,j));
    end
end

for i=1:n 
    for j=1:m
        pi(j,i) = pion2(poziom(1,j),i);
    end
end
rng(int32(940583),'twister'); 
macierz = randi([0 1],m,n,'uint8'); 
macierz=logical(macierz);

pic=bitxor(macierz,pi);
imwrite(pic,'szum.jpg','jpg'); %zapisanie obrazu zakodowanego