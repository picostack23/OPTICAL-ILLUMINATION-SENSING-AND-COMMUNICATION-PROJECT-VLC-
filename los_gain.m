function h = los_gain(P, u)
% Line-of-sight DC gains from the 16 LEDs to a user photodiode facing up at position u (1 x 16).
d = sqrt(sum((P.LED - u).^2, 2)); c = (P.Hc - u(3)) ./ d;
h = ((P.m + 1)*P.Apd ./ (2*pi*d.^2) .* c.^P.m .* c .* (acos(c) < P.FOV)).';
end
