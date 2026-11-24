function e = peb(P, x, y, a_sense)
% Position error bound (m) for the person at (x, y), with the unknown reflectivity as a nuisance parameter.
%   a_sense : 16 x 1 sensing pilot amplitudes (W) of the LEDs
h = 1e-4;
G0 = refl_gain(P, x, y);
dGx = (refl_gain(P, x + h, y) - refl_gain(P, x - h, y)) / (2*h);
dGy = (refl_gain(P, x, y + h) - refl_gain(P, x, y - h)) / (2*h);
J = zeros(3);
for i = 1:16
    s = P.R * a_sense(i);
    grads = [s*P.rho*dGx(i, :).', s*P.rho*dGy(i, :).', s*G0(i, :).'];   % d(mean)/d(x, y, alpha)
    J = J + (grads.' * grads) / P.sig2s;
end
C = inv(J);
e = sqrt(C(1, 1) + C(2, 2));
end
