function Qp = insulinModel4(t,Q)
    mu = 860/60;
    km = 66*10^(3);
    VMax = 1140;
    ke = .35;
    Qp = zeros(3,1);
    sumThird = km+Q(3);
    Qp(1) = mu - VMax*Q(1)/sumThird;
    Qp(2) = VMax*Q(1)/sumThird - VMax*Q(2)/sumThird;
    Qp(3) = VMax*Q(2)/sumThird - ke*Q(3);
end