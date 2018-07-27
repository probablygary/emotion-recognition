% Classifies using Naive Bayes and Fisher/Linear Discriminant

% Load data
clear
load('data.mat');

perf_f = []; % Fisher Discr. results
perf_nb = []; % Naive Bayes' results
vars = {[FP1_B FP2_B] }; % List of arrays of channels for input
labels = {'FP1, FP2 Beta'  'FP1, FP2 Alpha'}; % Labels for channels 
n_pca = [1:25]; % No. of PCA components to test


%  Perform analysis
for j = 1:length(vars)
	for k = 1:10
		% Divide train/test set, then predictor and target features 
		% Perform PCA
		[trainInd, valInd, testInd] = dividerand(size(Valence,1),0.8, 0, 0.2);
		train_pred = vars{j}(trainInd, :);
		train_targ = Valence(trainInd);
		[coeff, score, latent] = pca(train_pred);
		test_pred = vars{j}(testInd, :) * coeff;
		test_targ = Valence(testInd);

		% Train and test both models
		for l = 1:length(n_pca)
			i = n_pca(l);
			mdl1 = fitcdiscr(score(:,1:i), train_targ);
			Y1 = predict(mdl1, test_pred(:,1:i));
			cp1 = classperf(test_targ, Y1);
			mdl2 = fitcnb(score(:,1:i), train_targ);
			Y2 = predict(mdl2, test_pred(:,1:i));
			cp2 = classperf(test_targ, Y2);
			perf_f(k,l) = [cp1.CorrectRate];
			perf_nb(k,l) = [cp2.CorrectRate];
		end
	end

	% Plot graphs of min,max,avg accuracy vs. no. of Prin. comp.
	max_f = max(perf_f);
	max_nb = max(perf_nb);
	figure();
	hold on;
	plot(n_pca, mean(perf_f)','r');
	plot(n_pca, max(perf_f)', 'g');
	plot(n_pca, min(perf_f)', 'b');
	axis([1 25 0 1])
	xlabel('Principal Components');
	ylabel('Performance');
	title(strcat(labels{j},' - Linear Discriminant'));
	legend('Mean', 'Max', 'Min', 'Location', 'Northwest');
	indmax = find(max(max_f)==max_f);
	xmax = n_pca(indmax(1));
	ymax = max_f(indmax(1));
	strmax = ['Maximum = ', num2str(ymax)];
	text(xmax,ymax,strmax,'HorizontalAlignment', 'left');
	hold off

	figure();
	hold on;
	plot(n_pca, mean(perf_nb)','r');
	plot(n_pca, max(perf_nb)', 'g');
	plot(n_pca, min(perf_nb)', 'b');
	axis([1 25 0 1])
	xlabel('Principal Components');
	ylabel('Performance');
	title(strcat(labels{j},' - Naive Bayes'));
	legend('Mean', 'Max', 'Min', 'Location', 'Northwest')
	indmax = find(max(max_nb) == max_nb);
	xmax = n_pca(indmax(1));
	ymax = max_nb(indmax(1));
	strmax = ['Maximum = ', num2str(ymax)];
	text(xmax,ymax,strmax,'HorizontalAlignment', 'left');	hold off
end