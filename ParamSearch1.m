% Average concentrations every 30 mins
avgCon = [12 35.33 42 38 33.67 30 27.33 21.33 20.67 20 18.33 14.67 14.67 15.33 15.33 14 13.33 12.67 12 10.33 9.67 10 9.67 9.33];

% 95% interval around concentrations
avgConInt = [1.33 4 4 4.67 3.67 3.33 4 4 3.33 3.67 3 2.33 2 2.67 2.33 2.33 3 3.33 2.67 2.33 2.67 2.33 2.33 2.67];

% Max and min values of intervals
maxCon = avgCon + avgConInt;
minCon = avgCon - avgConInt;

tspan = [0 720];

dl = 4.2;

ka1Opts = [0.005, 0.01, 0.016, 0.017, 0.020, 0.05, 0.1, 0.5, 1];
ka1Opts2 = linspace(0.016, 0.017, 30);

% Model 1 optimization

Qo = [5950 3000.2 50.4]';
ode = @(t,y) insulinModel1(t,y);
[t,Q] = ode45(ode, tspan, Qo);
Q = Q(:,3)/dl;

calcCon = zeros(1, 24);
for j=1:24
    index = round(length(Q)*(j)/24);
    calcCon(j) = Q(index);
end

SSEBase = SSE(maxCon, minCon, calcCon, 1);
SSEPartialBase = SSEPartial(maxCon, minCon, calcCon, 1);
SSEWeightBase = SSEWeight(maxCon, minCon, calcCon, 1);

for ka1 = ka1Opts2
    ode = @(t,y) tempInsulinModel1(t, y, ka1);
    [t,Q] = ode45(ode, tspan, Qo);
    Q = Q(:,3)/dl;
    calcCon = zeros(1, 24);
    for j=1:24
        index = round(length(Q)*(j)/24);
        calcCon(j) = Q(index);
    end
    
    SSEMod = SSE(maxCon, minCon, calcCon);
    SSEPartialMod = SSEPartial(maxCon, minCon, calcCon);
    SSEWeightMod = SSEWeight(maxCon, minCon, calcCon);

    if SSEMod < SSEBase
        fprintf("Model %f beats a base SSE of %f with %f\n", ka1, SSEBase, SSEMod);
    end
    if SSEPartialMod < SSEPartialBase
        fprintf("Model %f beats a partial SSE of %f with %f\n", ka1, SSEPartialBase, SSEPartialMod);
    end
    if SSEWeightMod < SSEWeightBase
        fprintf("Model %f beats a weighted SSE of %f with %f\n", ka1, SSEWeightBase, SSEWeightMod);
    end
end

%Also graphs probably

function Qp = tempInsulinModel1(t, Q, ka1)
    mu = 860/60;
    ke = .35;
    Qp = zeros(3,1);
    Qp(1) = mu - ka1*Q(1);
    Qp(2) = ka1*Q(1)-ka1*Q(2);
    Qp(3) = ka1*Q(2)-ke*Q(3);
end