%% Task1 
% model the tf function

Xs = [1.9e8 3.1e9];
Rs = [1.7e4 3.5e5 6.1e7 1.9e8 3.1e9];

Hs = tf(Xs,Rs)

opt = stepDataOptions('StepAmplitude', 100); % Note units: this is actually 0.1m!

%add step input & plot
step(Hs, opt);


