function [pic]=ckuf(file,krok,tryb,save)
%krok=15;
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
[A,V,H,D]=dwt2(im,'haar','mode','sym');
MAX = max(A(:));
[m,n,k]=size(A);
szum=zeros(m,n);

zera=0:2*krok:MAX+krok;
jedynki=0+krok:2*krok:MAX;
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
szum = logical(szum);
[m,n,k]=size(szum);
rng(2,'twister'); 
macierz = randi([0 1],m,n,'uint8'); 
macierz=logical(macierz);
pic2=bitxor(szum, macierz);
[m,n]=size(szum);
rng(2,'twister'); 
pion = randperm(n);
rng(2,'twister');
poziom = randperm(m);
s = RandStream('mt19937ar','Seed',0);
k=randperm(s,m); %przygotowanie permutacji
s = RandStream('mt19937ar','Seed',0);
l=randperm(s,n);
for i=1:m     %u??nie bit? w odpowiedniej kolejno?i (odwrotna permutacja)
    for j=1:n
        pic1(i,j)=pic2(k(i),l(j));
    end
end





pic1=uint8(pic1);
pic1=pic1.*255;
imwrite((pic1),'odzyskano.jpg','jpg');
w=fspecial('gaussian',[5 5],2);
pic21=imfilter((pic1),w,'same');

imshow(uint8(pic21))


function [pic]=kodowanie(im,szum,krok)

[A,V,H,D]=dwt2(im,'haar','mode','sym');
[a,b,c]=size(im);


[m,n,k]=size(szum);
MAX = max(A(:));
zera=0:2*krok:MAX+krok;
jedynki=krok:2*krok:MAX;
Aemb=A; %Aemb macierz A, do ktrej zostanie dodany payload
%%%dodawanie payloadu%%%
for i=1:m
    for j=1:n
       if szum(i,j) == 1 
            [~,I]=min(abs(Aemb(i,j)-jedynki));
            Aemb(i,j)=jedynki(I);
        end
        
        if szum(i,j) == 0
            [~,I]=min(abs(Aemb(i,j)-zera));
            Aemb(i,j)=zera(I);
        end
        
        
        
    end
end

pic=idwt2((Aemb),V,H,D,'haar',[a b]); %scalenie nowej macierzy A w jeden obrazek
imwrite(uint8(pic),'zakodowany.jpg','jpg');
[psnr] = measerr(uint8(pic),double(pic))
function [pic]=ukryj(im)


im=dither((im));
[LPLP]=dwt2(im,'haar','mode','sym'); %dekompozycja falkowa

imshow(LPLP);
[m, n]=size(LPLP);


rng(2,'twister'); 
pion = randperm(n);

rng(2,'twister');
poziom = randperm(m);

s = RandStream('mt19937ar','Seed',0);
k=randperm(s,m); %przygotowanie permutacji
s = RandStream('mt19937ar','Seed',0);
l=randperm(s,n);
pi=zeros(m,n);
for i=1:m     %wykonanie permutacji
   for j=1:n
      pi(k(i),l(j))=LPLP(i,j);
    end
end
rng(2,'twister'); 
macierz = randi([0 1],m,n,'uint8'); 
macierz=uint8(macierz);

pic=bitxor((macierz),uint8(pi));
imwrite(pic,'szum.jpg','jpg'); %zapisanie obrazu zakodowanego


