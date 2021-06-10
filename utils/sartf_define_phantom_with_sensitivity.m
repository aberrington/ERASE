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

function [phantom_image, sensitivityMap] = sartf_define_phantom_with_sensitivity(param, Phantom)

% going to use the Shepp-Logan phantom
if(strcmp(Phantom, 'SL'))
    DefineSL;
        phantom_image                   =   RasterizePhantom_AB(SL,param.sense.FOV); % rasterize sensitivity map to fit over phantom acquisition

elseif(strcmp(Phantom, 'SimpleBrain'))
    DefineSimpleBrain;
        phantom_image                   =   RasterizePhantom(Brain,param.sense.FOV); % rasterize sensitivity map to fit over phantom acquisition

else
    error('Selected Wrong Phantom');
end
    % generate a sensitivy map associated with phantom

    sensitivityMap                  =   GenerateSensitivityMap(param.sense.FOV/1e3,param.sense.res/1e3,16);
end
