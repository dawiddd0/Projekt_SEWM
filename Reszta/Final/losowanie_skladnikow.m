function [ X_przes,Y_przes ] = losowanie_skladnikow( seed,n,m )
	rng(seed);	
    X_przes = randperm(m);
	Y_przes = randperm(m);


end