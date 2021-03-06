# afg31000-tools
Tektronix AFG31000 Open Source Tools
The tools here are useful for working with the Tektronix AFG 31000 Series Arbitrary Waveform Generators.

## Matlab Tools

*afg31k_wfm*

### Example usage:

#### Creating an impulse, shortest width possible at 500 Msample/sec rate
    Waveform length is 20 microseconds ((1/500M) * 10000):  
        a = zeros(1,10000);
        a(1) = 1;
        afg31k_wfm(a, 'impulse.wfm', 500e6, 'nearest');
    play out using Advanced Mode, set Timing to 500 Msample/sec


#### Creating a 2-second convex chirp between 100Hz and 400 Hz,
    Amplitude: 1Vpeak (2Vpeak-to-peak) if 50 ohm load.
        t = -1:0.001:1;          % +/-1 second @ 1kHz sample rate
        fo = 100;
        f1 = 400;                % Start at 100Hz, go up to 400Hz
        ycx = chirp(t,fo,1,f1,'q',[],'convex');
        soundsc(ycx, 1000);      % Listen to the sound
    Up-sample to 10 ksps (just for example) using spline interpol.:
        afg31k_wfm(ycx, 'convex_100_400_10k.wfm', 1000, 'spline', 10000)
    play out using Advanced Mode, set Timing to 10 ksample/sec

