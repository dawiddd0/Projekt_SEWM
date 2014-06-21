function [ macierzLosowa ] = Losowanie( seed )

rng(seed);	 % klucz autoryzacji
macierzLosowa = zeros(8,8); % pusty blok 8x8
wartosci = randi(8,10,2);
%% 4 dla autentykacji
for i = 1:4
	macierzLosowa(wartosci(i,1),wartosci(i,2)) = 2;
end

%% 6 dla rekonstrukcji
for i = 5:10
	if macierzLosowa(wartosci(i,1),wartosci(i,2)) == 0
		macierzLosowa(wartosci(i,1),wartosci(i,2)) = 1;
	end
end

end

