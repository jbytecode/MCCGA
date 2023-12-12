module Functions

#=
two-variable function
x = 5.90133
y = 0.5
fmin = -43.3159 
-30 <= x, y <= 30
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
-10 <= x_i <= 10
=#
function levy(pars)
    d = length(pars)

    w = zeros(Float64, d)

    for ii ∈ 1:d
        w[ii] = 1 + (pars[ii] - 1.0) / 4.0
    end

    term1 = (sin(pi * w[1]))^2
    term3 = (w[d] - 1)^2.0 * (1 + (sin(2.0 * pi * w[d]))^2.0)

    sum = 0
    for ii ∈ 1:(d-1)
        wi = w[ii]
        new = (wi - 1)^2 * (1 + 10 * (sin(pi * wi + 1))^2)
        sum = sum + new
    end

    return term1 + sum + term3
end


#=
n-variable function
x = [0, 0, ..., 0]
fmin = 0
-32.768 <= x_i <= 32.768
=#
function ackley(xx)
    d = length(xx)
    a = 20
    b = 0.2
    c = 2 * pi

    sum1 = 0
    for i = 1:d
        sum1 = sum1 + xx[i]^2
    end

    sum2 = 0
    for i = 1:d
        sum2 = sum2 + cos(c * xx[i])
    end

    term1 = -a * exp(-b * sqrt(sum1 / d))
    term2 = -exp(sum2 / d)

    y = term1 + term2 + a + exp(1)

    return (y)
end


# -500 <= x_i <= 500
# min f = 0 
# at 
# x_i = 420.9687
function schefel(x)
    d = length(x)
    part1 = 418.9829 * d

    part2 = 0.0
    for i = 1:d
        part2 += x[i] * sin(sqrt(abs(x[i])))
    end

    return part1 - part2
end


end # End of Module 
