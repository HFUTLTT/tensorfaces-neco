function n = ndims(t)
%NDIMS Number of dimensions for a symtensor.
%
%   NDIMS(S) returns the number of dimensions of a symtensor S.
%
%   Examples
%   X = symtensor(rand([4,4,4])); ndims(X) %<-- Returns 3
%
%   See also SYMTENSOR, TENSOR/NDIMS
%
%MATLAB Tensor Toolbox.
%Copyright 2015, Sandia Corporation.

% This is the MATLAB Tensor Toolbox by T. Kolda, B. Bader, and others.
% http://www.sandia.gov/~tgkolda/TensorToolbox.
% Copyright (2015) Sandia Corporation. Under the terms of Contract
% DE-AC04-94AL85000, there is a non-exclusive license for use of this
% work by or on behalf of the U.S. Government. Export of this data may
% require a license from the United States Government.
% The full license terms can be found in the file LICENSE.txt


n = t.m;
