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