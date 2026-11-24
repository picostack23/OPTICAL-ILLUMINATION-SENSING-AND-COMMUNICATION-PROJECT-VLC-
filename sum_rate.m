function r = sum_rate(P, Hu, a_comm)
% Downlink sum rate (Mb/s) with zero-forcing across LEDs and a per-LED amplitude limit a_comm (16 x 1).
% Uses the amplitude-constrained IM/DD lower bound 0.5*log2(1 + 2/(pi*e)*SNR) per real dimension,
% which follows from the entropy power inequality with a uniform input on [-A, A] (SNR = A^2/sigma^2).
sig2 = (2*P.qe*P.R*1e-4 + 4*P.kB*P.Tk/P.RL) * P.B;
W = pinv(Hu);                                         % 16 x 2
scale = min(a_comm ./ (sum(abs(W), 2) + 1e-30));      % no LED may exceed its amplitude budget
sinr = (P.R*scale)^2 / sig2;
r = 2 * 0.5*log2(1 + 2/(pi*exp(1))*sinr) * 2*P.B / 1e6;   % 2 users x bits per real sample x 2B samples/s
end
