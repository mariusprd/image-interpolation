function a = proximal_coef(f, x1, y1, x2, y2)
    % =========================================================================
    % Calculeaza coeficientii a pentru Interpolarea Proximala intre punctele
    % (x1, y1), (x1, y2), (x2, y1) si (x2, y2).
    % =========================================================================
    
    % TODO: Calculeaza matricea A.
    A = [1 x1 y1 x1*y1; 1 x1 y2 x1*y2; 1 x2 y1 x2*y1; 1 x2 y2 x2*y2];
       
    % TODO: Calculeaza vectorul b.   
    b = zeros(4,1);
    for i = 1:4
       b(i) = f(A(i,3), A(i,2));
    endfor 
    
    % TODO: Calculeaza coeficientii.
    a = A \ b;
    
endfunction
