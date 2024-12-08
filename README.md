Purpose of the Code
The code simulates the performance of two digital communication receivers:

Matched Filter Receiver
Correlator Receiver
It evaluates their Bit Error Rate (BER) across different Signal-to-Noise Ratios (SNRs) in a noisy channel.

Steps Explained
1. Parameters Setup
Define the number of bits to transmit (num_bits), the SNR range, and the sampling parameters (m).
Specify waveforms for transmitting binary data:
𝑠1(𝑡)

s1(t): A rectangular waveform of amplitude +1 (representing bit 1).


s2(t): A rectangular waveform of amplitude −1 (representing bit 0).

3. Generate Random Data
Generate random binary bits (bits) using randi.
4. Waveform Representation
Each bit is mapped to its respective waveform:

                                                     Bit 1 →     𝑠1(𝑡)

                                                     Bit 0 →     s2(t)

The waveforms for all bits are concatenated to form the transmitted signal tx_sequence.
5. Calculate Signal Power
The power of the transmitted signal is calculated to normalize the noise level for each SNR.
6. Simulate Noise for SNR Levels
For each SNR value:
Convert SNR (in dB) to linear scale.

Calculate the noise power using the formula:
                                                       𝑃 noise = 𝑃 signal / SNR (linear)

Generate Gaussian noise and add it to the transmitted signal to simulate a noisy received signal (rx_sequence).
6. Receiver Design
For each bit in the received signal:

Matched Filter:
Perform convolution between the received signal and the matched filter impulse response 
                                                        hMF=flip(s1(t)−s2(t)).
The output of the matched filter is used to detect the bit by checking if it is greater than zero.
Correlator:
Multiply the received signal with 
                                                          𝑠1(𝑡)−𝑠2(𝑡)
 and sum the result.
                                        Similarly, compare the output with zero to detect the bit.
7. Calculate BER
              Compare the detected bits with the original transmitted bits.
              Count the number of errors and calculate the Bit Error Rate (BER).


8. Repeat for All SNRs
          Store BER results for both receivers over all SNR values.
9. Plot BER Curves
         Plot the BER against SNR for both receivers on a semi-logarithmic scale.
          The lower the BER, the better the performance.



Key Points
Matched Filter:

Uses a filter designed specifically for the transmitted signal to maximize Signal-to-Noise Ratio (SNR) at the receiver.
It performs well under Additive White Gaussian Noise (AWGN) conditions.
Correlator:

Multiplies the received signal by a known template and integrates the result.
Equivalent to the matched filter in performance but easier to implement.
Comparison:

Both receivers should show similar BER performance.
As SNR increases, BER approaches zero.
Outputs
BER vs. SNR Plot : 
Shows the performance of Matched Filter and Correlator receivers across different SNRs.
