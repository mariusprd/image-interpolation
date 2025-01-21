function A = bicubic_coef(f, Ix, Iy, Ixy, x1, y1, x2, y2)
    % =========================================================================
    % Calculeaz? coeficien?ii de Interpolare Bicubic? pentru 4 puncte al?turate
    % =========================================================================

    % TODO: Calculeaz? matricile intermediare.
    B1 = [1 0 0 0; 0 0 1 0; -3 3 -2 -1; 2 -2 1 1];
    B2 = [1 0 -3 2; 0 0 3 -2; 0 1 -2 1; 0 0 -1 1];
    
    F = zeros(4, 4);

    F(:, 1) = [f(y1, x1) f(y1, x2) Ix(y1, x1) Ix(y1, x2)];
    F(:, 2) = [f(y2, x1) f(y2, x2) Ix(y2, x1) Ix(y2, x2)];
    F(:, 3) = [Iy(y1, x1) Iy(y1, x2) Ixy(y1, x1) Ixy(y1, x2)];
    F(:, 4) = [Iy(y2, x1) Iy(y2, x2) Ixy(y2, x1) Ixy(y2, x2)];

    % TODO: Converte?te matricile intermediare la double.
    B1 = double(B1);
    B2 = double(B2);
    F = double(F);

    % TODO: Calculeaz? matricea final?.
    A = B1 * F * B2;

endfunction