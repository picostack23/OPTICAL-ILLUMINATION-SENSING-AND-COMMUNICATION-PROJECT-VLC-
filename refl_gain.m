function G = refl_gain(P, x, y)
% Reflection gain LED i -> person patch -> ceiling photodiode j (16 x 16), with the reflectivity factored out.
t = [x, y, P.ht];
dl = sqrt(sum((P.LED - t).^2, 2)); cl = (P.Hc - P.ht) ./ dl;      % LED -> patch distance and cosine
dp = sqrt(sum((P.PD  - t).^2, 2)); cp = (P.Hc - P.ht) ./ dp;      % patch -> PD distance and cosine
h_in  = (P.m + 1)*P.At ./ (2*pi*dl.^2) .* cl.^P.m .* cl;          % patch faces up
h_out = (1/pi) * P.Apd ./ dp.^2 .* cp .* cp .* (acos(cp) < P.FOV); % PD faces down
G = h_in * h_out.';
end
