close all
clear all
clc

% Load in the data
load('SEA_speed.mat')

% Motor Constants
R = 2.07;
Kt = 0.0525;
Kb = 0.0528;
Ja = 8*10^-6;
Da = 0;

% SEA Constants
N = (156/1);
Kl = 138;
Jl = 0.6;
Dl =1;

% Set up coefficients
N1 = Kl/N;
D4 = R*Ja*Jl/Kt;
D3 = R*Ja*Dl/Kt + Kb*Jl;
D2 = R*Ja*Kl/Kt + Kb*Dl + R*Kl*Jl/(Kt*N^2);
D1 = Kb*Kl + R*Kl*Dl/(Kt*N^2);
num_orig = [N1];
den_orig = [D4 D3 D2 D1];

fprintf('Original Transfer Function')
% Set up the TF function
sys_orig = tf(num_orig,den_orig)

% Plot the response for the system and the raw data
SEA_TF_orig = step(sys_orig,t);
plot(t,SEA_speed,t,SEA_TF_orig,'r')

% Measure the performance of the estimate
perf_orig = sse(SEA_speed-SEA_TF_orig);

% Using for loops (just takes a bit of time)
oldCost = 1e100; % Start this at an arbitrary large value
for Kl = 70:5:260
    for Jl = 0.5:0.05:1.0
        for Dl = 0.5:0.05:2.0
            % Recalculate coefficients
            N1 = Kl/N;
            D4 = R*Ja*Jl/Kt;
            D3 = R*Ja*Dl/Kt + Kb*Jl;
            D2 = R*Ja*Kl/Kt + Kb*Dl + R*Kl*Jl/(Kt*N^2);
            D1 = Kb*Kl + R*Kl*Dl/(Kt*N^2);
            
            % Set up tf function
            numTest = [N1];
            denTest = [D4 D3 D2 D1];
            sys = tf(numTest,denTest);

            % Response to a step input
            SEA_TF = step(sys,t);

            % Error
            cost = sse(SEA_speed-SEA_TF);

            if cost<oldCost
                num_best = numTest;
                den_best = denTest;  
                oldCost = cost;
                Kl_best = Kl;
                Jl_best = Jl;
                Dl_best = Dl;
            end
        end
    end
end   

% Replot the updated transfer function
fprintf('Updated Transfer Function')
sys_updated = tf(num_best,den_best)
figure
SEA_TF_updated = step(sys_updated,t);
plot(t,SEA_speed,t,SEA_TF_updated,'r')

% Measure the new performance of the error
perf_updated = sse(SEA_speed-SEA_TF_updated);

Method = {'Original';'Nested Loops'};
Kl_results = [Kl;Kl_best];
Jl_results = [Jl; Jl_best];
Dl_results = [Dl; Dl_best];
perf_results = [perf_orig; perf_updated];

T = table(Kl_results,Jl_results,Dl_results,perf_results,...
    'RowNames',Method)
