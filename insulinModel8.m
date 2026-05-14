function Qp = insulinModel8(t,Q)
    mu = 860/60;
    ke = .35;
    ka1 = 251*10^(-4);
    ka2 = 180*10^(-4);
    k = 71 * 10^(-2);
    Qp = zeros(4,1); %Q1a, Q1b, Q2, Q3
    Qp(1) = k*mu-ka1*Q(1);
    Qp(2) = (1-k)*mu-ka2*Q(2);
    Qp(3) = ka1*Q(1)-ka1*Q(3);
    Qp(4) = ka1*Q(3)+ka2*Q(2)-ke*Q(4);
end