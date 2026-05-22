% Average concentrations every 30 mins
avgCon = [12 35.33 42 38 33.67 30 27.33 21.33 20.67 20 18.33 14.67 14.67 15.33 15.33 14 13.33 12.67 12 10.33 9.67 10 9.67 9.33];

% 95% interval around concentrations
avgConInt = [1.33 4 4 4.67 3.67 3.33 4 4 3.33 3.67 3 2.33 2 2.67 2.33 2.33 3 3.33 2.67 2.33 2.67 2.33 2.33 2.67];

% Max and min values of intervals
maxCon = avgCon + avgConInt;
minCon = avgCon - avgConInt;

tspan = [0 720];

dl = 4.2;

ka1Opts = [0.005, 0.009, 0.0099, 0.01, 0.0101, 0.0102, 0.01015, 0.02, 0.05, 0.1, 1];
ka2Opts = [0.005, 0.01, 0.015, 0.016, 0.017, 0.018, 0.019, 0.02, 0.03, 0.04, 0.05, 0.1];
kOpts = [.1, .3, .5, .55, .59, .6, .61, .62, .63, .65, .7, .8, 1];

Qo = [0 5950 0 3000.2 50.4]';
ode = @(t,y) insulinModel6(t,y);
[t,Q] = ode45(ode, tspan, Qo);
Q = Q(:,5)/dl;

calcCon = zeros(1, 24);
for j=1:24
    index = round(length(Q)*(j)/24);
    calcCon(j) = Q(index);
end

SSEBase = SSE(maxCon, minCon, calcCon, 1);
SSEPartialBase = SSEPartial(maxCon, minCon, calcCon, 1);
SSEWeightBase = SSEWeight(maxCon, minCon, calcCon, 1);

for ka1 = ka1Opts
    for ka2 = ka2Opts
        for k = kOpts

            ode = @(t,y) tempInsulinModel6(t,y, ka1, ka2, k);
            [t,Q] = ode45(ode, tspan, Qo);
            Q = Q(:,5)/dl;
            calcCon = zeros(1, 24);
            for j=1:24
                index = round(length(Q)*(j)/24);
                calcCon(j) = Q(index);
            end
            
            SSEMod = SSE(maxCon, minCon, calcCon, ka1);
            SSEPartialMod = SSEPartial(maxCon, minCon, calcCon, ka1);
            SSEWeightMod = SSEWeight(maxCon, minCon, calcCon, ka1);
        
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
    end
end

%Also graphs probably

function Qp = tempInsulinModel6(t,Q, ka1, ka2, k)
    mu = 860/60;
    ke = .35;
    Qp = zeros(5,1);
    Qp(1) = k*mu-ka1*Q(1);
    Qp(2) = (1-k)*mu-ka2*Q(2);
    Qp(3) = ka1*Q(1)-ka1*Q(3);
    Qp(4) = ka2*Q(2)-ka2*Q(4);
    Qp(5) = ka1*Q(3)+ka2*Q(4)-ke*Q(5);
end