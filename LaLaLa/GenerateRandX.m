function [ RandX ] = GenerateRandX( seed )

rng(seed);	 
RandX = zeros(8,8);
vals = randi(8,10,2);
for i = 1:4
	RandX(vals(i,1),vals(i,2)) = 2;
end
for i = 5:10
	if RandX(vals(i,1),vals(i,2)) == 0
		RandX(vals(i,1),vals(i,2)) = 1;
	end
end

end