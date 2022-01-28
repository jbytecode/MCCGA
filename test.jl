using MCCGA


lower = [-30.0, -30.0]
upper = [30.0, 30.0]

function Chichinadze(pars)
    @assert(length(pars) == 2)
   x = pars[1]
   y = pars[2]
   return x^2 - 12.0x + 11.0 + 10.0 * cos(pi * x / 2.0) + 8.0 * sin(5 * pi * x) - (1 / sqrt(5)) * exp(-0.5 * (y - 0.5)^2)
end


result = MCCGA.mccga(lower = lower, upper = upper, 
                    costfunction = Chichinadze, popsize = 200, maxsamples = 10000)