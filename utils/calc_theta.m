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

function theta = calc_theta(SRF, recon)

NLoc = size(SRF,3);
NRecon = size(recon.mrs,2) + size(recon.artf,2);

theta = zeros(NRecon,NLoc);

for m = 1:NLoc
    theta(1,m) = sum(recon.mrs.mask .* SRF(:,:,m), 'all'); % SRF_MRS over MRS
end

for n = 1:(NRecon-1)
    for m = 1:NLoc
        theta(1+n,m) = sum(recon.artf(n).mask .* SRF(:,:,m), 'all'); % SRF_MRS over artf
        theta(1+n,m) = sum(recon.artf(n).mask .* SRF(:,:,m), 'all'); %SRF_artf over artf
    end
end

end

