using MCCGA


lower = [-10.0, -10.0, -10]
upper = [10.0, 10.0, 10]


result = MCCGA.mccga(
        lower = lower,
        upper = upper,
        costfunction = Functions.levy,
        popsize = 100,
        maxsamples = 100000,
    )
