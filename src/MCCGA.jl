module MCCGA

import Optim
import Statistics

export bits 
export floats 
export initialprobs 
export sample
export mccga

function bits(f::T)::Array{Int8,1} where {T<:Number}
    strbits = Float32(f) |> bitstring |> x -> split(x, "")
    return map(x -> parse(Int8, x), strbits)
end


function bits(fs::Array{T,1})::Array{Int8,1} where {T<:Number}
    mybits = Array{Int8,1}(undef, 0)
    for value in fs
        mybits = vcat(mybits, bits(value))
    end
    return mybits
end

function floats(bitarray::Array{T,1})::Array{Float64,1} where {T<:Int}
    numbits = length(bitarray)
    values = Array{Float64,1}(undef, 0)
    starting = 1
    while true
        ending = starting + 32 - 1
        if ending > numbits
            break
        end
        bitpart = bitarray[starting:ending]
        bitsasstring = join(map(x -> string(x), bitpart))
        numasint = parse(UInt32, bitsasstring, base = 2)
        numasfloat = reinterpret(Float32, numasint)
        push!(values, Float64(numasfloat))
        starting = ending + 1
    end
    return values
end

function colmeans(mat::Array{T,2})::Array{Float64,1} where {T<:Number}
    _, p = size(mat)
    means = Array{Float64,1}(undef, p)
    for i = 1:p
        means[i] = Statistics.mean(mat[:, i])
    end
    return means
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

end # module
