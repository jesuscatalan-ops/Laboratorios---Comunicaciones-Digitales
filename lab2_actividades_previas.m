% Grafica de la respuesta al impulso y la respuesta en frecuencia de un filtro coseno alzado usando las ecuaciones 10 y 14.

% Parámetros iniciales
Ts = 1; % Periodo de muestreo (normalizado)
f0 = 1 / (2 * Ts); % Ancho de banda de 6 dB (Nyquist)
alphas = [0, 0.25, 0.75, 1]; % Factores de roll-off solicitados
t = 0:0.01:5*Ts; % Vector de tiempo (t >= 0 según indicaciones)

figure('Name', 'Actividades Previas - Filtro Coseno Alzado', 'Position', [100, 100, 800, 600]);

%% 1. Gráfica de Respuesta al Impulso he(t) (Ecuación 14)
subplot(2, 1, 1);
hold on;
for a = alphas
    f_delta = a * f0;
    
    % Primer término: 2 * f0 * sinc(2 * f0 * t)
    % Nota: sinc en Matlab es sin(pi*x)/(pi*x), por lo que ajustamos el argumento
    term1 = 2 * f0 * sinc(2 * f0 * t);
    
    % Segundo término: cos(2 * pi * f_delta * t) / (1 - (4 * f_delta * t)^2)
    denominador = 1 - (4 * f_delta * t).^2;
    term2 = cos(2 * pi * f_delta * t) ./ denominador;
    
    % Manejo de la singularidad (división por cero) usando L'Hôpital
    idx_zero = find(abs(denominador) < 1e-6);
    if ~isempty(idx_zero)
        term2(idx_zero) = pi / 4; 
    end
    
    he = term1 .* term2;
    plot(t, he, 'LineWidth', 1.5, 'DisplayName', ['\alpha = ', num2str(a)]);
end
title('Respuesta al Impulso h_e(t) - Ecuación 14');
xlabel('Tiempo (t)');
ylabel('Amplitud');
xlim([0 max(t)]);
grid on;
legend;

%% 2. Gráfica de Respuesta en Frecuencia He(f) (Ecuación 10)
subplot(2, 1, 2);
hold on;

% Para cumplir con la restricción de -2B <= f <= 2B, calcularemos 
% el B máximo (cuando alpha = 1) para tener un eje X uniforme.
B_max = f0 * (1 + 1); 
f = linspace(-2*B_max, 2*B_max, 1000);

for a = alphas
    f_delta = a * f0;
    B = f0 + f_delta; % Ancho de banda absoluto
    f1 = f0 - f_delta; % Límite inferior de la transición
    
    He = zeros(size(f)); % Inicializar vector de respuesta
    
    for i = 1:length(f)
        abs_f = abs(f(i));
        if abs_f <= f1
            He(i) = 1;
        elseif abs_f > f1 && abs_f <= B
            % Tramo con decaimiento de coseno
            He(i) = 0.5 * (1 + cos(pi * (abs_f - f1) / (2 * f_delta)));
        else
            He(i) = 0;
        end
    end
    
    plot(f, He, 'LineWidth', 1.5, 'DisplayName', ['\alpha = ', num2str(a)]);
end
title('Respuesta en Frecuencia H_e(f) - Ecuación 10');
xlabel('Frecuencia (f)');
ylabel('Magnitud |H_e(f)|');
xlim([-2*B_max 2*B_max]);
grid on;
legend;

