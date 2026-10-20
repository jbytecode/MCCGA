struct MCCGAResult
    initial_prob_vector::Vector{Float64}
    final_prob_vector::Vector{Float64}
    iterations::Int64
    initial_solution::Vector{Float64}
    final_solution::Vector{Float64}
    initial_minimum::Float64
    final_minimum::Float64
end 

function initialprobs(
    lower::Array{T,1},
    upper::Array{T,1};
    maxsamples = 10000,
) where {T<:Number}
    p = length(lower)
    @assert p == length(upper)

    bitlen = p * 32
    mat = Array{Int8,2}(undef, maxsamples, bitlen)
    @inbounds for tries = 1:maxsamples
        randvalues = map((x, y) -> x + rand() * (y - x), lower, upper)
        mat[tries, :] .= bits(randvalues)
    end
    return colmeans(mat)
end


function sample(probs::Array{T,1}) where {T<:Number}
    function mapper(f::T) where {T<:Number}
        if rand() < f
            return 1
        else
            return 0
        end
    end 
    return map(mapper, probs)
end

function isfeasible(constraintfunction::F, solution::Vector) where {F<:Function}
    deviationvector = constraintfunction(solution)
    return all(x -> iszero(x), deviationvector)
end

function getwinnerloser(ch1::Vector, ch2::Vector, costfunction::F) where {F<:Function}
    cost1 = costfunction(floats(ch1))
    cost2 = costfunction(floats(ch2))

    winner = ch1
    loser = ch2
    if (cost2 < cost1)
        winner = ch2
        loser = ch1
    end
    return (winner, loser)
end


function getwinnerloser(ch1, ch2, costfunction, constraintfunction)::Tuple

    if isnothing(constraintfunction)
        return getwinnerloser(ch1, ch2, costfunction)
    end

    fch1 = floats(ch1)
    fch2 = floats(ch2)

    feasible1 = isfeasible(constraintfunction, fch1)
    feasible2 = isfeasible(constraintfunction, fch2)

    #@info "->" fch1 fch2 feasible1 feasible2

    if feasible1 && feasible2
        return getwinnerloser(ch1, ch2, costfunction)
    elseif feasible1 && !feasible2
        return (ch1, ch2)
    elseif !feasible1 && feasible2
        return (ch2, ch1)
    else
        !feasible1 && !feasible2
        sumviolence1 = constraintfunction(fch1) .|> abs |> sum
        sumviolence2 = constraintfunction(fch2) .|> abs |> sum
        if sumviolence1 < sumviolence2
            return (ch1, ch2)
        else
            return (ch2, ch1)
        end
    end
end

function mccga(;
    lower::Array{T,1},
    upper::Array{T,1},
    costfunction::F,
    popsize::Int,
    maxsamples = 10000,
    constraintfunction::Union{G,Nothing} = nothing,
    λ = 1000,
)::MCCGAResult where {T<:Number,F<:Function,G<:Function}

    probvector = initialprobs(lower, upper, maxsamples = maxsamples)
    initial_probvector = copy(probvector)
    chsize = length(probvector)
    mutation = 1.0 / convert(Float64, popsize)
    numiters = 0

    while !(all(x -> (x <= mutation) || (x >= 1.0 - mutation), probvector))

        numiters += 1
        ch1 = sample(probvector)
        ch2 = sample(probvector)

        winner, loser = getwinnerloser(ch1, ch2, costfunction, constraintfunction)

        @inbounds for i = 1:chsize
            if winner[i] != loser[i]
                if winner[i] == 1
                    probvector[i] += mutation
                else
                    probvector[i] -= mutation
                end
                if probvector[i] > 1
                    probvector[i] = 1
                elseif probvector[i] < 0
                    probvector[i] = 0
                end
            end
        end
    end

    sampledvector = sample(probvector)
    initial_solution = floats(sampledvector)


    if isnothing(constraintfunction)
        local_result = Optim.optimize(costfunction, initial_solution, Optim.NelderMead())
    else
        function coupled(x)
            fx = costfunction(x)
            gx = constraintfunction(x)
            result = fx + λ * sum(gx .^ 2.0)
            return result
        end
        local_result = Optim.optimize(coupled, initial_solution, Optim.NelderMead())
    end

    return MCCGAResult(
        initial_probvector,
        sampledvector,
        numiters,
        floats(sampledvector),
        local_result.minimizer,
        costfunction(floats(sampledvector)),
        costfunction(local_result.minimizer),
    )
end


