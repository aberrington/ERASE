%  Copyright [2021] [Adam Berrington]
% 
%    Licensed under the Apache License, Version 2.0 (the "License");
%    you may not use this file except in compliance with the License.
%    You may obtain a copy of the License at
% 
%        http://www.apache.org/licenses/LICENSE-2.0
% 
%    Unless required by applicable law or agreed to in writing, software
%    distributed under the License is distributed on an "AS IS" BASIS,
%    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%    See the License for the specific language governing permissions and
%    limitations under the License.

function S = generate_water_signal(sw, np, B0, A, T2, f_off, phi, echo_pos, addNoise, isPlot)

% function to generate an echo-type water signal FID with variable amplitude and position
% inputs:
% sw        spectral width (Hz)
% np        number of points 
% B0        field strength (T)
% T2        transverse decay rate (ms)
% f_off     off resonant frequency (in ppm)
% phi       phase (rads)
% echo_pos  position of the echo in the FID. 0 = at end, 1 = at beginning
% isPlot    plot the FID
% outputs:
% S         the complex FID signal

ppmOff = 4.65;

dt  =   1/sw;

t   =   (0:(np-1))*dt;
T   =   t(end);

w0  =   -42.57 * 2* pi * B0*(-ppmOff);
w_off =  -42.57 * 2 * pi * B0*(f_off);


T2  =   T2 * 1e-3;

S   =   A * exp(- abs(t - T*echo_pos)/T2) .* exp(sqrt(-1) * ((w0-w_off) * t + phi));


if(addNoise)
   S = awgn(S,addNoise);
end

if(isPlot)
    figure
    plot(t,real(S));
    hold on
    plot(t,imag(S));
    legend('real', 'imag')
    xlabel('time (s)')
    ylabel('amplitude');
end

