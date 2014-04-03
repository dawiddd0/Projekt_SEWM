function [pic,macierz]=ukryj(im)
im=double(im);
wim=rgb2gray(im);
[LPLP,LPHP,HPLP,HPHP]=dwt2(uint8(wim),'db2');


[m,n]=size(LPLP);
macierz=zeros(m,n);

for i=1:1:m
    for j=1:1:n
        key=rand(1)*255;
    macierz(i,j)=(key*43534+12)/(43534+12);
    end
end
pic=bitxor(uint8(LPLP),uint8(macierz));
imshow((pic));
imwrite(pic,'szum.jpg','jpg');
