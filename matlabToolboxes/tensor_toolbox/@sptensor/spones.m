function X = spones(X)
%SPONES Replace nonzero sparse tensor elements with ones.
%
%   Y = SPONES(X) generates a tensor with the same sparsity structure as X,
%   but with ones in the nonzero positions.
%
%   See also SPTENSOR.
%
%MATLAB Tensor Toolbox.
%Copyright 2019, Sandia Corporation.

% This is the MATLAB Tensor Toolbox by T. Kolda, B. Bader, and others.
% http://www.sandia.gov/~tgkolda/TensorToolbox.
% Copyright (2015) Sandia Corporation. Under the terms of Contract
% DE-AC04-94AL85000, there is a non-exclusive license for use of this
% work by or on behalf of the U.S. Government. Export of this data may
% require a license from the United States Government.
% The full license terms can be found in the file LICENSE.txt

X.vals = ones(size(X.vals));