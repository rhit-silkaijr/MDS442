function Qp = insulinModel11(t,Q)
    %Debug later
    ke = .35;
    a = 2.44;
    b = 53.45;
    bi = 79.19;
    s = 2.01;
    si = 2.86;
    mub = 12;
    Ti = bi;
    Tb = a*mub+b;
    mux = @(x)5*x;
    fun = @(x) mux(x) * ((t-x)^(si-1)*si*Ti^si)/((Ti^si+(t-x)^si)^2);
    intEval = integral(fun,0,t);
    Qp = -ke*Q+(mub*t^(s-1)*s*Tb^s)/((Tb+t^s)^2) + intEval;
end