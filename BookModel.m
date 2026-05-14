function BookModel()

    % Average concentrations every 30 mins
    avgCon = [12 35.33 42 38 33.67 30 27.33 21.33 20.67 20 18.33 14.67 14.67 15.33 15.33 14 13.33 12.67 12 10.33 9.67 10 9.67 9.33];
    
    % 95% interval around concentrations
    avgConInt = [1.33 4 4 4.67 3.67 3.33 4 4 3.33 3.67 3 2.33 2 2.67 2.33 2.33 3 3.33 2.67 2.33 2.67 2.33 2.33 2.67];

    % Max and min values of intervals
    maxCon = avgCon + avgConInt;
    minCon = avgCon - avgConInt;

    % Choose model
    i = 11;

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

    % TODOs: 
    %
    % Fix models (7, 10)
    %   7 for inputs, 10 for outputs looking way off
    % Set up comparison of all models
    %   Report on how they do
    %   This is super easy now dw, infrastructure is all there
    % Perform a parameter search somehow
    % Write that report baybeeeeeee
    %   This is getting out of hand. Now there are two of them!

    % Done:
    % 
    % Refactor the code into multiple files
    %   We kinda need that one lowkey
    % Choose actual defensible, sensible metric
    %   This could be a weighted SSE?
    %   Or maybe just one considering the spike and the surrounding area
    % Refactor to make model selection easier
    % Implement and test all models
    % Verify graphs match up
    % Make SSE for base metric
    % Implement CI into the SSE calc