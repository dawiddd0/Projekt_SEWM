function [pic1,macierz]=ukryj(im)
im=rgb2gray(im);
wim=dither(im); %dithering
LPLP=dwt2((wim),'db1'); %dekompozycja falkowa
[m,n]=size(LPLP);
macierz=zeros(m,n);
for i=1:256*256         %generowanie losowej macierz 0 i 1
    j=uint8(rand(1)*255)+1;
    k=uint8(rand(1)*255)+1;    
    macierz(j,k)=1;    
end
pic=xor((LPLP),(macierz)); %XOR macierzy i dolnoprzepustowej sk³adowej dekompozycji falkowej
k=randperm(256); %przygotowanie permutacji
l=randperm(256);
picperm=zeros(256,256);
for i=1:256     %wykonanie permutacji
    for j=1:256
        picperm(k(i),l(j))=pic(i,j);
    end
end

imwrite(picperm,'szum.jpg','jpg'); %zapisanie obrazu zakodowanego

%%%rekonstrukcja
picperm(231,:)=0;   %przykl¹dowe zaklócenia i przek³amania wynikaj¹ce z w³asnoœci kana³u transmisyjnego
picperm(120,:)=0;
picperm(129,:)=0;
picperm(128,:)=0;
picperm(127,:)=0;
picperm(126,:)=0;
picperm(125,:)=0;
picperm(124,:)=0;
picperm(123,:)=0;
picperm(122,:)=0;
picperm(121,:)=0;
pic1=zeros(256,256);
for i=1:256     %u³o¿enie bitów w odpowiedniej kolejnoœci (odwrotna permutacja)
    for j=1:256
        pic1(i,j)=picperm(k(i),l(j));
    end
end

pic1=xor(macierz,pic); % w³aœciwa rekonstrukcja
imshow(pic1);   %obraz wynikowy z rekonustrukcji otrzymany


imwrite(pic1,'rekonstrukcja.jpg','jpg'); %zapisanie obrazu zdekodowanego