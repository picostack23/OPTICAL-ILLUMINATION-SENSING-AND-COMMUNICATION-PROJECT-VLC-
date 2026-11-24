# Topic 6 starter code: device-free sensing and multiuser VLC

This folder is your starting point, not your result. It reproduces the sensing–communication trade-off in its simplest form so you can check your understanding. Extending it into the real model is your work, following the eight-week plan in your brief.

## How to run

1. Open MATLAB (R2021a or later) or GNU Octave 8 or later. No toolboxes are needed.
2. Change into this folder and type `main_feasibility`.
3. Check that your printout matches this one.

```
noise PSD 2.04e-23 A^2/Hz; AC budget 1.0 W per LED; person at 1.7 m, reflectivity unknown
no sensing: downlink sum rate 576.1 Mb/s
sensing share 0.01: median PEB   103.79 mm, worst PEB   323.21 mm | downlink sum rate  575.0 Mb/s
sensing share 0.05: median PEB    20.76 mm, worst PEB    64.64 mm | downlink sum rate  570.2 Mb/s
sensing share 0.20: median PEB     5.19 mm, worst PEB    16.16 mm | downlink sum rate  550.4 Mb/s
sensing share 0.50: median PEB     2.08 mm, worst PEB     6.46 mm | downlink sum rate  496.2 Mb/s
sensing share 0.80: median PEB     1.30 mm, worst PEB     4.04 mm | downlink sum rate  390.5 Mb/s
sensing share 0.95: median PEB     1.09 mm, worst PEB     3.40 mm | downlink sum rate  231.4 Mb/s
```

## Files

| File | What it does |
| --- | --- |
| `main_feasibility.m` | Sets every parameter in the struct `P`, sweeps the sensing share, prints the table above and saves `T6_tradeoff.png` |
| `los_gain.m` | Line-of-sight gain from each LED to a user photodiode (Lambertian model) |
| `refl_gain.m` | Two-hop gain from each LED to the person and back to each ceiling photodiode |
| `peb.m` | Position error bound for the person, with the unknown reflectivity as a nuisance parameter (finite-difference derivatives) |
| `sum_rate.m` | Two-user downlink rate with zero-forcing across the LEDs under each LED's amplitude limit |

## What the model leaves out on purpose

The person is a flat reflecting patch, the static background is known, every LED uses the same sensing share, and there is no illumination constraint yet. The derivatives in `peb.m` are numerical. Replacing them with your own analytic derivatives (week 4), adding illumination limits (weeks 5–6) and letting each LED choose its own share (week 7) are your tasks.

## Rules for this code

- Keep the folder in Git and commit each working change, starting with an untouched copy.
- Change parameters only in `P` at the top of the main script, in SI units with the unit in a comment.
- You must be able to explain every line. Expect to be asked about any of them in a meeting.
