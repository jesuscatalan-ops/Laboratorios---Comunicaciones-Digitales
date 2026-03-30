% 1. Parámetros
A = 1;          
fc = 1000;      
dt = 1/100000;  
fs = 8000;  
d = 0.2;        
t = 0:dt:0.1;   % Vector de tiempo (aumentado para mejor resolución FFT)

% 2. Señales m(t), PAM Natural y PAM Instantánea
mt = A * sin(2*pi*fc*t); 

Ts = 1/fs;
tau = d * Ts;

% PAM Natural
tren_pulsos = (mod(t, Ts) <= tau); % Pulso rectangular
pam_natural = mt .* tren_pulsos;

% PAM Instantánea
pam_inst = zeros(size(t));
for i = 1:length(t)
    t_mod = mod(t(i), Ts);
    if t_mod <= tau
        t_sample = t(i) - t_mod; 
        pam_inst(i) = A * sin(2*pi*fc*t_sample);
    end
end

% 3. Cálculo de la Transformada de Fourier (FFT)
L = length(t);
f_sim = 1/dt;              
f = f_sim*(0:(L/2))/L;      

% Magnitudes normalizadas
Y_mt = abs(fft(mt)/L);
Y_nat = abs(fft(pam_natural)/L);
Y_inst = abs(fft(pam_inst)/L);

% Tomar solo la mitad (frecuencias positivas) y duplicar amplitud (excepto DC)
Y_mt = 2*Y_mt(1:L/2+1);
Y_nat = 2*Y_nat(1:L/2+1);
Y_inst = 2*Y_inst(1:L/2+1);

% 4. Gráficas de los Espectros
figure('Name', 'Espectros de Frecuencia PAM', 'NumberTitle', 'off');

subplot(3,1,1);
plot(f, Y_mt, 'k', 'LineWidth', 1.2);
title('Espectro de la Señal Original m(t)'); xlim([0 30000]); grid on;
ylabel('Magnitud');

subplot(3,1,2);
plot(f, Y_nat, 'b', 'LineWidth', 1.2);
title(['Espectro PAM Natural (fs = ', num2str(fs), ' Hz, d = ', num2str(d), ')']);
xlim([0 30000]); grid on;
ylabel('Magnitud');

subplot(3,1,3);
plot(f, Y_inst, 'r', 'LineWidth', 1.2);
title(['Espectro PAM Instantánea (fs = ', num2str(fs), ' Hz, d = ', num2str(d), ')']);
xlim([0 30000]); grid on;
xlabel('Frecuencia (Hz)'); ylabel('Magnitud');