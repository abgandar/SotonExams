-- various math functions that got removed from the official library
-- some adapted from http://lua-users.org/wiki/HyperbolicFunctions which in turn used P.J.Plauger, "The Standard C Library"

if(math.atan2 == nil) then
    math.atan2 = math.atan      -- optionally takes 2 arguments in newer implementations
end

if(math.cosh == nil) then
    math.cosh = function(x)
        if x == 0.0 then return 1.0 end
        if x < 0.0 then x = -x end
        x = math.exp(x)
        x = x / 2.0 + 0.5 / x
        return x
    end
end

if(math.sinh == nil) then
    math.sinh = function(x)
        if x == 0 then return 0.0 end
        local neg = false
        if x < 0 then x = -x; neg = true end
        if x < 1.0 then
          local y = x * x
          x = x + x * y *
              (((-0.78966127417357099479e0  * y +
                 -0.16375798202630751372e3) * y +
                 -0.11563521196851768270e5) * y +
                 -0.35181283430177117881e6) /
              ((( 0.10000000000000000000e1  * y +
                 -0.27773523119650701667e3) * y +
                  0.36162723109421836460e5) * y +
                 -0.21108770058106271242e7)
        else
          x =  math.exp(x)
          x = x / 2.0 - 0.5 / x
        end
        if neg then x = -x end
        return x
    end
end

if(math.tanh == nil) then
    math.tanh = function(x)
        if x == 0 then return 0.0 end
        local neg = false
        if x < 0 then x = -x; neg = true end
        if x < 0.54930614433405 then
          local y = x * x
          x = x + x * y *
              ((-0.96437492777225469787e0  * y +
                -0.99225929672236083313e2) * y +
                -0.16134119023996228053e4) /
              (((0.10000000000000000000e1  * y +
                 0.11274474380534949335e3) * y +
                 0.22337720718962312926e4) * y +
                 0.48402357071988688686e4)
        else
          x = math.exp(x)
          x = 1.0 - 2.0 / (x * x + 1.0)
        end
        if neg then x = -x end
        return x
    end
end

-- These were never in the math library (from https://en.wikipedia.org/wiki/Inverse_hyperbolic_functions)

math.log10 = function(x)
    return math.log(x)/2.3025850929940456840179914546844    -- math.log(10)
end

math.log2 = function(x)
    return math.log(x)/0.69314718055994530941723212145818   -- math.log(2)
end

math.ln = function(x)
    return math.log(x)
end

math.asinh = function(x)
    return math.log(x + math.sqrt(x*x+1))
end

math.acosh = function(x)
    return math.log(x + math.sqrt(x*x-1))
end

math.atanh = function(x)
    return 0.5*math.log((1+x)/(1-x))
end

math.root = function(x, f, df, eps)
    -- df and eps are optional parameters (but really better to provide at least df analytically)
    eps = eps or 1e-10
    df = df or function(x) return (f(x+eps)-f(x))/eps end
    for i=1,50,1 do
        local fx = f(x)
        local dfx = df(x)
        local xx = x - fx/dfx
        if(math.abs(xx-x) < eps) then return xx end
        x = xx
    end
    return 1/0      -- create a nan
end