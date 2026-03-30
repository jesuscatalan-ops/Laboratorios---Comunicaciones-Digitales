% 1. Parámetros base
A = 1; fc = 1000; dt = 1/100000; fs = 8000; d = 0.2;
t = 0:dt:0.005; % 5 ms para ver bien los pulsos
mt = A * sin(2*pi*fc*t); 

% Parámetro PCM (Configurable)
N = 3; 
L = 2^N; 

% 2. PAM Instantánea (del ejercicio anterior)
Ts = 1/fs; tau = d * Ts;
pam_inst = zeros(size(t));
for i = 1:length(t)
    t_mod = mod(t(i), Ts);
    if t_mod <= tau
        t_sample = t(i) - t_mod;
        pam_inst(i) = A * sin(2*pi*fc*t_sample);
    end
end

% 3. Proceso de Cuantificación (PCM)
v_min = -A; v_max = A;
delta = (v_max - v_min) / L; % Tamaño del escalón (step size)

% Creamos los niveles de cuantificación (mid-rise)
niveles = v_min + delta/2 : delta : v_max - delta/2;

% Cuantificamos la señal PAM
pam_quant = zeros(size(pam_inst));
for i = 1:length(pam_inst)
    if pam_inst(i) ~= 0 || (mod(t(i), Ts) <= tau)
        % Encontrar el nivel más cercano
        [~, idx] = min(abs(pam_inst(i) - niveles));
        pam_quant(i) = niveles(idx);
    end
end

% 4. Error de Cuantificación
% El error solo existe en los instantes donde hay pulso
error_cuant = zeros(size(pam_inst));
mask = (mod(t, Ts) <= tau); 
error_cuant(mask) = pam_inst(mask) - pam_quant(mask);

% --- GRÁFICAS ---

figure('Name', 'Proceso PCM y Cuantificación', 'NumberTitle', 'off');

% Señal original, PAM instantánea y PAM cuantificada
subplot(2,1,1);
plot(t, mt, '--k', 'LineWidth', 1); hold on;
plot(t, pam_inst, 'b', 'LineWidth', 1.5);
plot(t, pam_quant, 'r', 'LineWidth', 1.5);
title(['PCM: Original vs Muestreada vs Cuantificada (N = ', num2str(N), ' bits)']);
legend('m(t) original', 'PAM Instantánea', 'PAM Cuantificada');
xlabel('Tiempo (s)'); ylabel('Amplitud'); grid on;

% Error de cuantificación
subplot(2,1,2);
stem(t(mask), error_cuant(mask), 'r', 'MarkerSize', 3);
title('Error de Cuantificación (m_{inst} - m_{quant})');
xlabel('Tiempo (s)'); ylabel('Amplitud Error'); grid on;