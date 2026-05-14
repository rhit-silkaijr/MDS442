function Qp = insulinModel6(t,Q)
    mu = 860/60;
    ke = .35;
    ka1 = 101*10^(-4);
    ka2 = 180*10^(-4);
    k = 61*10^(-2);
    Qp = zeros(5,1);
    Qp(1) = k*mu-ka1*Q(1);
    Qp(2) = (1-k)*mu-ka2*Q(2);
    Qp(3) = ka1*Q(1)-ka1*Q(3);
    Qp(4) = ka2*Q(2)-ka2*Q(4);
    Qp(5) = ka1*Q(3)+ka2*Q(4)-ke*Q(5);
end