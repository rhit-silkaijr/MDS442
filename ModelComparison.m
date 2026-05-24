% Average concentrations every 30 mins
avgCon = [12 35.33 42 38 33.67 30 27.33 21.33 20.67 20 18.33 14.67 14.67 15.33 15.33 14 13.33 12.67 12 10.33 9.67 10 9.67 9.33];

% 95% interval around concentrations
avgConInt = [1.33 4 4 4.67 3.67 3.33 4 4 3.33 3.67 3 2.33 2 2.67 2.33 2.33 3 3.33 2.67 2.33 2.67 2.33 2.33 2.67];

% Max and min values of intervals
maxCon = avgCon + avgConInt;
minCon = avgCon - avgConInt;

tspan = [0 720];
numModels = 11;
numMetrics = 3;
SSEMatrix = zeros(numModels,numMetrics);

for i = 1:11
    [t,Q] = EvaluateModel(i,tspan);
    
    calcCon = zeros(1, 24);
    for j=1:24
        index = round(length(Q)*(j)/24);
        calcCon(j) = Q(index);
    end

    SSEMatrix(i,1) = SSE(maxCon, minCon, calcCon, i);
    SSEMatrix(i,3) = SSEPartial(maxCon, minCon, calcCon, i);
    SSEMatrix(i,2) = SSEWeight(maxCon, minCon, calcCon, i);

end

[M, I] = min(SSEMatrix(:,1));
fprintf('\n')
fprintf("Model %d performs best at SSE with an error of %f\n", I, M);

[t,Q] = EvaluateModel(6,tspan);
plot(t,Q);
title('Model 6')
xlabel('time (minutes)')
ylabel('Plasma Insulin (mU)')
hold on
errorbar(linspace(0, 720, 24), avgCon, avgConInt);

figure

[M, I] = min(SSEMatrix(:,2));
fprintf("Model %d performs best at weighted SSE with an error of %f\n", I, M);

[t,Q] = EvaluateModel(3,tspan);
plot(t,Q);
title('Model 3')
xlabel('time (minutes)')
ylabel('Plasma Insulin (mU)')
hold on
errorbar(linspace(0, 720, 24), avgCon, avgConInt);

[M, I] = min(SSEMatrix(:,3));
fprintf("Model %d performs best at partial SSE with an error of %f\n", I, M);