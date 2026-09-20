%% Kp calculation from sawtooth voltage
load("tensao_pot.mat")
t = tensao_pot.time(:);
v = tensao_pot.signals.values(:);

% Detect sharp downward resets
dv = diff(v);
idx = find(dv < -1);

% Group consecutive detections belonging to the same reset
groups = [1; find(diff(idx) > 1) + 1];
ends   = [groups(2:end)-1; length(idx)];

% Find one reset point per group
reset_idx = zeros(length(groups),1);

for k = 1:length(groups)
    g = idx(groups(k):ends(k));
    [~,j] = min(dv(g));
    reset_idx(k) = g(j) + 1;
end

% Period
T = diff(t(reset_idx));
Tmean = mean(T);

% Least-squares slope for each ramp
slopes = zeros(length(reset_idx)-1,1);

for k = 1:length(reset_idx)-1
    i1 = reset_idx(k) + 2;
    i2 = reset_idx(k+1) - 2;

    p = polyfit(t(i1:i2),v(i1:i2),1);
    slopes(k) = p(1);
end

% Mean slope
mean_slope = mean(slopes);

% Angular velocity [deg/s]
w = 360/Tmean;

% Kp [deg/V]
Kp = w/mean_slope;

% Output Kp
fprintf('Kp = %.6f deg/V\n',Kp);