using MCCGA
using Test

@testset "Bit operations" begin

    @testset "Bit-float conversations" begin
        tol = 0.001

        v = [2.71828, 3.14159265, 1.0, 5, -100]

        mybits = bits(v)

        myfloats = floats(mybits)

        @test length(mybits) == 32 * length(v)
        @test length(myfloats) == length(v)

        for i = 1:length(v)
            @test isapprox(v[i], myfloats[i], atol = tol)
        end
    end

    @testset "Sign bit test" begin
        mybits1 = bits(9.8)
        mybits2 = bits(-9.8)

        @test mybits1[1] == 0
        @test mybits2[1] == 1
    end

    @testset "Infinity bits" begin

        infbits = [
            0,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
        ]

        mybits1 = bits(Inf64)
        mybits2 = bits(Inf32)
        mybits3 = bits(Inf)

        @test mybits1 == infbits
        @test mybits2 == infbits
        @test mybits3 == infbits
    end

    @testset "NaN bits" begin
        nanbits = [
            0,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
        ]

        mybits1 = bits(NaN64)
        mybits2 = bits(NaN32)
        mybits3 = bits(NaN)

        @test mybits1 == nanbits
        @test mybits2 == nanbits
        @test mybits3 == nanbits
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

    function Chichinadze(pars)
        @assert(length(pars) == 2)
        x = pars[1]
        y = pars[2]
        return x^2 - 12.0x + 11.0 + 10.0 * cos(pi * x / 2.0) + 8.0 * sin(5 * pi * x) -
               (1 / sqrt(5)) * exp(-0.5 * (y - 0.5)^2)
    end


    result = MCCGA.mccga(
        lower = lower,
        upper = upper,
        costfunction = Chichinadze,
        popsize = 200,
        maxsamples = 10000,
    )

    finalsolution = result["final_solution"]
    finalminimum = result["final_minimum"]

    @test isapprox(finalsolution[1], 5.90133, atol = tol)
    @test isapprox(finalsolution[2], 0.5, atol = tol)
    @test isapprox(finalminimum, -43.3159, atol = tol)
end
