function [pic,macierz]=ukryj(im)

wim=rgb2gray(im);
LPLP=dwt2(uint8(wim),'db1');


[m,n]=size(LPLP);
macierz=zeros(m,n);

for i=1:1:m
    for j=1:1:n
        key=rand(1)*255;
    macierz(i,j)=(key*43534+12)/(43534+12);
    end
end
pic=bitxor(uint8(LPLP),uint8(macierz));
%pic1=bitxor(pic,uint8(macierz)); rekonstrukcja
%imshow(pic1); rekonstrukcja
imwrite(pic,'szum.jpg','jpg');

