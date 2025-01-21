function [Alist, Blist, Clist] = AORBL(A, B, C, sigm1, sigm2, tol)

	[n, p] = size(C');
	H = eye(p);
	I = eye(n);

	err = 1;
	m = 1;
	sigm = [sigm1 sigm2];

	while(err > tol)
		[V, W] = rationalLanczosBlock(A, B, C, sigm);

		%interpolation points choice
		Imp = eye(m, p);
		Rb = B - (m*I - A) * V * inv(m*Imp - Alist) * Blist;
		Rc = C' - (m*I - A)' * W * inv(m*Imp - Alist)' * Clist';
		s = arg(max(norm(Rc' * Rb)));
		sigm = [sigm s];

		%calcul model redus
		A = W' * A * V;
		B = W' * B * C;
		C = C * V;

		%calcul fct de transfer H
		Hsup = C * inv(m*I - A) * B;

		%calcul eroare
		err = norm(Hsup - H, Inf);

		m = m + 1;
		H = Hsup;

		Alist = [Alist A];
		Blist = [Blist B];
		Clist = [Clist C];

	endwhile

endfunction