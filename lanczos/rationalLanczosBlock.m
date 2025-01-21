function [Vlist, Wlist] = rationalLanczosBlock(A, B, C, sigm)
	[n, p] = size(C);
	C = C';
	m = length(sigm);

	I = eye(n);
	S = inv(A - sigm(1) * I) * B;
	R = inv(A - sigm(1) * I) * C';

	[V, H] = qr(S);
	[W, G] = qr(R);

	%initialize
	Vlist = V;
	Wlist = W;

	for k = 1:m
		if(k < m)

			if(sigm(k+1) == Inf)
				S = A * V;
				R = A' * W;
			else
				S = inv(A - sigm(k+1) * I) * V;
				R = inv((A - sigm(k+1) * I)') * W;
			endif

			H = Wlist' * S;
			G = Vlist' * R;

			S = S - Vlist * H;
			R = R - Wlist * G;

			%QR factorization
			[Vsup, Hsup] = qr(S);
			[Wsup, Gsup] = qr(R);

			%singular value decomposition
			[P, D, Q] = svd(W' * V);
			Q = Q';

			Vsup = Vsup * Q * (D ^ -1/2);
			Wsup = Wsup * P * (D ^ 1/2);

			Hsup = (D ^ 1/2) * Q' * Hsup;
			Gsup = (D ^ 1/2) * P' * Gsup;

			Vlist = [Vlist, Vsup];
			Wlist = [Wlist, Wsup];

		else

			if(sigm(m+1) == Inf)
				S = A * B;
				R = A' * C;
			else
				S = inv(A) * B;
				R = inv(A') * C;
			endif
			
			H = Wlist' * S;
			G = Vlist' * R;

			S = S - Vlist * H;
			R = R - Wlist * G;

			%QR factorization
			[Vsup, Hsup] = qr(S);
			[Wsup, Gsup] = qr(R);

			%singular value decomposition
			[P, D, Q] = svd(W' * V);
			Q = Q';

			Vsup = Vsup * Q * (D ^ -1/2);
			Wsup = Wsup * P * (D ^ 1/2);

			Hsup = (D ^ 1/2) * Q' * Hsup;
			Gsup = (D ^ 1/2) * P' * Gsup;

			Vlist = [Vlist, Vsup];
			Wlist = [Wlist, Wsup];

		endif

		V = Vsup;
		W = Wsup;
		H = Hsup;
		G = Gsup;

	endfor

endfunction