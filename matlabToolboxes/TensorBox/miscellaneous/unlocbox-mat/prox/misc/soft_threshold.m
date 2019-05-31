function [sz] = soft_threshold(z,T)
%SOFT_THRESHOLD soft thresholding
%   Usage:  soft_threshold(z,T)
%
%   Input parameters:
%         z     : Input signal.
%         T     : Threshold.
%   Output parameters:
%         sz    : Soft thresholded signal.
%
%
%   Url: http://unlocbox.sourceforge.net/doc//prox/misc/soft_threshold.php

% Copyright (C) 2012-2013 Nathanael Perraudin.
% This file is part of LTFAT version 1.1.97
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% Nathanael Perraudin
% Date: 14 May 2013

    % handle the size
    size_z=size(z);
    z=z(:);
    T=T(:);

    % This soft thresholding function only support real signal
    % sz= sign(z).*max(abs(z)-T, 0);

    % This soft thresholding function support complex number
    sz = max(abs(z)-T,0)./(max(abs(z)-T,0)+T).*z;
    
    % Handle the size
    sz=reshape(sz,size_z);
end
