function initialprobs(
    lower::Array{T,1},
    upper::Array{T,1};
    maxsamples = 10000,
) where {T<:Number}
    p = length(lower)
    @assert p == length(upper)

    bitlen = p * 32
    mat = Array{Int8,2}(undef, maxsamples, bitlen)
    for tries = 1:maxsamples
        randvalues = map((x, y) -> x + rand() * (y - x), lower, upper)
        mat[tries, :] .= bits(randvalues)
    end
    return colmeans(mat)
end

function sample(probs::Array{T,1}) where {T<:Number}
    return map(x -> if rand() < x
        1
    else
        0
    end, probs)
end

function mccga(;
    lower::Array{T,1},
    upper::Array{T,1},
    costfunction::Function,
    popsize::Int,
    maxsamples = 10000,
) where {T<:Number}
    probvector = initialprobs(lower, upper, maxsamples = maxsamples)
    chsize = length(probvector)
    mutation = 1.0 / convert(Float64, popsize)
    while !(all(x -> (x <= mutation) || (x >= 1.0 - mutation), probvector))
        ch1 = sample(probvector)
        ch2 = sample(probvector)
        cost1 = costfunction(floats(ch1))
        cost2 = costfunction(floats(ch2))
        winner = ch1
        loser = ch2
        if (cost2 < cost1)
            winner = ch2
            loser = ch1
        end
        for i = 1:chsize
            if winner[i] != loser[i]
                if winner[i] == 1
                    probvector[i] += mutation
                else
                    probvector[i] -= mutation
                end
            end
        end
    end

    initial_solution = floats(sample(probvector))

    local_result = Optim.optimize(costfunction, initial_solution, Optim.NelderMead())

    resultdict = Dict()
    resultdict["initial_solution"] = floats(sample(probvector))
    resultdict["final_solution"] = local_result.minimizer

    return resultdict
end