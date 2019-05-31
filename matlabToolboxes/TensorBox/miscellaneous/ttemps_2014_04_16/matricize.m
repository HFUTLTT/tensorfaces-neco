function res = matricize( U, mode )
    %MATRICIZE Matricize 3D Matlab array. 
    %   A = MATRICIZE(U, MODE) matricizes the 3D Matlab array U along the 
    %   specified mode MODE. Higher dimensions than 3 are not supported.
    %
    %   See also TENSORIZE, TENSORPROD, UNFOLD.
    
    %   TTeMPS Toolbox. 
    %   Michael Steinlechner, 2013-2014
    %   Questions and contact: michael.steinlechner@epfl.ch
    %   BSD 2-clause license, see LICENSE.txt

    d = size(U);
    % pad with 1 for the last dim (annoying)
    if length(d) == 2
        d = [d, 1];
    end
    
    % fixed bugs when U is of order-4 (core of block-TT) % Phan Anh Huy Sept 2014.
    if mode == 1
        res = reshape(U,d(1),[]);
    elseif mode == ndims(U)
        res = transpose(reshape(U,[],d(mode)));
    else
        res = reshape(permute(U,[mode 1:mode-1 mode+1:ndims(U)]),d(mode),[]);
    end
%     switch mode
%         case 1
%             res = reshape( U, [d(1), d(2)*d(3)] );
%         case 2 
%             res = reshape( permute( U, [2, 1, 3]), [d(2), d(1)*d(3)] );
%         case 3 
%             res = transpose( reshape( U, [d(1)*d(2), d(3)] ) );
%         otherwise
%             error('Invalid mode input in function matricize')
%     end
end
