%wybranie 10 losowych bitów

function [ RandX ] = Losowanie(  )
seed = 93450;  % ziarno
%rng(seed);
step = 8;
RandX = zeros(step);
ilosc = 0;
while ilosc < 6
    x = randi(step);
    y = randi(step);
    if RandX(x,y) ~= 1
        RandX(x,y) = 1;
        ilosc = ilosc + 1;
    end
end
ilosc = 0;
while ilosc < 1
    x = randi(step/2);
    y = randi(step/2);
    if RandX(x,y) == 0
        RandX(x,y) = 2;
        ilosc = ilosc + 1;
    end
end
ilosc = 0;
while ilosc < 1
    x = randi(step/2);
    y = randi(step/2)+4;
    if RandX(x,y) == 0
        RandX(x,y) = 2;
        ilosc = ilosc + 1;
    end
end
ilosc = 0;
while ilosc < 1
    x = randi(step/2)+4;
    y = randi(step/2);
    if RandX(x,y) == 0
        RandX(x,y) = 2;
        ilosc = ilosc + 1;
    end
end
ilosc = 0;
while ilosc < 1
    x = randi(step/2)+4;
    y = randi(step/2)+4;
    if RandX(x,y) == 0
        RandX(x,y) = 2;
        ilosc = ilosc + 1;
    end
end
RandX;
end

