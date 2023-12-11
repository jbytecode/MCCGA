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