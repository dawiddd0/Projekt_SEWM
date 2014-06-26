function [pic,psnr]=ckuf(file,krok,tryb,save,kompresja)
im=imread(file);
 j='.jpg';
switch kompresja
    case 0
        jakosc=80;
    case 1
        jakosc=85;
    case 2        
        jakosc=90;
    case 3        
        jakosc=95;
    case 4
        jakosc=100;
end
save=[save j];
[a,b,c]=size(im);
if a==3 | b==3 | c==3
   im=rgb2gray(im); 
   
end
file1=im;
if tryb==0
[szum]=ukryj(im);
pic=kodowanie(im,szum,krok);
imwrite(uint8(pic),save,'Quality',jakosc);
pic=uint8(pic);
else
pic=imread(file);
[x,y,z]=size(pic);
pic1=dekodowanie(pic,krok);
pic11=imresize(pic1,[x y]);
if tryb == 1
colormap gray;
imwrite(uint8(pic11),save,'Quality',jakosc);
pic=pic11;
file1=imread(file);

else
imwrite(uint8(pic11),save,'Quality',jakosc);
    end

pic=pic11;    
end
[psnr] = measerr(uint8(file1),uint8(pic))
function [pic21]=dekodowanie(im,krok)

[A,V,H,D]=dwt2(im,'haar','mode','sym');
MAX = max(A(:));
[m,n,k]=size(A);
zera=0:2*krok:MAX+krok;
jedynki=0+krok:2*krok:MAX;
%%%Odczytywanie znaku wodnego%%%
% for i=1:m 
%     for j=1:n
%         q=min(abs(A(i,j)-jedynki));
%         w=min(abs(A(i,j)-zera));
%         if q>w
%             szum(i,j)=0;
%         else
%             szum(i,j)=1;
%         end
%     end
% end
for i=1:m
    for j=1:n
        if (rem(A(i,j),10)>3.5 && rem(A(i,j),10)<6.5)
            szum(i,j)=1;
        else
            szum(i,j)=0;
        end        
    end
end
szum = logical(szum);
[m,n,k]=size(szum);
rng(int32(9),'twister'); 
macierz = randi([0 1],m,n,'uint8'); 
macierz=logical(macierz);
pic2=bitxor(macierz, szum);
rng(int32(9),'twister'); 
pion = randperm(n);
rng(int32(9),'twister');
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

imwrite((pic1),'odzyskano.png','png');
w=fspecial('gaussian',[4 4],2);
pic21=imfilter((pic1),w,'same');
function [pic]=kodowanie(im,szum,krok)

[A,H,V,D]=dwt2(im,'haar','mode','sym');
[a,b,c]=size(im);
[m,n,k]=size(A);
MAX = max(A(:));
zera=0:2*krok:MAX+krok;
jedynki=krok:2*krok:MAX;
Aemb=A; %Aemb macierz A, do ktrej zostanie dodany payload
%%%dodawanie payloadu%%%
wektor=min(min(A)):5:max(max(A)); %wektor wartoœci kwantyzacji
[m,q]=size(wektor);
macierzKwantyzacji=zeros(2,q);
macierzKwantyzacji(1,:)=wektor;
for i=1:q        %przygotowanie macierzy kwantyzacji
    if rem(wektor(i),10)==0
        macierzKwantyzacji(2,i)=0;
    else   
        macierzKwantyzacji(2,i)=1;
    end
end
[m,n]=size(A);
j=1;
k=1;
for i=1:q
    if rem(wektor(i),2)<1 && rem(wektor(i),2)>-1
        wektordz(j)=(wektor(i));  %kwantyzacja po 0
        j=j+1;
    else
        wektorpi(k)=(wektor(i)); %kwantyzacja po 1
        k=k+1;
    end
end
mi=min(min(A));
ma=max(max(A));
Aemb=A; %Aemb macierz A, do ktrej zostanie dodany payload


%%%dodawanie payloadu%%%
for i=1:m
    for j=1:n
        
        if szum(i,j)==0 
            indUp=find(wektordz>A(i,j));
            indDown=find(wektordz<A(i,j));
            
            if A(i,j)<mi+11
                indDown(1)=1;
                Aemb(i,j)=wektordz(indDown(1));
            
            elseif A(i,j)>ma-11
                [w,q]=size(wektordz);
                    indUp(1)=q;
                Aemb(i,j)=wektordz(indUp(1));
            elseif abs(wektordz(indUp(1))-A(i,j))<abs(wektordz(indDown(1))-A(i,j))
                Aemb(i,j)=wektordz(indUp(1));
            else
                Aemb(i,j)=wektordz(indDown(1));
            
            end
        else 
            indUp=find(wektorpi>A(i,j));
            indDown=find(wektorpi<A(i,j));     
            if A(i,j)<mi+11
                Aemb(i,j)=5;
            elseif A(i,j)>ma-11                 
                [w,q]=size(wektorpi);
                indUp(1)=q;
                    Aemb(i,j)=wektorpi(indUp(1));
            elseif abs(wektorpi(indUp(1))-A(i,j))<abs(wektorpi(indDown(1))-A(i,j))
                Aemb(i,j)=wektorpi(indUp(1));
            else
                Aemb(i,j)=wektorpi(indDown(1));
            
            end
        end
    end
end
pic=idwt2(Aemb,H,V,D,'haar',[a b c]); %scalenie nowej macierzy A w jeden obrazek
imwrite(uint8(pic),'zakodowany.png','png');
pic=double(pic);
function [pic]=ukryj(im)
[LPLP]=dwt2(im,'haar','mode','sym'); %dekompozycja falkowa
im=mat2gray(LPLP);
im=dither((im));
[m, n]=size(im);

rng(int32(9),'twister'); 
pion = randperm(n);
rng(int32(9),'twister');
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
rng(int32(9),'twister'); 
macierz = randi([0 1],m,n,'uint8'); 
macierz=logical(macierz);

pic=bitxor(macierz,pi);
imwrite(pic,'szum.png','png'); %zapisanie obrazu zakodowanego