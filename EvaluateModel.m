function [t,Q] = EvaluateModel(i, tspan)

    dl = 4.2;
    insulinModels = {@insulinModel1 @insulinModel2 @insulinModel3 @insulinModel4 @insulinModel5 @insulinModel6 @insulinModel7 @insulinModel8 @insulinModel9, @insulinModel10, @insulinModel11};
    iModel = insulinModels{i};
    if i >= 1 && i <= 4
        Qo = [5950 3000.2 50.4]';
        ode = @(t,y) iModel(t,y);
        [t,Q] = ode45(ode, tspan, Qo);
        Q = Q(:,3)/dl;
    elseif i >= 5 && i <= 6
        Qo = [0 5950 0 3000.2 50.4]';
        ode = @(t,y) iModel(t,y);
        [t,Q] = ode45(ode, tspan, Qo);
        Q = Q(:,5)/dl;
    elseif i == 7
        Qo = [5950 3000.2 50.4 10000]';
        ode = @(t,y) iModel(t,y);
        [t,Q] = ode45(ode, tspan, Qo);
    
        % Calculate V
        km = 66*10^(-3);
        VMax = 1140;
        Vo = .01;
        V = Vo*(1+VMax*Q(:,4)./(km+Q(:,4)));
        
        Q = Q(:,3)/V;
    elseif i >= 8 && i <= 10
        Qo = [5950 0 0 50.4]';
        ode = @(t,y) iModel(t,y);
        [t,Q] = ode45(ode, tspan, Qo);
        Q = Q(:,4)/dl;
    elseif i == 11
        Qo = 50.4;
        ode = @(t,y) insulinModel11(t,y);
        [t,Q] = ode45(ode, tspan, Qo);
        Q = Q/dl;
    else
        % Should not be here
        print('error')
        return
    end
end

