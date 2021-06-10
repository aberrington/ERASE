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

function coil_sensitivities = sartf_calc_coil_sensitivites_at_region(sensitivity_map, voxel)

D = length(size(sensitivity_map));

if(D == 3) % 2D data

    for c = 1:size(sensitivity_map,3)
        m   =   (voxel.mask .* sensitivity_map(:,:,c));
        f   =   find(m ~=0);
        coil_sensitivities(:,c) = m(f);
    end

else
    
    for c = 1:size(sensitivity_map,4)
        m   =   (voxel.mask .* sensitivity_map(:,:,:,c));
        f   =   find(m~=0 & ~isnan(m)); 
        coil_sensitivities(:,c) = m(f);
    end
    
end    
end

