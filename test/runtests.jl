using MCCGA
using Test

@testset "Bit operations" begin

    @testset "Bits to float" begin
        bitsofnumber = [
            0,
            0,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            0,
            0,
            1,
            0,
            0,
            0,
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
            0
        ]

        floatlist = floats(bitsofnumber)

        @test floatlist isa Vector
        @test length(floatlist) == 1
        @test floatlist[1] == 1.1328125
    end


    @testset "Float to bits" begin
        fvalue = 76289.375
        fbits = bits(fvalue)

        @test length(fbits) == 32
        @test fbits == [0,1,0,0,0,1,1,1,1,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,1,0,1,1,0,0,0,0]
    end

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

