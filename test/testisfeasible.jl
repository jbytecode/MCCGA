@testset "isfeasible" begin 

    function g(solution)
        # 3x + 4y <= 100
        # 2x + 10y >= 20
        x = solution[1]
        y = solution[2]
        result = zeros(2)
        result[1] = abs(min(100 - 3x - 4y, 0.0))
        result[2] = abs(max(20 - 2x - 10y, 0.0))
        return result
    end 

    @test  isfeasible(g, [2.0, 2.0])
    @test !isfeasible(g, [1.0, 1.0])
    @test !isfeasible(g, [20.0, 20.0])
end 
