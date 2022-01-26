using MCCGA 
using Test 

@testset "Bit operations" begin 
    
    tol = 0.001

    v = [2.71828, 3.14159265, 1.0, 5, -100]
    
    mybits = bits(v)

    myfloats = floats(mybits)

    @test length(mybits) == 32 * length(v)
    @test length(myfloats) == length(v)

    for i in 1:length(v)
        @test isapprox(v[i], myfloats[i], atol = tol)
    end 
end 

@testset "Sampling" begin
    @testset "Convergency state" begin
        probvector = [1.0, 1.0, 1.0]
        mysample = MCCGA.sample(probvector)

        @test length(mysample) == 3
        @test mysample[1] == 1.0
        @test mysample[2] == 1.0
        @test mysample[3] == 1.0
    end 

    @testset "Normal state" begin
        probvector = [0.5, 0.5, 0.5]
        mysample = MCCGA.sample(probvector)

        @test length(mysample) == 3
        @test mysample[1] >= 0.0
        @test mysample[2] >= 0.0
        @test mysample[3] >= 0.0
        @test mysample[1] <= 1.0
        @test mysample[2] <= 1.0
        @test mysample[3] <= 1.0
    end 
end 

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
        popsize = 100, maxsamples = 10000
    )

    @test result isa Dict 
    @test length(result) == 2

    finalsolution = result["final_solution"]

    @test finalsolution[1] >= 3
    @test finalsolution[1] <= 4

    @test finalsolution[2] >= 2
    @test finalsolution[2] <= 3

end