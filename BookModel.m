function BookModel()

    % Average concentrations every 30 mins
    avgCon = [12 35.33 42 38 33.67 30 27.33 21.33 20.67 20 18.33 14.67 14.67 15.33 15.33 14 13.33 12.67 12 10.33 9.67 10 9.67 9.33];
    
    % 95% interval around concentrations
    avgConInt = [1.33 4 4 4.67 3.67 3.33 4 4 3.33 3.67 3 2.33 2 2.67 2.33 2.33 3 3.33 2.67 2.33 2.67 2.33 2.33 2.67];

    % Max and min values of intervals
    maxCon = avgCon + avgConInt;
    minCon = avgCon - avgConInt;

    % Choose model
    i = 10;

    tspan = [0 720];

    [t,Q] = EvaluateModel(i,tspan);

    plot(t,Q);
    xlabel('time (minutes)')
    ylabel('Plasma Insulin (mU)')

    % Timing evals
    calcCon = zeros(1, 24);
    for j=1:24
        index = round(length(Q)*(j)/24);
        calcCon(j) = Q(index);
    end

    SSE(maxCon, minCon, calcCon, i);
    SSEWeight(maxCon, minCon, calcCon, i);
    SSEPartial(maxCon, minCon, calcCon, i);

end