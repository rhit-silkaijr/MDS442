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

    % TODOs: 
    %
    % Perform a parameter search somehow

        % How to actually search for a function?
        % Optimize it for three different SSEs
        % Basic functions have multiple options
        
        % Choosing to constrain it away from 7, 9, 10, 11 type.
        %So, 5 inputs, each dependent on themselves and other terms
        % with variate constants and potential square/inverse terms
        
        % Constants are a1 - a5 for Q1
        % tog1, tog2 for splitting the flow of 1 and 2 into a and b
        %   Can be 1 or 0
        % Tried this but was computationally infeasible - discuss in Report2
        
        % Instead, take the form of a couple of models and try to vary their params
        % And see if this allows for more accurate models.
        % Best ones have been:
        % Model 3, Model 6
        % Also include for fun/more work to show:
        % Model 1, Model 9
        
        % Note mu and ke are fixed for all models, only search table params

    % Write that report baybeeeeeee
    %   This is getting out of hand. Now there are two of them!

    % Done:
    % 
    % Set up comparison of all models
    %   Report on how they do
    %   This is super easy now dw, infrastructure is all there
    % Fix models (7, 10)
    %   7 for inputs, 10 for outputs looking way off
    %   This is done but 7 and 10 are still very inaccurate
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