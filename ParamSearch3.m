% Average concentrations every 30 mins
avgCon = [12 35.33 42 38 33.67 30 27.33 21.33 20.67 20 18.33 14.67 14.67 15.33 15.33 14 13.33 12.67 12 10.33 9.67 10 9.67 9.33];

% 95% interval around concentrations
avgConInt = [1.33 4 4 4.67 3.67 3.33 4 4 3.33 3.67 3 2.33 2 2.67 2.33 2.33 3 3.33 2.67 2.33 2.67 2.33 2.33 2.67];

% Max and min values of intervals
maxCon = avgCon + avgConInt;
minCon = avgCon - avgConInt;

tspan = [0 720];

dl = 4.2;

VMaxOpts = [500, 900, 1000, 1100, 1120, 1130, 1140, 1150, 1160, 1200, 1300, 1400, 2000];
%ka1Opts2 = linspace(0.016, 0.017, 30);
kmOpts = [10000, 40000, 50000, 60000, 64000, 65000, 66000, 67000, 68000, 70000, 80000, 100000];

% Model 1 optimization

Qo = [5950 3000.2 50.4]';
ode = @(t,y) insulinModel3(t,y);
[t,Q] = ode45(ode, tspan, Qo);
Q = Q(:,3)/dl;

calcCon = zeros(1, 24);
for j=1:24
    index = round(length(Q)*(j)/24);
    calcCon(j) = Q(index);
end

SSEBase = SSE(maxCon, minCon, calcCon, 3);
SSEPartialBase = SSEPartial(maxCon, minCon, calcCon, 3);
SSEWeightBase = SSEWeight(maxCon, minCon, calcCon, 3);

for VMax = VMaxOpts
    for km = kmOpts
        ode = @(t,y) tempInsulinModel3(t, y, VMax, km);
        [t,Q] = ode45(ode, tspan, Qo);
        Q = Q(:,3)/dl;
        calcCon = zeros(1, 24);
        for j=1:24
            index = round(length(Q)*(j)/24);
            calcCon(j) = Q(index);
        end
        
        SSEMod = SSE(maxCon, minCon, calcCon, 0);
        SSEPartialMod = SSEPartial(maxCon, minCon, calcCon, 0);
        SSEWeightMod = SSEWeight(maxCon, minCon, calcCon, 0);
    
        if SSEMod < SSEBase
            %fprintf("Model %f beats a base SSE of %f with %f\n", ka1, SSEBase, SSEMod);
            SSEBase = SSEMod;
            bestBaseParams = [VMax, km];
        end
        if SSEPartialMod < SSEPartialBase
            %fprintf("Model %f beats a partial SSE of %f with %f\n", ka1, SSEPartialBase, SSEPartialMod);
            SSEPartialBase = SSEPartialMod;
            bestPartialParams = [VMax, km];
        end
        if SSEWeightMod < SSEWeightBase
            %fprintf("Model %f beats a weighted SSE of %f with %f\n", ka1, SSEWeightBase, SSEWeightMod);
            SSEWeightBase = SSEWeightMod;
            bestWeightParams = [VMax, km];
        end
    end
end

fprintf("Best Base SSE = %f with params VMax = %f, km = %f\n", SSEBase, bestBaseParams);
fprintf("Best Partial SSE = %f with params VMax = %f, km = %f\n", SSEPartialBase, bestPartialParams);
fprintf("Best Weight SSE = %f with params VMax = %f, km = %f\n", SSEWeightBase, bestWeightParams);

%Also graphs probably

function Qp = tempInsulinModel3(t,Q, VMax, km)
    mu = 860/60;
    ke = .35;
    Qp = zeros(3,1);
    sumFirst = km+Q(1);
    sumSecond = km+Q(2);
    Qp(1) = mu - VMax*Q(1)/sumFirst;
    Qp(2) = VMax*Q(1)/sumFirst - VMax*Q(2)/sumSecond;
    Qp(3) = VMax*Q(2)/sumSecond - ke*Q(3);
end