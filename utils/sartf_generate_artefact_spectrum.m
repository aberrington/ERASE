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


function [spec] = sartf_generate_artefact_spectrum(param, isplot)

addNoise    = 0;    % add noise to simulation
plotInd      = 0;    % plot the simulated signal

% generate artefact spectra
for y = 1:(param.mrs.nartf)
    spectrum = (generate_water_signal(param.mrs.sw, param.mrs.np, param.mrs.b0, 1, ...
        param.artf.T2(y), param.artf.f_off(y), param.artf.phi, param.artf.echo_pos(y), addNoise, plotInd))';
    spectrum    =   spectrum-mean(spectrum(:)); % demean

    spectrum    =   spectrum/std(spectrum(:)); % unit variance
    spectrum    =   spectrum * param.artf.rel_amp(y);
        
    spec(:,y)   = spectrum;
    param.artf.echo_pos     = param.artf.echo_pos - 0.2;
    param.artf.f_off        = param.artf.f_off -0.5;
end


if(isplot)
    figure
    ppm = ppmscale(param.mrs.sw, zeros(1,param.mrs.np), 42.57*param.mrs.b0, 4.65);
    plot(ppm, real(fftshift(fft(spec(:,1)))));
end


end