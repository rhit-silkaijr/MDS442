function ret = SSEPartial(maxCon, minCon, measureCon, i)

    % Second custom error metric
    % SSE just between j=1 and j=11
    % Chosen because the observed concentrations mostly level out after 11
    
    ret = 0;
    for j=1:11
        if ~(measureCon(j) <= maxCon(j) && measureCon(j) >= minCon(j))
            err = min((maxCon(j) - measureCon(j))^2,(measureCon(j) - minCon(j))^2);
            ret = ret + err;
        end
    end
    ret = sqrt(ret);
    fprintf("Model %d produces an SSE of %f\n", i, ret);
end
