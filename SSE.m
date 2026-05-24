function ret = SSE(maxCon, minCon, measureCon, i)

    ret = 0;
    for j=1:24
        if ~(measureCon(j) <= maxCon(j) && measureCon(j) >= minCon(j))
            err = min((maxCon(j) - measureCon(j))^2,(measureCon(j) - minCon(j))^2);
            ret = ret + err;
        end
    end
    ret = sqrt(ret);
    if i > 0
        fprintf("Model %d produces an SSE of %f\n", i, ret);
    end
end
