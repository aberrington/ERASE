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

%% Define Parameters

close all
clear all

% Load the simulation parameters for sensitivity maps
sim_params;

%% Generate 2D sensitivity phantom 

% requires code: Matthieu Guerquin-Kern, Biomedical Imaging Group / EPF Lausanne, 20-10-2009
if(~exist('phantom_image','var') && ~exist('sensitivity_map','var'))
    [phantom_image, sensitivity_map] = sartf_define_phantom_with_sensitivity(param, 'SL');
end

% plot the sensitivity maps
sensitivity_maps_cat=[];
for i=1:8
    tmp=[];
    for j = 1:2
        idx=(i-1)*2+j;
        tmp = vertcat(tmp, squeeze(sensitivity_map(:,:,idx)));
    end
    sensitivity_maps_cat = horzcat(sensitivity_maps_cat, tmp);
end

figure('Name','Sensitivity Maps', 'Units', 'normalized', 'Position', [0.2 0.2 0.6 0.5])
imagesc(abs(sensitivity_maps_cat)) % plot sensitivity maps
colormap gray
caxis([0 0.005])


%% Get MRS voxel and choose artifact positions - Define all ROIs here

load('voxel_position.mat'); % load simulated position as in paper

figure('Name', 'Phantom');
fig_phantom         = imshow(phantom_image);
VOX                 = images.roi.Rectangle(gca, 'Position', positionV); % plot simulate voxel

disp('Draw the artifact ROI');
ARTF                = drawpolygon(gca, 'Color', 'r'); % manually draw an artifact region

%% Calculate sensitivities
% 1 MRS ROI
VOX                         = images.roi.Rectangle(gca, 'Position',positionV);
mrs.position                = VOX.Position;
mrs.mask                    = VOX.createMask(fig_phantom);
mrs.coilsensitivities       = sartf_calc_coil_sensitivites_at_region(sensitivity_map, mrs);

% 1 Artifact ROI
artf.position               = ARTF.Position;
artf.positionPoly           = ARTF.Position;
artf.mask                   = ARTF.createMask(fig_phantom);
artf.coilsensitivities      = sartf_calc_coil_sensitivites_at_region(sensitivity_map, artf);

%% Put spectra in the MRS voxel and artifact in the other location(s)
voxels.mrs  = mrs;
voxels.artf = artf;

% simulate an MRS spectrum with parameters, should scale this to be 1
[simulated_spectra(:,1), ppm]   = sartf_generate_MRS_spectrum(param, 0);
% simulate an artefact spectrum with known parameters
[simulated_spectra(:,2)]        = sartf_generate_artefact_spectrum(param, 0);
% calculate signal at each coil and put in a new object; acq
[acq, voxels, PSI]              = sartf_signal_at_coil_with_noise_cov(simulated_spectra, voxels, param);
% phase combine the signal
acq = sartf_combine_acq_signal(acq);

A = acq.signal_at_coil';

%% Choose artf recon region/size
recon.mrs               = mrs; % keep that the same as defined
recon.artf              = artf;

S       = calc_sensitivity_S(mrs, recon.artf);
U       = calc_unfolding_U(S, PSI);
ga      = inv(S'*inv(PSI)*S);
gb      = S'*inv(PSI)*S;
g_factors = sqrt(ga.*gb);
g       = g_factors(1,1); % just save MRS voxel g-factor

SRF(:,:,:)   = calc_SRF(U, sensitivity_map);

% calculate theta based on shifted SRF but true sim artefact region
theta(:,:) = calc_theta(SRF(:,:,:), recon);

% do recon and save spectra
x(:,:)  = U*A;
c       = acq.coil_combined;

sizeR = size(artf.coilsensitivities,1);

%% Plotting

figure('Name','Spatial Response Function', 'Units', 'normalized', 'Position', [0.2 0.2 0.6 0.5])

subplot(1,2,1);
imshow(abs(SRF(:,:,1)));
caxis([0 0.012]);
cb=colorbar;
cb.Label.String = 'a.u.';
axis square
title('ABS');
images.roi.Rectangle(gca, 'Position',positionV);
images.roi.Polygon(gca, 'Position', ARTF.Position, 'Color','red');

subplot(1,2,2);imshow(angle(SRF(:,:,1)));
caxis([-pi pi]);
cb=colorbar;
cb.Label.String = 'rads';
axis square
title('PHA');
images.roi.Rectangle(gca, 'Position',positionV);
images.roi.Polygon(gca, 'Position', ARTF.Position, 'Color','red');

% plot spectra
% Scale recon by relative voxel areas
% i.e. keep MRS fixed but scaled artefact by (400=20x20/sizeR)
sc = 400/sizeR;
figure('Position', [1586         275         314         420], 'Name', 'Reconstruction'); hold on;
tmp=real(mrs_fft(c));
plot(ppm(1:2:end), tmp(1:2:end), 'k');
tmp =-2+real(fftshift(fft(squeeze(x(1,:)'))));
plot(ppm(1:2:end), tmp(1:2:end), 'b');
tmp=-4+real(fftshift(fft(squeeze(x(2,:)'))))/sc; % scaled according to region size
plot(ppm(1:2:end), tmp(1:2:end), 'r');
set(gca, 'XDir', 'Reverse');
xlim([0.5 4.2]);
ylim([-8 4]);
xlabel('ppm');
set(gca, 'YTickLabels', []);
legend('Standard Combination', 'ERASE(V)', 'ERASE(Artifact)', 'Location', 'southeast');





