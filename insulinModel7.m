function Qp = insulinModel7(t,Q)
    mu = 860/60;
    ke = .35;
    ka1 = 166*10^(-4);
    kv = 1*10^(-2);
    VAvg = .01;
    Qp = zeros(4,1); %Q1, Q2, Q3, X
    Qp(1) = mu - ka1*Q(1);
    Qp(2) = ka1*Q(1)-ka1*Q(2);
    Qp(3) = ka1*Q(2)-ke*Q(3);
    Qp(4) = VAvg-kv*Q(4);
end