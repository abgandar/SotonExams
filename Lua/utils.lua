-- helper to print any math type with given number of digits
function print(x, digits)
    if type(x) == "number" then
        digits = digits or 4
        tex.print(string.format("\\num{%."..digits.."g}", x))
    elseif type(x) == "table" and x.print then
        x:print(digits)
    else
        error("Don't know how to print variable of type "..type(x))
    end
end
