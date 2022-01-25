using MCCGA


lower = [-100.0, -100.0]
upper = [100.0, 100.0]

function ff(x)
    return abs(x[1] - 3.141592) + abs(x[2] - exp(1.0))
end 


result = MCCGA.mccga(lower = lower, upper = upper, 
                    costfunction = ff, popsize = 500, maxsamples = 1000)