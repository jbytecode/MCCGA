using MCCGA


lower = [-32.768, -32.768, -32.768]
upper = [32.768, 32.768, 32.768]




result = MCCGA.mccga(
        lower = lower,
        upper = upper,
        costfunction = Functions.ackley,
        popsize = 100,
        maxsamples = 100000,
    )
