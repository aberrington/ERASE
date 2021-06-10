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

function [spec, ppm] = sartf_generate_MRS_spectrum(param, isplot)

load('STEAM_ideal_14ms_sim_spec.mat');
out_mrs=broaden_filter_FID_out(out, 6);

spectrum = out_mrs.fids_tot';

spectrum=spectrum-mean(spectrum(:)); % demean
spectrum=spectrum/std(spectrum(:)); % unit variance
spec(:,1) = conj(spectrum);
ppm = ppmscale(param.mrs.sw, zeros(1,param.mrs.np), 42.57*param.mrs.b0, 4.65);

if(isplot)
    figure
    plot(ppm, real(fftshift(fft(spec(:,1)))));
end

end