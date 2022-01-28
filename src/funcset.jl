module Functions 

#=
two-variable function
x = 5.90133
y = 0.5
fmin = -43.3159 
=#
function chichinadze(pars)
    @assert(length(pars) == 2)
    x = pars[1]
    y = pars[2]
    return x^2 - 12.0x + 11.0 + 10.0 * cos(pi * x / 2.0) + 8.0 * sin(5 * pi * x) -
           (1 / sqrt(5)) * exp(-0.5 * (y - 0.5)^2)
end


#=
n-variable function
x = [1, 1, ..., 1]
fmin = 0
=#
function levy(pars)
    d = length(pars)

    w = zeros(Float64, d)

    for ii = 1:d
        w[ii] = 1 + (pars[ii] - 1.0) / 4.0
    end

    term1 = (sin(pi * w[1]))^2
    term3 = (w[d] - 1)^2.0 * (1 + (sin(2.0 * pi * w[d]))^2.0)

    sum = 0
    for ii = 1:(d-1)
        wi = w[ii]
        new = (wi - 1)^2 * (1 + 10 * (sin(pi * wi + 1))^2)
        sum = sum + new
    end

    return term1 + sum + term3
end
end 