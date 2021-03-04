%8-bit QAM modulation
%Converts a long binary string into 8-bit chunks (LSB first) then modulates
%it via QAM

%Uses the following truth table
%{
I/Q  |  C  |  Output
0       0       -0.541 V
0       1       -1.307 V
1       0       +0.541 V
1       1       +1.307 V
Follow Tomasi Digital Communications pg. 520
%}

%Start with a 64-bit string
clear all
%binstring = randi([0 1],1,6); %64-bit (2^6), but will be increased for "big data" numbers
binstring = [0 0 0 0 1 1 0 1 0 0 1 1 1 0 0 1 0 1 1 1 0 1 1 1];
remainder = mod(length(binstring),3);
%pad the vector into 8-bit sections

if remainder ~= 0
    binstring = [ zeros(1,remainder), binstring];
end

%binstring = flip(binstring); %LSB

fs = 100; %way too high, should be 1/3 incoming data rate
wc = 2*pi*fs;

t = 0:1/fs:1;
bytes = length(binstring)/3;

%plot(sin(fs*t))
%separate into Q,I,C, and modulate
QIC = zeros(1,3);
Output_array = zeros(bytes, length(t));
t_chunk = length(t)/bytes;

%now, make a "recipe" for signal and combine it

for k=1:(bytes)
   %Repeat length/3 times since we separate  
   %calculate I and Q portions
   QIC = [binstring(k*3+1), binstring(k*3+2), binstring(k*3+3)];
   %Truth table for level converters

   I_channel = (QIC(2)*2 - 1)*(0.541 + 0.7660 * QIC(3))*sind(t(((k-1)*fs+1):(k*fs)));
   Q_channel = (QIC(1)*2 - 1)*(0.541 + 0.7660 * QIC(3))*cosd(t(((k-1)*fs+1):(k*fs)));
   
  % Output_vector(1,:) = I_channel + Q_channel;
   
end


