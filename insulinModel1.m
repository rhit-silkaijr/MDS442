function Qp = insulinModel1(t, Q)
    mu = 860/60;
    ka1 = 166*10^(-4);
    ke = .35;
    Qp = zeros(3,1);
    Qp(1) = mu - ka1*Q(1);
    Qp(2) = ka1*Q(1)-ka1*Q(2);
    Qp(3) = ka1*Q(2)-ke*Q(3);
end