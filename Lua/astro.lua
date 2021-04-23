-- Basic Astrodynamics routines and constants
astro = astro or {}

-- 1 AU in km
astro.au = 149597870.7

-- gravitational constant of various bodies (in km^3/s^2)
astro.mu = function(body)
    body = string.lower(body)
    if body == "sun" then
        return 1.327124400189e11
    elseif body == "mercury" then
        return 2.20329e4
    elseif body == "venus" then
        return 3.248599e5
    elseif body == "earth" then
        return 3.9860044188e5
    elseif  body == "moon" then
        return 4.90486959e3
    elseif body == "mars" then
        return 4.2828372e4
    elseif body == "jupiter" then
        return 1.266865349e8
    elseif body == "saturn" then
        return 3.79311879e7
    elseif body == "uranus" then
        return 5.7939399e6
    elseif body == "neptune" then
        return 6.8365299e6
    elseif body == "pluto" then
        return 8.719e2
    end
end

-- Mean radius of various bodies (in km)
astro.radius = function(body)
    body = string.lower(body)
    if body == "sun" then
        return 696342.0
    elseif body == "mercury" then
        return 2439.7
    elseif body == "venus" then
        return 6051.8
    elseif body == "earth" then
        return 6371.0
    elseif  body == "moon" then
        return 1737.1
    elseif body == "mars" then
        return 3389.5
    elseif body == "jupiter" then
        return 69911.0
    elseif body == "saturn" then
        return 58232.0
    elseif body == "uranus" then
        return 25362.0
    elseif body == "neptune" then
        return 24622.0
    elseif body == "pluto" then
        return 1188.3
    end
end

-- Mean orbital radius of various bodies (in AU)
astro.orbital_radius = function(body)
    body = string.lower(body)
    if body == "mercury" then
        return 0.387
    elseif body == "venus" then
        return 0.723
    elseif body == "earth" then
        return 1.000
    elseif  body == "moon" then
        return 0.00257
    elseif body == "mars" then
        return 1.52
    elseif body == "jupiter" then
        return 5.20
    elseif body == "saturn" then
        return 9.58
    elseif body == "uranus" then
        return 19.20
    elseif body == "neptune" then
        return 30.05
    elseif body == "pluto" then
        return 39.48
    end
end

-- various vector identities (using the Vector class)
astro.h_vec = function(r, v)
    return r:cross(v)
end

astro.e_vec = function(r, v, mu)
    return v:cross(r:cross(v))/mu - r/r:norm()
end


-- NOT YET IMPLEMENTED

-- Kepler's equation & anomalies
astro.M2E = function(M, e)
    if e < 1 then
        local E = M/(1-e)
        local delta = E - e*math.sin(E) - M
        while delta > 1e-6 do
            E = E - delta/(1-e*math.cos(E))
            delta = E - e*math.sin(E) - M
        end
        return E
    elseif e == 1 then
        error("Feature not implemented")
    else
        local E = M
        local delta = e*math.sinh(E) - E - M
        while delta > 1e-6 do
            E = E - delta/(e*math.cosh(E) - 1)
            delta = e*math.sinh(E) - E - M
        end
        return E
    end
end

astro.E2M = function(E, e)
    if e < 1 then
        return E - e*math.sin(E)
    elseif e == 1 then
        error("Feature not implemented")
    else
        return e*math.sinh(E) - E
    end
end

astro.theta2E = function(theta, e)
    if e < 1 then
        return 0
    elseif e == 1 then
        error("Feature not implemented")
    else
        return 0
    end
end

astro.E2theta = function(E, e)
    if e < 1 then
        return 0
    elseif e == 1 then
        error("Feature not implemented")
    else
        return 0
    end
end

-- Mean motion and period
astro.mean_motion = function(a, mu)
    return math.sqrt(mu/a^3)
end

astro.orbital_period = function(a, mu)
    return 2*math.pi*math.sqrt(a^3/mu)
end

-- orbit equation and apses
astro.r = function(p, e, theta)
    return p/(1 + e*math.cos(theta))
end

astro.theta = function(p, e, r)
    return math.acos((p/r - 1)/e)
end

astro.rp = function(p, e)
    return p/(1+e)
end

astro.ra = function(p, e)
    return p/(1-e)
end

-- conversions between Cartesian and Keplerian
astro.kep2xyz = function(a, e, i, Om, om, f)
    error("Feature not implemented")
    return { x, y, z, vx, vy, vz }
end

astro.xyz2kep = function(x, y, z, vx, vy, vz)
    error("Feature not implemented")
    return { a, e, i, Om, om, f }
end
