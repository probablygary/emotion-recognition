% Preprocessing script.
% Consolidates all samples, applies BPF, add to respective array
% All arrays saved as one .mat file (data.mat)

clear;
FP1_A    = [];	% Fp1 alpha
FP1_B    = [];	% Fp1 beta
FP1_BA   = [];	% Fp1 beta/alpha

FP2_A    = [];	% Fp2 alpha
FP2_B    = [];	% Fp2 beta
FP2_BA   = [];	% Fp2 beta/alpha

F3_A     = [];	% F3 alpha
F3_B     = [];	% F3 beta
F3_BA    = [];	% F3 beta/alpha

F4_A     = [];	% F4 alpha
F4_B     = [];	% F4 beta
F4_BA    = [];	% F4 beta/alpha

FP1_Ap   = [];	% Fp1 alpha power
FP1_Bp   = [];	% Fp1 beta power
FP1_BAp  = [];	% Fp1 beta/alpha power
FP1_BpAp = [];	% Fp1 beta power/alpha power

FP2_Ap   = [];	% Fp2 alpha power
FP2_Bp   = [];	% Fp2 beta power
FP2_BAp  = [];	% Fp2 beta/alpha power
FP2_BpAp = [];	% Fp2 beta power/alpha power

F3_Ap    = [];	% F3 alpha power
F3_Bp    = [];	% F3 beta power
F3_BAp   = [];	% F3 beta/alpha power
F3_BpAp  = [];	% F3 beta power/alpha power

F4_Ap    = [];	% F4 alpha power
F4_Bp    = [];	% F4 beta power
F4_BAp   = [];	% F4 beta/alpha power
F4_BpAp  = [];	% F4 beta power/alpha power

valence = [];
arousal = [];


Fs = 128; % Sampling freq.


% Design Bandpass filters
d_a = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2', ...
	7.5,8,12,12.5,40,0.1,40,Fs);
bpfilt_a = design(d_a,'butter');
d_b = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2', ...
	11.5,12,30,30.5,40,0.1,40,Fs);
bpfilt_b = design(d_b,'butter');


% Consolidate all samples
for ii = [1:32]
	if (ii<10)
		load(['s0' num2str(ii) '.mat']);
	else
		load(['s' num2str(ii) '.mat']);
	end

	arousal = [arousal; squeeze(labels(:,2))];
	valence = [valence; squeeze(labels(:,1))];

	fp1      = squeeze(data(:,1,:));
	fp1_a    = filter(bpfilt_a, fp1);
	fp1_b    = filter(bpfilt_b, fp1);
	fp1_ap   = bandpower(fp1', Fs, [8 12]);
	fp1_bp   = bandpower(fp1', Fs, [12 30]);
	fp1_bpap = fp1_bp./fp1_ap;
	
	f3       = squeeze(data(:,3,:));
	f3_a     = filter(bpfilt_a, f3);
	f3_b     = filter(bpfilt_b, f3);
	f3_ap    = bandpower(f3', Fs, [8 12]);
	f3_bp    = bandpower(f3', Fs, [12 30]);
	f3_bpap  = f3_bp./f3_ap;		
	
	fp2      = squeeze(data(:,17,:));
	fp2_a    = filter(bpfilt_a, fp2);
	fp2_b    = filter(bpfilt_b, fp2);
	fp2_ap   = bandpower(fp2', Fs, [8 12]);
	fp2_bp   = bandpower(fp2', Fs, [12 30]);
	fp2_bpap = fp2_bp./fp2_ap;
	
	f4       = squeeze(data(:,20,:));
	f4_a     = filter(bpfilt_a, f4);
	f4_b     = filter(bpfilt_b, f4);
	f4_ap    = bandpower(f4', Fs, [8 12]);
	f4_bp    = bandpower(f4', Fs, [12 30]);
	f4_bpap  = f4_bp./f4_ap;

	FP1_A     = [FP1_A; fp1_a];	% Fp1 alpha
	FP1_B     = [FP1_B; fp1_b];	% Fp1 beta
	FP1_BA    = [FP1_BA; fp1_b./fp1_a];	% Fp1 beta/alpha
	
	FP2_A     = [FP2_A; fp2_a];	% Fp2 alpha
	FP2_B     = [FP2_B; fp2_b];	% Fp2 beta
	FP2_BA    = [FP2_BA; fp2_b./fp2_a];	% Fp2 beta/alpha
	
	F3_A      = [F3_A; f3_a];	% F3 alpha
	F3_B      = [F3_B; f3_b];	% F3 beta
	F3_BA     = [F3_BA; f3_b./f3_a];	% F3 beta/alpha
	
	F4_A      = [F4_A; f4_a];	% F4 alpha
	F4_B      = [F4_B; f4_b];	% F4 beta
	F4_BA     = [F4_BA; f4_b./f4_a];	% F4 beta/alpha
	
	FP1_Ap    = [FP1_Ap; fp1_ap'];	% Fp1 alpha power
	FP1_Bp    = [FP1_Bp; fp1_bp'];	% Fp1 beta power
	% FP1_BAp = [FP1_BAp; ];	% Fp1 beta/alpha power
	FP1_BpAp  = [FP1_BpAp; fp1_bpap'];	% Fp1 beta power/alpha power
	
	FP2_Ap    = [FP2_Ap; fp2_ap'];	% Fp2 alpha power
	FP2_Bp    = [FP2_Bp; fp2_bp'];	% Fp2 beta power
	% FP2_BAp = [];	% Fp2 beta/alpha power
	FP2_BpAp  = [FP2_BpAp; fp2_bpap'];	% Fp2 beta power/alpha power
	
	F3_Ap     = [F3_Ap; f3_ap'];	% F3 alpha power
	F3_Bp     = [F3_Bp; f3_bp'];	% F3 beta power
	% F3_BAp  = [];	% F3 beta/alpha power
	F3_BpAp   = [F3_BpAp; f3_bpap'];	% F3 beta power/alpha power
	
	F4_Ap     = [F4_Ap; f4_ap'];	% F4 alpha power
	F4_Bp     = [F4_Bp; f4_bp'];	% F4 beta power
	% F4_BAp  = [];	% F4 beta/alpha power
	F4_BpAp   = [F4_BpAp; f4_bpap'];	% F4 beta power/alpha power
		
end

% Convert features from float to binary high/low
Arousal  = cellfun(@hilo, num2cell(arousal));
Valence  = cellfun(@hilo, num2cell(valence));

save data.mat FP1_A FP1_B FP1_BA FP2_A FP2_B FP2_BA F3_A F3_B F3_BA F4_A F4_B F4_BA FP1_Ap FP1_Bp FP2_Ap FP2_Bp F3_Ap F3_Bp F4_Ap F4_Bp Arousal Valence
clear
load('data.mat');