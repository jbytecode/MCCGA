@testset "Optimization of Pi and E" begin
    function f(x)
        return (x[1] - 3.14159265)^2 + (x[2] - exp(1.0))^2
    end

    lower = [-100.0, -100.0]
    upper = [100.0, 100.0]

    result = MCCGA.mccga(
        lower = lower,
        upper = upper,
        costfunction = f,
        popsize = 100,
        maxsamples = 10000,
    )

    @test result isa Dict

    finalsolution = result["final_solution"]

    @test finalsolution[1] >= 3
    @test finalsolution[1] <= 4

    @test finalsolution[2] >= 2
    @test finalsolution[2] <= 3

end

@testset "Chichinadze" begin

    tol = 0.001

    lower = [-30.0, -30.0]
    upper = [30.0, 30.0]

    result = MCCGA.mccga(
        lower = lower,
        upper = upper,
        costfunction = Functions.chichinadze,
        popsize = 200,
        maxsamples = 10000,
    )

    finalsolution = result["final_solution"]
    finalminimum = result["final_minimum"]

    @test isapprox(finalsolution[1], 5.90133, atol = tol)
    @test isapprox(finalsolution[2], 0.5, atol = tol)
    @test isapprox(finalminimum, -43.3159, atol = tol)
end


@testset "Levy" begin

    tol = 0.001

    lower = [-10.0, -10.0, -10]
    upper = [10.0, 10.0, 10]


    result = MCCGA.mccga(
        lower = lower,
        upper = upper,
        costfunction = Functions.levy,
        popsize = 100,
        maxsamples = 10000,
    )


    finalsolution = result["final_solution"]
    finalminimum = result["final_minimum"]

    @test isapprox(finalsolution[1], 1.0, atol = tol)
    @test isapprox(finalsolution[2], 1.0, atol = tol)
    @test isapprox(finalsolution[3], 1.0, atol = tol)
    @test isapprox(finalminimum, 0.0, atol = tol)
end



@testset "Ackley" begin

    tol = 0.001

    lower = [-32.768, -32.768, -32.768]
    upper = [32.768, 32.768, 32.768]


    result = MCCGA.mccga(
        lower = lower,
        upper = upper,
        costfunction = Functions.ackley,
        popsize = 100,
        maxsamples = 10000,
    )


    finalsolution = result["final_solution"]
    finalminimum = result["final_minimum"]

    @test isapprox(finalsolution[1], 0.0, atol = tol)
    @test isapprox(finalsolution[2], 0.0, atol = tol)
    @test isapprox(finalsolution[3], 0.0, atol = tol)
    @test isapprox(finalminimum, 0.0, atol = tol)
end



# @testset "Schefel" begin
# 
#     tol = 0.001
# 
#     lower = [-500.0, -500.0, -500.0]
#     upper = [500.0, 500.0, 500.0]
# 
#     result = MCCGA.mccga(
#         lower = lower,
#         upper = upper,
#         costfunction = Functions.schefel,
#         popsize = 1000,
#         maxsamples = 10000,
#     )
# 
# 
#     finalsolution = result["final_solution"]
#     finalminimum = result["final_minimum"]
# 
#     @info finalsolution
# 
#     @test isapprox(finalsolution[1], 420.9687, atol = tol)
#     @test isapprox(finalsolution[2], 420.9687, atol = tol)
#     @test isapprox(finalsolution[3], 420.9687, atol = tol)
#     @test isapprox(finalminimum, 0.0, atol = tol)
# end