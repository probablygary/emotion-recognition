%%% Script to view channel information.
%%% Takes one sample (s01.mat),
%%% applies Bandpass filter, then plots  before and after. 

clear;
load('s01.mat');

%   Prep data
Fs             = 128;
fp1            = squeeze(data(1,1,:));
f3             = squeeze(data(1,3,:));
fp2            = squeeze(data(1,17,:));
f4             = squeeze(data(1,20,:));
channels       = [fp1 fp2 f3 f4];
channel_names  = {'fp1' 'fp2' 'f3' 'f4'};
channels_alpha = [fp1 fp2 f3 f4];
channels_beta  = [fp1 fp2 f3 f4];

% Plot Time/Freq before Bandpass filter
figure(1)
for i = [1:4]
    subplot(2,2,i);   
    hold on  
    plot(channels(:,i));
    title(channel_names{i});
    xlabel('Datapoint');
    ylabel('Power');
    xlim([0 length(channels(:,1))])
end

% Apply Bandpass Filter (Alpha)
d = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',7.5,8,12,12.5,40,0.1,40,Fs);
bpfilt = design(d,'butter');
for i =[1:4]
    channels_alpha(:,i) = filter(bpfilt, channels(:,i));     
end

% Time/Freq after BPF (Alpha)
for i = [1:4]
    subplot(2,2,i);     
    plot(channels_alpha(:,i), '.r');
    title(channel_names{i});
    xlabel('Datapoint');
    ylabel('Power');
    xlim([0 length(channels_alpha(:,1))])
end
hold off

% Power Spectral Density before BPF (Alpha)
figure(2);
for i =[1:4]
    subplot(2,2,i); 
    hold on    
    [pxx f] = pwelch(channels(:,i),[],[],[],Fs);
    plot(f, 10*log10(pxx))
    title(channel_names{i});
    xlabel('Frequency(Hz)');
    ylabel('Power(dB)');
end

% Power Spectral Density after BPF (Alpha)
for i =[1:4]
    subplot(2,2,i);     
    [pxx f]= pwelch(channels_alpha(:,i),[],[],[],Fs);
    plot(f, 10*log10(pxx), 'r')
    title(channel_names{i});
    xlabel('Frequency(Hz)');
    ylabel('Power(dB))');
end
hold off

% Apply Bandpass Filter (Beta)
% bpfilt = design(fdesign.bandpass('N,Fc1,Fc2',1000, 8, 12, 128));
d = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',11.5,12,30,30.5,40,0.1,40,Fs);
bpfilt = design(d,'butter');
for i =[1:4]
    channels_beta(:,i) = filter(bpfilt, channels(:,i));     
end

% Power Spectral Density before BPF (Beta)
figure(3);
for i =[1:4]
    subplot(2,2,i); 
    hold on    
    [pxx f] = pwelch(channels(:,i),[],[],[],Fs);
    plot(f, 10*log10(pxx))
    title(channel_names{i});
    xlabel('Frequency(Hz)');
    ylabel('Power(dB)');
end

% Power Spectral Density after BPF (Beta)
for i =[1:4]
    subplot(2,2,i);     
    [pxx f]= pwelch(channels_beta(:,i),[],[],[],Fs);
    plot(f, 10*log10(pxx), 'r')
    title(channel_names{i});
    xlabel('Frequency(Hz)');
    ylabel('Power(dB)');
end
hold off

