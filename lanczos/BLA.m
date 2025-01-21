function [Vlist, Wlist] = BLA(A, V, W, m)
	%Algoritmul bloc nesimetric Lanczos

	[n, p] = size(V);
	[Q, R] = qr(W'*V);
	V = V * inv(R);
	W = W * Q;
	Vsup = A * V;
	Wsup = A' * W;

	%list init:
	Vlist = V;
	Wlist = W;

	for j = 1:m
		a = W' * Vsup;
		Vsup = Vsup - V * a;
		Wsup = Wsup - W * a';

		%QR decomposition of Vsup(j+1) and Wsup(j+1):
		[V2, b] = qr(Vsup);
		[W2, d] = qr(Wsup);
		d = d';

		%singular value decomposition of Wt(j+1)V(j+1):
		[U, S, Z] = svd(W2' * V2);
		Z = Z';

		d = d * U * (S ^ (1/2));
		b = (S ^ (1/2)) * Z' * b;

		V2 = V2 * Z * (S ^ (-1/2));
		W2 = W2 * U * (S ^ (-1/2));

		V2sup = A * V2 - V * d;
		W2sup = A' * W2 - W * b';

		Vsup = V2sup;
		Wsup = W2sup;

		V = V2;
		W = W2;

		%adding to lists
		Vlist = [Vlist V];
		Wlist = [Wlist W];

	endfor

endfunction