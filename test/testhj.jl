@testset "Hooke and Jeeves" begin
    f(x) = (x[1] - 1.0)^2 + (x[2] + 2.0)^2

    start = [7.0, -9.0]
    result = MCCGA.hj(f, start, maxiter = 2000, startstep = 2.0, endstep = 1.0e-6)

    @test result isa Dict
    @test haskey(result, "par")

    final = result["par"]
    @test isapprox(final[1], 1.0, atol = 1.0e-3)
    @test isapprox(final[2], -2.0, atol = 1.0e-3)
end
