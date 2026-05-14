function Qp = insulinModel2(t,Q)
    mu = 860/60;
    ka1 = 183*10^(-4);
    ke = .35;
    a = 148*10^(-9);
    Qp = zeros(3,1);
    sumFirst = ka1-a*Q(1);
    sumSecond = ka1-a*Q(2);
    Qp(1) = mu - sumFirst*Q(1);
    Qp(2) = sumFirst*Q(1)-sumSecond*Q(2);
    Qp(3) = sumSecond*Q(2)-ke*Q(3);
end