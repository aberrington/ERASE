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

function SRF = calc_SRF(U, sensitivity_map)

[Nloc, ~] = size(U);

[Nx, Ny, Nc] = size(sensitivity_map);

SRF = zeros(Nx,Ny,Nloc);

for n = 1:Nloc
    for i = 1:Nc
        SRF(:,:,n) = SRF(:,:,n) + U(n,i)'*sensitivity_map(:,:,i);
    end
end

end

