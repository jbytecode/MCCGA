@testset "Regression with constraint |Beta_0| + |Beta_1| == 5" begin 

    x = 1:10
    o = ones(10)
    X = hcat(o, x)
    e = [-1.04671,  -0.826279,  -0.393097,  0.667042,  -1.91707,  0.58394,  -0.879225,  1.13443,  -0.925627,  0.0061916]
    y = 5 .+ 5 * x .+ e 

    function f(betas)
        resid = y .- X * betas 
        return sum(resid.^2)
    end 

    function constraintf(betas)
        # | b0 | + | b1 | == 5
        return [
            abs(abs(betas[1]) + abs(betas[2]) - 5.0)
            ]
    end 

    tol = 0.001

    lower = [0.0, 0.0]
    upper = [30.0, 30.0]

    result = MCCGA.mccga(
        lower = lower,
        upper = upper,
        costfunction = f,
        constraintfunction = constraintf,
        popsize = 200,
        maxsamples = 10000,
    )

    finalsolution = result["final_solution"]
    finalminimum = result["final_minimum"]

    @info sum(finalsolution)
    @info finalsolution
    @info finalminimum
    @info result
end 