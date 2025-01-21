function R = bicubic_resize(I, p, q)
    % =========================================================================
    % Upscaling de imagine folosind algoritmul de interpolare bicubica
    % Transforma imaginea I din dimensiune m x n in dimensiune p x q
    % =========================================================================

    [m n nr_colors] = size(I);
    
    I = double(I);

    % initializeaza matricea finala
    R = zeros(p, q);

    % daca imaginea e alb negru, ignora
    if nr_colors > 1
        R = -1;
        return
    endif

    % Obs:
    % Atunci cand se aplica o scalare, punctul (0, 0) al imaginii nu se va
    % deplasa.
    % In Octave, pixelii imaginilor sunt indexati de la 1 la n.
    % Daca se lucreaza in indici de la 1 la n si se inmulteste x si y cu s_x
    % si s_y, atunci originea imaginii se va deplasa de la (1, 1) la (sx, sy)!
    % De aceea, trebuie lucrat cu indici in intervalul de la 0 la n - 1!


    % TODO: calculeaza factorii de scalare
    % Obs: daca se lucreaza cu indici in intervalul [0, n - 1], ultimul
    % pixel al imaginii se va deplasa de la (m - 1, n - 1) la (p, q).
    % s_x nu va fi q ./ n
    s_x = (q-1) ./ (n-1);
    s_y = (p-1) ./ (m-1);

    % TODO: defineste matricea de transformare pentru redimensionare
    T = [s_x, 0; 0 s_y];

    % TODO: calculeaza inversa transformarii
    invT = inv(T);

    % TODO: precalculeaza derivatele
    [Ix, Iy, Ixy] = precalc_d(I); 

    % parcurge fiecare pixel din imagine
    % foloseste coordonate de la 0 la n - 1
    for y = 0 : p - 1
        for x = 0 : q - 1
            % TODO: aplica transformarea inversa asupra (x, y) si calculeaza
            % x_p si y_p din spatiul imaginii initiale
            P = [x, y] * invT;

            % TODO: trece (xp, yp) din sistemul de coordonate de la 0 la n - 1 in
            % sistemul de coordonate de la 1 la n pentru a aplica interpolarea
            P = P + [1, 1];

            % TODO: gaseste cele 4 puncte ce inconjoara punctul x, y
            x1 = floor(P(1));
            y1 = floor(P(2));
            x2 = x1 + 1;
            y2 = y1 + 1;

            if y2 > m
                y2 = m;
            endif

            if x2 > n
                x2 = n;
            endif

            % TODO: calculeaza coeficientii de interpolare A
            A = bicubic_coef(I, Ix, Iy, Ixy, x1, y1, x2, y2);

            % TODO: trece coordonatele (xp, yp) in patratul unitate, scazand (x1, y1)
            P(1) = P(1) - x1;
            P(2) = P(2) - y1;

            % TODO: calculeaza valoarea interpolata a pixelului (x, y)
            % Obs: pentru scrierea in imagine, x si y sunt in coordonate de
            % la 0 la n - 1 si trebuie aduse in coordonate de la 1 la n
            R(y + 1, x + 1) = [1 P(2) P(2)^2 P(2)^3] * A' * [1; P(1); P(1)^2; P(1)^3];

        endfor
    endfor

    % TODO: transforma matricea rezultat in uint8 pentru a fi o imagine valida
    R = uint8(R);
    
endfunction