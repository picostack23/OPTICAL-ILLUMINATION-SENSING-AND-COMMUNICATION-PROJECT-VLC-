% Topic 6 feasibility: device-free sensing of a person with ceiling LEDs and ceiling photodiodes, sharing each
% LED's modulation (AC) budget between sensing pilots and downlink data, with fixed illumination (DC) levels.
% Room 5 x 5 x 3 m, 4 x 4 LEDs (Lambertian order 1), one photodiode beside each LED facing down,
% person = horizontal diffuse patch with unknown reflectivity at 1.7 m, two users at desk height.
% Prints the position error bound (PEB) and the downlink sum rate versus the sensing share (Topic 6 table).
clear; close all;

%% Parameters
P.qe = 1.602e-19; P.kB = 1.381e-23;
P.Hc = 3.0; P.m = 1;                          % ceiling height (m), Lambertian order
g = [0.625 1.875 3.125 4.375];
[GX, GY] = meshgrid(g, g);
P.LED = [GX(:), GY(:), P.Hc*ones(16, 1)];
P.PD  = P.LED + [0.05 0 0];                   % ceiling photodiodes beside the LEDs
P.Apd = 1e-4; P.R = 0.5; P.FOV = 70*pi/180;   % PD area (m^2), responsivity (A/W), field of view
P.ht = 1.7; P.At = 0.1; P.rho = 0.3;          % person height (m), reflecting area (m^2), reflectivity
P.Pdc = 2.0; P.Amax = 0.5*P.Pdc;              % DC optical power per LED (W) and AC budget (W)
P.Tobs = 10e-3; P.B = 20e6; P.RL = 1e3; P.Tk = 300;
P.Pbg = 2.4e-5;                               % background optical power at a ceiling PD (W)
P.Sn = 2*P.qe*P.R*P.Pbg + 4*P.kB*P.Tk/P.RL;   % noise current PSD (A^2/Hz)
P.sig2s = P.Sn / P.Tobs;                      % noise variance after integrating a pilot
P.users = [1.2 3.8 0.85; 3.9 1.1 0.85];
P.makeFigures = true;

Hu = [los_gain(P, P.users(1, :)); los_gain(P, P.users(2, :))];   % 2 x 16
etas = [0.01 0.05 0.2 0.5 0.8 0.95];
[xs, ys] = meshgrid(linspace(0.5, 4.5, 9), linspace(0.5, 4.5, 9));
fprintf('noise PSD %.2e A^2/Hz; AC budget %.1f W per LED; person at %.1f m, reflectivity unknown\n', P.Sn, P.Amax, P.ht);
fprintf('no sensing: downlink sum rate %.1f Mb/s\n', sum_rate(P, Hu, P.Amax*ones(16, 1)));
res = zeros(numel(etas), 3);
for i = 1:numel(etas)
    as = etas(i)*P.Amax*ones(16, 1); ac = (1 - etas(i))*P.Amax*ones(16, 1);
    pe = zeros(numel(xs), 1);
    for j = 1:numel(xs), pe(j) = peb(P, xs(j), ys(j), as); end
    res(i, :) = [median(pe), max(pe), sum_rate(P, Hu, ac)];
    fprintf('sensing share %4.2f: median PEB %8.2f mm, worst PEB %8.2f mm | downlink sum rate %6.1f Mb/s\n', ...
            etas(i), 1e3*res(i, 1), 1e3*res(i, 2), res(i, 3));
end

if P.makeFigures
    try
        figure; semilogx(1e3*res(:, 1), res(:, 3), '-o'); grid on;
        xlabel('median position error bound (mm)'); ylabel('downlink sum rate (Mb/s)');
        title('Sensing-communication trade-off of a shared LED modulation budget');
        print('-dpng', 'T6_tradeoff.png'); fprintf('Saved T6_tradeoff.png\n');
    catch err
        fprintf('Figure skipped: %s\n', err.message);
    end
end
