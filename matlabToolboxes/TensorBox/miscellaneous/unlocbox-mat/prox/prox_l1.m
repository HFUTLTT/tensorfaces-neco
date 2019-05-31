function [sol,infos] = prox_l1(x, gamma, param)
%PROX_L1 Proximal operator with L1 norm
%   Usage:  sol=prox_l1(x, gamma)
%           sol=prox_l1(x, gamma, param)
%           [sol, infos]=prox_l1(x, gamma, param)
%
%   Input parameters:
%         x     : Input signal.
%         gamma : Regularization parameter.
%         param : Structure of optional parameters.
%   Output parameters:
%         sol   : Solution.
%         infos : Structure summarizing informations at convergence
%
%   PROX_L1(x, gamma, param) solves:
%
%      sol = argmin_{z} 0.5*||x - z||_2^2 + gamma * ||A z||_1
%
%
%   param is a Matlab structure containing the following fields:
%
%    param.A : Forward operator (default: Id).
%
%    param.At : Adjoint operator (default: Id).
%
%    param.tight : 1 if A is a tight frame or 0 if not (default = 1)
%
%    param.nu : bound on the norm of the operator A (default: 1), i.e.
%
%        ` ||A x||^2 <= nu * ||x||^2
%
%
%    param.tol : is stop criterion for the loop. The algorithm stops if
%
%         (  n(t) - n(t-1) )  / n(t) < tol,
%
%
%     where  n(t) = f(x)+ 0.5 X-Z_2^2 is the objective function at iteration t*
%     by default, tol=10e-4.
%
%    param.maxit : max. nb. of iterations (default: 200).
%
%    param.verbose : 0 no log, 1 a summary at convergence, 2 print main
%     steps (default: 1)
%
%    param.weights : weights for a weighted L1-norm (default = 1)
%
%
%   infos is a Matlab structure containing the following fields:
%
%    infos.algo : Algorithm used
%
%    param.iter : Number of iteration
%
%    param.time : Time of exectution of the function in sec.
%
%    param.final_eval : Final evaluation of the function
%
%    param.crit : Stopping critterion used
%
%
%   See also:  proj_b1 prox_l1inf prox_l12 prox_tv
%
%   References:
%     M. Fadili and J. Starck. Monotone operator splitting for optimization
%     problems in sparse recovery. In Image Processing (ICIP), 2009 16th IEEE
%     International Conference on, pages 1461-1464. IEEE, 2009.
%
%     A. Beck and M. Teboulle. A fast iterative shrinkage-thresholding
%     algorithm for linear inverse problems. SIAM Journal on Imaging
%     Sciences, 2(1):183-202, 2009.
%
%
%   Url: http://unlocbox.sourceforge.net/doc//prox/prox_l1.php

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


% Author: Gilles Puy, Nathanael Perraudin
% Date: Nov 2012
%

% Start the time counter
t1 = tic;

% Optional input arguments
if nargin<3, param=struct; end

% Optional input arguments
if ~isfield(param, 'verbose'), param.verbose = 1; end
if ~isfield(param, 'tight'), param.tight = 1; end
if ~isfield(param, 'nu'), param.nu = 1; end
if ~isfield(param, 'tol'), param.tol = 1e-3; end
if ~isfield(param, 'maxit'), param.maxit = 200; end
if ~isfield(param, 'At'), param.At = @(x) x; end
if ~isfield(param, 'A'), param.A = @(x) x; end
if ~isfield(param, 'weights'), param.weights = 1; end
if ~isfield(param, 'pos'), param.pos = 0; end

% test the parameters
gamma=test_gamma(gamma);
param.weights=test_weights(param.weights);

% Useful functions




% Projection
if param.tight && ~param.pos % TIGHT FRAME CASE
    
    temp = param.A(x);
    sol = x + 1/param.nu * param.At(soft_threshold(temp, ...
        gamma*param.nu*param.weights)-temp);
    crit = 'REL_OBJ'; iter = 1;
    dummy = param.A(sol);
    norm_l1 = sum(param.weights(:).*abs(dummy(:)));
    
else % NON TIGHT FRAME CASE OR CONSTRAINT INVOLVED
    
    % Initializations
    u_l1 = zeros(size(param.A(x)));
    sol = x - param.At(u_l1);
    prev_l1 = 0; iter = 0;
    
    % Soft-thresholding
    % Init
    if param.verbose > 1
        fprintf('  Proximal l1 operator:\n');
    end
    while 1
        
        % L1 norm of the estimate
        dummy = param.A(sol);
        norm_l1 = .5*norm(x(:) - sol(:), 2)^2 + gamma * ...
            sum(param.weights(:).*abs(dummy(:)));
        rel_l1 = abs(norm_l1-prev_l1)/norm_l1;
        
        % Log
        if param.verbose>1
            fprintf('   Iter %i, ||A x||_1 = %e, rel_l1 = %e\n', ...
                iter, norm_l1, rel_l1);
        end
        
        % Stopping criterion
        if (rel_l1 < param.tol)
            crit = 'REL_OB'; break;
        elseif iter >= param.maxit
            crit = 'MAX_IT'; break;
        end
        
        % Soft-thresholding
        res = u_l1*param.nu + param.A(sol);
        dummy = soft_threshold(res, gamma*param.nu*param.weights);
        if param.pos
            dummy = real(dummy); dummy(dummy<0) = 0;
        end
        u_l1 = 1/param.nu * (res - dummy);
        sol = x - param.At(u_l1);
        
        
        % for comprehension of Nathanael only
        % sol=x - param.At(ul1+A(sol)-soft_threshold(ul1+A(sol)))
        
        % Update
        prev_l1 = norm_l1;
        iter = iter + 1;
        
    end
end

% Log after the projection onto the L2-ball
if param.verbose >= 1
    fprintf(['  prox_L1: ||A x||_1 = %e,', ...
        ' %s, iter = %i\n'], norm_l1, crit, iter);
end


infos.algo=mfilename;
infos.iter=iter;
infos.final_eval=norm_l1;
infos.crit=crit;
infos.time=toc(t1);
end



