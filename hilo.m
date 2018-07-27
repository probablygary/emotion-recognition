% Function to support preprocess script
% Takes in real number, outputs high or low
% for valence and arousal feature transformation

function y = hilo(x)
   if x <= 4.5
		y = cellstr('L');
	else
		y = cellstr('H');
	end
end
