fs = 8e3;
wc = 2*pi*fs;
t = 0:(2*pi/wc):1;
QAM_signal = [0.765*sin(w*t - 3*pi/4); 1.848*sin(w*t - 3*pi/4) ; 0.765*sin(w*t - pi/4)]
