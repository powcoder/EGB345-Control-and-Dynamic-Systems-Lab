%% Task 1
% considering two sinudoidal waveforms f = 0.1,0.5

% A: produce vectors y1 and y2 that represent 100 time instants

k=1:1:100;

y1 = sin(0.1*k);
y2 = sin(0.5*k);

plot(k,y1,k,y2,'r')

% B: find k such that y<0

a = find(y1<0);  % 32
b = find(y2<0);  % 7

% store where they first go below zero -- you can also do this with min()
s1 = a(1);
s2 = b(1);

% shift each vector so the new starting point is s1 and s2.
% pad (concatenate) the vector with zeros so the overall length stays the same
y1 = [y1(s1:end) zeros(1,s1-1)];
y2 = [y2(s2:end) zeros(1,s2-1)];

figure
plot(k,y1,k,y2,'r')

%% Task 2

% A: load the sine data
yn = csvread('sinedata.csv');
figure
plot(yn)

% B: RMS comparison: smaller number is better.
% We only consider 1st 50 data points here (see lab instructions sheet)
error1 = rms(y1(1:50)-yn(1:50));
error2 = rms(y2(1:50)-yn(1:50));

%% Task 3

% load csv file, noting row/col starts from 0
servo = csvread('openloop_1.csv',2,0);

% smooth out and plot
z1 = smoothdata(servo(:,2));
z2 = smoothdata(servo(:,3));

t = servo(:,1);
dataRaw = [servo(:,2) servo(:,3)];
dataSmooth = [z1 z2];

figure
plot(t,dataSmooth(:,1),t,dataRaw(:,1),'r',t,dataSmooth(:,2),'k',t,dataRaw(:,2),'m')

% store and save the data
data = struct('raw',dataRaw,'smooth',dataSmooth);
save('smootheddata','data')


