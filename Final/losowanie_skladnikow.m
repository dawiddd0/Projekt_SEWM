function [ X_przes,Y_przes ] = losowanie_skladnikow( seed_permutacji,n,m )
	rng(seed_permutacji);	
	
	X_przes = randperm(n);
	Y_przes = randperm(m);


end