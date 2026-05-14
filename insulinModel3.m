function Qp = insulinModel3(t,Q)
    mu = 860/60;
    km = 66*10^(3);
    VMax = 1140;
    ke = .35;
    Qp = zeros(3,1);
    sumFirst = km+Q(1);
    sumSecond = km+Q(2);
    Qp(1) = mu - VMax*Q(1)/sumFirst;
    Qp(2) = VMax*Q(1)/sumFirst - VMax*Q(2)/sumSecond;
    Qp(3) = VMax*Q(2)/sumSecond - ke*Q(3);
end