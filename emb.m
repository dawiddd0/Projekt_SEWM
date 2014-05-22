function []=emb()
im=imread('photo.jpg');
[szum,k,l]=ukryj(im);
pic=kodowanie(im,szum);
%pic=(imread('popsuta.jpg'));
pic1=dekodowanie(pic,k,l);
[pic2,V,H,D]=dwt2(pic,'haar');
%pic2=rgb2ntsc(pic2);
%pic2=rgb2gray(pic2);
pic2=dither(pic2);
figure(2)
imshow((pic1-pic2));


function [pic1]=dekodowanie(im,k,l)
%im=rgb2ntsc(im);
%im=rgb2gray(im);
[A,V,H,D]=dwt2(im,'haar');
wektor=min(min(A)):5:max(max(A));
[m,n]=size(A);
szum=zeros(m,n);
for i=1:m
    for j=1:n
        if (rem(A(i,j),10)>3.5 && rem(A(i,j),10)<6.5)
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
pic1=xor(macierz,pic1);
figure(3)
imshow(pic1);
function [pic]=kodowanie(im,szum)

im=rgb2gray(im);
[A,V,H,D]=dwt2(im,'haar');
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


pic=idwt2(double(Aemb),V,H,D,'haar'); %scalenie nowej macierzy A w jeden obrazek
imshow(uint8(pic));
imwrite(uint8(pic),'zakodowany.jpg','jpg');
function [picperm,k,l]=ukryj(im)
im=rgb2ntsc(im);
im=rgb2gray(im);
im=dither(im);
%imshow(im);
[LPLP,LPHP,HPLP,HPHP]=dwt2(im,'haar'); %dekompozycja falkowa
%imshow(LPLP);
[m,n]=size(LPLP);
macierz=losowanie(m,n);
pic=xor((LPLP),(macierz)); %XOR macierzy i dolnoprzepustowej sk³adowej dekompozycji falkowej
k=randperm(m); %przygotowanie permutacji
l=randperm(n);
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
for i=2:h/4
    for j=2:b/4
    y(i,j)=rem(y(i-1,j-1)*a+m,255);
    end
end

for i=h/4:h/2
    for j=b/4:b/2
    y(i,j)=rem(y(i-1,j-1)*a+m,255);
    end
end

for i=3/4*h:h
    for j=3/4*b:b
    y(i,j)=rem(y(i-1,j-1)*a+m,255);
    end
end

for i=h/2:3*h/4
    for j=b/2:3*b/4
    y(i,j)=rem(y(i-1,j-1)*a+m,255);
    end
end
