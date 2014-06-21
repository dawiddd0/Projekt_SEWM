function [ RandX,przesX,przesY,qim ] = generateRandX(  )

RandX =[     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     1
     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0
     0     0     0     1     0     0     0     0
     0     2     0     0     0     0     0     1
     0     1     0     2     1     0     0     2
     0     0     0     0     1     2     0     0];
przesX = 64;
przesY = 128;
qim = 5;
end

