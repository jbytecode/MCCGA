function colmeans(mat::Array{T,2})::Array{Float64,1} where {T<:Number}
    _, p = size(mat)
    means = Array{Float64,1}(undef, p)
    for i = 1:p
        means[i] = Statistics.mean(mat[:, i])
    end
    return means
end
