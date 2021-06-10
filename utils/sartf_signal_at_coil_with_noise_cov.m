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


function [acq, voxels, PSI] = sartf_signal_at_coil_with_noise_cov(simulated_spectra, voxels, param)
    
    C = param.sense.coils;
    
    acq.signal_at_coil = zeros(param.mrs.np, param.sense.coils);
    acq.signal_at_coil_clean = acq.signal_at_coil;

    spec_MRS = simulated_spectra(:,1);
    
    for c = 1:C
        voxels.mrs.signal_at_coil(:,c)  = sum(squeeze(voxels.mrs.coilsensitivities(:,c)) * spec_MRS(:,1)',1) / size(voxels.mrs.coilsensitivities(:,c),1); %normalize by the area of region
        acq.signal_at_coil(:,c) = acq.signal_at_coil(:,c) + voxels.mrs.signal_at_coil(:,c); % add the MRS voxel signal
       
        for n = 1:param.mrs.nartf 
            voxels.artf(n).signal_at_coil(:,c) = sum(squeeze(voxels.artf(n).coilsensitivities(:,c)) * simulated_spectra(:,1+n)',1) / size(voxels.artf(n).coilsensitivities(:,c),1);
            acq.signal_at_coil(:,c) = acq.signal_at_coil(:,c) + voxels.artf(n).signal_at_coil(:,c); % add the artefact signals
        end
        acq.signal_at_coil_clean(:,c) = acq.signal_at_coil(:,c);
        acq.signal_at_coil(:,c) = awgn(acq.signal_at_coil_clean(:,c), param.sense.SNRdb, 'measured');
        acq.noise(:,c) = acq.signal_at_coil_clean(:,c)-acq.signal_at_coil(:,c);
    end
    
    PSI = cov(acq.noise);

end