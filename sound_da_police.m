function sound_da_police()
% Written by Jerome Wynne
% sounds da police

%% FUNCTION
[y,Fs] = wavread('sound_of_da_police.wav');
sound(y, Fs);

end