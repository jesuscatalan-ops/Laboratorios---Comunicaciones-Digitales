
num_bits = 10000;
alphas = [0, 0.25, 0.75, 1];
sps = 16;
span = 6;
snr_db = 25; % Originalmente era 20 pero lo cambieé a 25 para una mejor visibilidad en la gráfica

% Generación de bits aleatorios
bits_tx = randi([0 1], num_bits, 1);

% Codificación de línea NRZ-L
senal_nrzl = 2 * bits_tx - 1;

for i = 1:length(alphas)
    alpha = alphas(i);
    
    % Diseño del filtro de coseno alzado
    filtro_rc = rcosdesign(alpha, span, sps, 'normal');
    
    % Sobremuestreo de la señal NRZ-L
    senal_sobremuestreada = upsample(senal_nrzl, sps);
    
    % Conformación del pulso (filtrado)
    senal_tx = filter(filtro_rc, 1, senal_sobremuestreada);
    
    % Transmisión por el canal con ruido (AWGN)
    senal_rx = awgn(senal_tx, snr_db, 'measured');
    
    % Generación del Diagrama de Ojo
    retardo = round(span * sps / 2); % round() añadido por seguridad
    senal_rx_recortada = senal_rx(retardo+1:end);
    
    % Graficar usando eyediagram
    eyediagram(senal_rx_recortada, 2*sps, 2);
    
    % titulo
    title(sprintf('Diagrama de Ojo - NRZ-L, Canal AWGN, \\alpha = %.2f', alpha));
end