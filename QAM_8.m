%8-bit QAM modulation
%Converts a long binary string into 8-bit chunks (MSB first) then modulates
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
%{
%binstring = randi([0 1],1,6); %64-bit (2^6), but will be increased for "big data" numbers
binstring = [0 0 0 0 1 1 0 1 0 0 1 1 1 0 0 1 0 1 1 1 0 1 1 1];
remainder = mod(length(binstring),3);
%pad the vector into 8-bit sections
%}

fid = fopen('tile081.txt','rt');
C = textscan(fid,'%f %f %f', 'Delimiter',' ');
fclose(fid);

A = cell2mat(C);
B = de2bi(round(A(1:96,:)),21);
bitstream = reshape(B.',1,[]);
binstring = bitstream;
%D = zeros(length(B(:,1)),length(B(1,:)));


%binstring = flip(binstring); %LSB

fs = 100; %way too high, should be 1/3 incoming data rate
wc = 2*pi*fs;

bytes = length(binstring)/3;

t = 0:(1/fs):(2*pi);
%separate into Q,I,C, and modulate
QIC = zeros(1,3);
Output_array = zeros(bytes, length(t));
%Output_vector = zeros(1,length(t));
constellation_array = zeros(bytes,2);

for k=1:bytes
   %Repeat length/3 times since we separate  
   %calculate I and Q portions
   QIC = [binstring(k*3-2), binstring(k*3-1), binstring(k*3)];
   %Truth table for level converters

   I_channel = (QIC(2)*2 - 1)*(0.541 + 0.7660 * QIC(3))*sin(t);
   Q_channel = (QIC(1)*2 - 1)*(0.541 + 0.7660 * QIC(3))*cos(t);
   constellation_array(k,:) = [I_channel(round(pi/3*fs)) Q_channel(round(pi/3*fs))];
   
   Output_array(k,:) = I_channel + Q_channel;
   
end


t_signal = 0:2*pi/wc:(2*pi*bytes);
Signal = reshape(Output_array.',1,[]);
Signal = Signal(1:length(t_signal));
%plot(t_signal,Signal);
%plot(Output_vector);

%% Take 2



for k=1:bytes
   %Repeat length/3 times since we separate  
   %calculate I and Q portions
    QIC = [binstring(k*3-2), binstring(k*3-1), binstring(k*3)];
   %Truth table for level converters

    if QIC(1) == 0
       
        if QIC(2) == 0
            if QIC(3) == 0
                byte_signal = 0.765*sin(t-3*pi/4);
            else
                byte_signal = 1.848*sin(t-3*pi/4);
            end
        else
            if QIC(3) == 0
                byte_signal = 0.765*sin(t-pi/4);
            else
                byte_signal = 1.848*sin(t-pi/4);
            end
        end
        
    else
       if QIC(2) == 0
            if QIC(3) == 0
                byte_signal = 0.765*sin(t+3*pi/4);
            else
                byte_signal = 1.848*sin(t+3*pi/4);
            end
        else
            if QIC(3) == 0
                byte_signal = 0.765*sin(t+pi/4);
            else
                byte_signal = 1.848*sin(t+pi/4);
            end
        end
    end     
   
   Output_array(k,:) = byte_signal;
   
end


t_signal_2 = 0:2*pi/wc:(2*pi*bytes);
Signal_2 = reshape(Output_array.',1,[]);
Signal_2 = Signal_2(1:length(t_signal));


tiledlayout(2,1)
nexttile

plot(t_signal, Signal,"r");
title("8QAM Signal")
ylabel("Amplitude")
xlabel("Samples")
nexttile

scatter(constellation_array(:,1), constellation_array(:,2), 'filled', 'o');
hold on
xline(0)
yline(0)
hold off
title("Constellation Plot")
xlabel("In-Phase")
ylabel("Quadrature")

total_time = length(t_signal) / fs
