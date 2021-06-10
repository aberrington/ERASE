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

function S = calc_sensitivity_S(mrs, artf)

% defined as integral (or sum of sensitivities over a region)
S(:,1) = sum(mrs.coilsensitivities,1)';
if(size(artf,2)>1)
    S(:,2) = sum(artf(1).coilsensitivities,1)';
    S(:,3) = sum(artf(2).coilsensitivities,1)';
else
    S(:,2) = sum(artf.coilsensitivities,1)';
end

end
