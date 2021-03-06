%-------------------------------------------------
% afg31k_wfm AFG31000 Waveform Creator for MATLAB
% 
% rev 1.0 - shabaz - Feb 2021
%
% Example usage:
%   Creating an impulse, shortest width possible at 500 Msample/sec rate
%   Waveform length is 20 microseconds ((1/500M) * 10000):  
%     a = zeros(1,10000);
%     a(1) = 1;
%     afg31k_wfm(a, 'impulse.wfm', 500e6, 'nearest');
%     % play out using Advanced Mode, set Timing to 500 Msample/sec
%
%   Creating a 2-second convex chirp between 100Hz and 400 Hz,
%   Amplitude: 1Vpeak (2Vpeak-to-peak) if 50 ohm load.
%     t = -1:0.001:1;          % +/-1 second @ 1kHz sample rate
%     fo = 100;
%     f1 = 400;                % Start at 100Hz, go up to 400Hz
%     ycx = chirp(t,fo,1,f1,'q',[],'convex');
%     soundsc(ycx, 1000);      % Listen to the sound
%     % Up-sample to 10 ksps (just for example) using spline interpol.:
%     afg31k_wfm(ycx, 'convex_100_400_10k.wfm', 1000, 'spline', 10000)
%     % play out using Advanced Mode, set Timing to 10 ksample/sec
%-------------------------------------------------

function[] = afg31k_wfm(v, fname,ratefrom, interpmode, rateto)
    arguments
        v
        fname string
        ratefrom uint32 = 500E6
        interpmode string = 'linear'
        rateto uint32 = 500E6  
    end
    
    fp = fopen(fname, 'w');
    
    vlen=length(v);
        
    if ratefrom~=rateto
        x=0:1/(vlen-1):1;
        sc=(cast(rateto, 'double')/cast(ratefrom, 'double'))*vlen;
        xq=0:1/(sc-1):1;
        
    v = interp1(x,v,xq, interpmode); 
    vlen=length(v);
    
    end
    
    fprintf(fp, 'MAGIC 1000\r\n#');  
    textvlen=sprintf('%d', vlen*5); 
    nvlen=length(textvlen); 
    fprintf(fp, "%d", nvlen);
    fprintf(fp, "%s", textvlen);
    
    fwrite(fp, v(1), 'float');
    
    for i=2:vlen
        fwrite(fp, 0, 'uint8');
        fwrite(fp, v(i), 'float');
    end
    
    fprintf(fp, 'CLOCK 1.00e+08\r\n');
    fclose(fp);
    
end
