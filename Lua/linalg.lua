Vector = {
    new = function(self, a)                    -- create a new Vector with given content, e.g. Vector:new({1,2,3})
        o = {}
        if a then
            for i, x in ipairs(a) do o[i] = x end
        end
        setmetatable(o, self)
        self.__index = self
        return o
    end,
    x = function(self)                          -- shortcuts to get unit vectors along axes
        return Vector:new({1,0,0})
    end,
    y = function(self)
        return Vector:new({0,1,0})
    end,
    z = function(self)
        return Vector:new({0,0,1})
    end,
    __unm = function(self)                     -- negate a Vector
        d = Vector:new( )
        for i, x in ipairs(self) do d[i] = -x end
        return d
    end,
    __add = function(self, v)                  -- add two vectors, or a vector and a number (componentwise)
        d = Vector:new( )
        if type(v) == "number" then
            for i, x in ipairs(self) do d[i] = x + v end
        elseif type(self) == "number" then
            return Vector.__add(v, self)
        else
            for i, x in ipairs(self) do d[i] = x + v[i] end
        end
        return d
    end,
    __sub = function(self, v)                  -- subtract two vectors, or a vector and a number (componentwise)
        d = Vector:new()
        if type(self) == "number" then
            for i, x in ipairs(v) do d[i] = self - x end
        elseif type(v) == "number" then
            for i, x in ipairs(self) do d[i] = x - v end
        else
            for i, x in ipairs(self) do d[i] = x - v[i] end
        end
        return d
    end,
    __mul = function(self, v)                  -- multiply two vectors (scalar dot product), or a vector and a number (componentwise)
        if type(v) == "number" then
            d = Vector:new()
            for i, x in ipairs(self) do d[i] = x*v end
        elseif type(self) == "number" then
            return Vector.__mul(v, self)
        elseif type(v) == "table" and v.__index == Matrix then
            return v.transpose()*self           -- left matrix product
        else
            d = 0
            for i, x in ipairs(self) do d = d + x*v[i] end
        end
        return d
    end,
    __div = function(self, v)                  -- divide a vector and a number (componentwise)
        d = Vector:new()
        for i, x in ipairs(self) do d[i] = x/v end
        return d
    end,
    cross = function(self, v)                  -- cross product between two vectors of length 3
        d = Vector:new()
        d[1] = self[2]*v[3]-self[3]*v[2]
        d[2] = self[3]*v[1]-self[1]*v[3]
        d[3] = self[1]*v[2]-self[2]*v[1]
        return d
    end,
    norm = function(self)                      -- length of a vector
        return math.sqrt(self*self)
    end,
    angle = function(self, v)                  -- angle between two vectors
        return math.acos((self*v)/(self:norm()*v:norm()))
    end,
    __tostring = function(self, digits)        -- vector as LaTeX pmatrix with given number of digits (defaults to 4)
        digits = digits or 4
        res = "\\begin{pmatrix}"
        for i,x  in ipairs(self) do 
            if i > 1 then res = res.."\\\\" end
            res = res..string.format("\\num{%."..digits.."g}", x)
        end
        return res.."\\end{pmatrix}"
    end,
    print = function(self, digits)             -- output vector to LaTeX document with given number of digits (defaults to 4)
        tex.print("\\ensuremath{"..self:__tostring(digits).."}")
    end
}

Matrix = {
    new = function(self, a)                    -- create a new Matrix with given content, e.g. Matrix:new({{1,2,3}, {2,3,4}, {3,4,5})
        o = {}
        if a then
            for i, x in ipairs(a) do
                o[i] = {}
                for j, y in ipairs(x) do o[i][j] = y end
            end
        end
        setmetatable(o, self)
        self.__index = self
        return o
    end,
    zero = function(self, a, b)                -- create a new zero Matrix of given size (a,b)
        o = Matrix:new()
        for i = 1, a do
            o[i] = {}
            for j = 1, b do o[i][j] = 0 end
        end
        return o
    end,
    eye = function(self, a)                    -- create a new (square) identity Matrix of given size
        o = Matrix:zero(a, a)
        for i = 1, a do o[i][i] = 1 end
        return o
    end,
    __unm = function(self)                     -- negate a Matrix
        d = Matrix:new( )
        for i, x in ipairs(self) do
            d[i] = {}
            for j, y in ipairs(x) do d[i][j] = -y end
        end
        return d
    end,
    __add = function(self, v)                  -- add two matrices
        d = Matrix:new( )
        for i, x in ipairs(self) do
            d[i] = {}
            for j, y in ipairs(x) do d[i][j] = y+v[i][j] end
        end
        return d
    end,
    __sub = function(self, v)                  -- subtract two matrices
        d = Matrix:new( )
        for i, x in ipairs(self) do
            d[i] = {}
            for j, y in ipairs(x) do d[i][j] = y-v[i][j] end
        end
        return d
    end,
    __mul = function(self, v)                  -- multiply two matrices, a matrix and a vector, or a matrix and a number
        if type(v) == "number" then
            d = Matrix:new()
            for i, x in ipairs(self) do
                d[i] = {}
                for j, y in ipairs(x) do d[i][j] = y*v end
            end
        elseif type(self) == "number" then
            return Matrix.__mul(v, self)
        elseif type(v) == "table" and v.__index == Vector then
            d = Vector:new()
            for i, x in ipairs(self) do
                d[i] = 0
                for j, y in ipairs(v) do d[i] = d[i]+x[j]*y end
            end
        elseif type(v) == "table" and v.__index == Matrix then
            d = Matrix:new()
            for i = 1, #self do
                d[i] = {}
                for j = 1, #v[1] do
                    d[i][j] = 0
                    for k, x in ipairs(self[i]) do d[i][j] = d[i][j] + x*v[k][j] end
                end
            end
        end
        return d
    end,
    __div = function(self, v)                  -- divide a matrix and a number (componentwise)
        d = Matrix:new()
        for i, x in ipairs(self) do
            d[i] = {}
            for j, y in ipairs(x) do d[i][j] = y/v end
        end
        return d
    end,
    transpose = function(self)                 -- transpose of the matrix
        d = Matrix:new()
        for i = 1, #self do
            d[i] = {}
            for j = 1, #(self[1]) do d[i][j] = self[j][i] end
        end
        return d
    end,
    __tostring = function(self, digits)        -- matrix as LaTeX pmatrix with given number of digits (defaults to 4)
        digits = digits or 4
        res = "\\begin{pmatrix}"
        for i, x in ipairs(self) do 
            if i > 1 then res = res.."\\\\" end
            for j, y in ipairs(x) do 
                if j > 1 then res = res.."&" end
                res = res..string.format("\\num{%."..digits.."g}", y)
            end
        end
        return res.."\\end{pmatrix}"
    end,
    print = function(self, digits)             -- output vector to LaTeX document with given number of digits (defaults to 4)
        tex.print("\\ensuremath{"..self:__tostring(digits).."}")
    end
}
