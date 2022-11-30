% Lab 3.

% Parameter Values
L=1e-3;
C=100e-6;

R2=1;
R1=50e-3;

% Write out our transfer function
Num=[1/(L*C)];
Dem=[1, 1/(R2*C)+R1/L, (R1+R2)/(R2*L*C)];

% Create transfer function
sys = tf(Num,Dem);
% Step input is 12V
opt = stepDataOptions('StepAmplitude', 12);
% Plot
step(sys, opt)