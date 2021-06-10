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


% Sensitivity Map Parameters
param.sense.FOV     = 256;  % FOV size of image (mm)
param.sense.res     = 1;    % Resolution of image (mm)
param.sense.coils   = 16;   % Number of coils
param.sense.SNRdb   = 20;   % noise in dB relative to MRS to include on each coil

% MRS parameters
param.mrs.voxelsize = 20;
param.mrs.full_simulation = 1; % will use the simulated STEAM spectrum for simulation
param.mrs.npeaks    = 3;        % number of peaks in spectrum
param.mrs.nartf     = 1;        % number of artefact regions
param.mrs.noise = [10 10];
param.artf.rel_amp = 0.5; % relative amplitude of artefact to MRS spectra
param.artf.T2   = 20;
param.artf.f_off = -3.9; % ppm offset of the artefact in the spectrum
param.artf.phi         = 2*pi*randn(1); %phase of final artefact in spectrum
param.artf.echo_pos    = 0.1;
param.recon.nartf   = 1;
param.recon.nartfx  = 256;
param.recon.nartfy  = 256;
param.recon.ntimes  = 1;
param.recon.auto    = 0; % automatically do recon (places voxels equal distance apart)
param.noMRS = 0;

isPlot = 1;

if(param.mrs.full_simulation)
    param.mrs.sw = 5000;
    param.mrs.np = 8192;
    param.mrs.b0 = 7;
end