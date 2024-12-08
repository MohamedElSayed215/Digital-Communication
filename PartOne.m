%% Part '1' : Performance of Matched filters and correlators %%
% Parameters
num_bits = 1e6; % Number of bits
snr_range = 0:2:30; % SNR range in dB
m = 10; % Number of samples representing each waveform
sampling_instant = m; % Sampling instant (choose last sample in waveform representation)
amp_s1 = 1; % Amplitude of s1(t)
amp_s2 = -1; % Amplitude of s2(t)

% Generate random binary data
bits = randi([0, 1], 1, num_bits);

% Represent each bit with waveforms
s1_waveform = amp_s1 * ones(1, m); % Rectangular signal for '1'
s2_waveform = amp_s2 * ones(1, m); % Rectangular signal for '0'

% Transmit waveform (concatenation)
tx_sequence = reshape((bits == 1)' * s1_waveform + (bits == 0)' * s2_waveform, 1, []);

% Calculate transmitted signal power
signal_power = mean(tx_sequence.^2); % Average power of the signal

% Initialize BER matrix
ber_mf = zeros(1, length(snr_range));
ber_corr = zeros(1, length(snr_range));

% Loop over SNR values
for idx = 1:length(snr_range)
    snr = snr_range(idx);
    
    % Manual noise addition (replacing awgn)
    snr_linear = 10^(snr / 10); % Convert SNR from dB to linear scale
    noise_power = signal_power / snr_linear; % Calculate noise power
    noise = sqrt(noise_power) * randn(size(tx_sequence)); % Generate noise
    rx_sequence = tx_sequence + noise; % Add noise to the signal
    
    % Matched filter impulse response
    h_mf = flip(s1_waveform - s2_waveform);
    
    % Matched filter and correlator detection
    detected_bits_mf = zeros(1, num_bits);
    detected_bits_corr = zeros(1, num_bits);
    
    for bit_idx = 1:num_bits
        % Extract received signal for the current bit
        start_idx = (bit_idx - 1) * m + 1;
        end_idx = bit_idx * m;
        rx_bit = rx_sequence(start_idx:end_idx);
        
        % Matched filter convolution
        y_mf = conv(rx_bit, h_mf, 'valid'); % Valid ensures single output value per bit
        sampled_mf = y_mf; % Directly use the single result
        
        % Correlator (element-wise multiplication and summation)
        corr_output = sum(rx_bit .* (s1_waveform - s2_waveform));
        
        % Threshold decision
        detected_bits_mf(bit_idx) = (sampled_mf > 0);
        detected_bits_corr(bit_idx) = (corr_output > 0);
    end
    
    % Calculate BER
    ber_mf(idx) = sum(bits ~= detected_bits_mf) / num_bits;
    ber_corr(idx) = sum(bits ~= detected_bits_corr) / num_bits;
end

% Plot BER curve
figure;
semilogy(snr_range, ber_mf, '-o', 'LineWidth', 1.5);
hold on;
semilogy(snr_range, ber_corr, '-x', 'LineWidth', 1.5);
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs SNR for Matched Filter and Correlator Receivers');
legend('Matched Filter', 'Correlator');
grid on;

% Results and comments
disp('Part 1 is DONE ..');
%%