function ret = SSEWeight(maxCon, minCon, measureCon, i)

    % Custom error metric
    % Weighted SSE, peak is observed at j=3
    % So, place less weight on values of j fanning out from 3

    ret = 0;
    for j=1:24
        if ~(measureCon(j) <= maxCon(j) && measureCon(j) >= minCon(j))
            err = min((maxCon(j) - measureCon(j))^2,(measureCon(j) - minCon(j))^2);
            if j ~= 3
                err = err * (1/abs(j-3));
            end
            ret = ret + err;
        end
    end
    ret = sqrt(ret);
    fprintf("Model %d produces a weighted SSE of %f\n", i, ret);
end
