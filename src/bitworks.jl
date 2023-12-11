"""
        bits(value)

Returns bits of the value. The value is supposed to be 32-bits integer or float. 
If the value has larger bits, it is converted to its 32-bits counterpart.

    
# Arguments:
 - `value::Number`: An integer or float 
 

# Output 
- `::Array{Int8, 1}`: Array of bits of size 32

# Example
```julia
julia> bits(3.14159265)
32-element Vector{Int8}:
 0
 1
 0
 0
 0
 0
 0
 0
 0
 1
 0
 ⋮
 1
 1
 1
 1
 1
 0
 1
 1
 0
 1
 1
````

# References
Satman, Mehmet Hakan, and Emre Akadal. "Machine Coded Compact Genetic Algorithms 
for Real Parameter Optimization Problems." Alphanumeric Journal 8.1 (2020): 43-58.

Satman, Mehmet Hakan, and Emre Akadal. "Makine Kodlu Hibrit Kompakt Genetik Algoritmalar 
Optimizasyon Yöntemi", TR Patent 2018-GE-510,239    
"""
function bits(f::T)::Array{Int8,1} where {T<:Number}
    #strbits = Float32(f) |> bitstring |> x -> split(x, "")
    #return map(x -> parse(Int8, x), strbits)
    newf = Float32(f)
    casted = reinterpret(Int32, newf)
    return map(i-> casted >> i & 1, 31:(-1):0)
end







"""
        bits(values)

Returns bits of the values. The values is supposed to be an array of 32-bits integer or float. 
If the values have larger bits, they are converted to their 32-bits counterpart.

    
# Arguments:
 - `values::Array{Number, 1}`: An array of integers or floats 
 

# Output 
- `::Array{Int8, 1}`: Array of bits of size 32 for each item in the values.

# Example
```
julia> mybits = bits([3.14159265, exp(1.0)]);

julia> println(mybits)
Int8[0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0]
```

# References
Satman, Mehmet Hakan, and Emre Akadal. "Machine Coded Compact Genetic Algorithms 
for Real Parameter Optimization Problems." Alphanumeric Journal 8.1 (2020): 43-58.

Satman, Mehmet Hakan, and Emre Akadal. "Makine Kodlu Hibrit Kompakt Genetik Algoritmalar 
Optimizasyon Yöntemi", TR Patent 2018-GE-510,239    
"""
function bits(fs::Array{T,1})::Array{Int8,1} where {T<:Number}
    return map(x -> bits(x), fs) |> x -> vcat(x...)
end





"""
        floats(bitarray)

Extract float values using the bits in bitarray. 

    
# Arguments:
 - `bitarray::Array{Int, 1}`: An array of integers that are either 0s or 1s. 
 

# Output 
- `::Array{Float64, 1}`: Float values that are constructed using the bitarray.

# Example

```

julia> mybits = [0,0,1,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

julia> floats(mybits)
1-element Vector{Float64}:
 0.25

 julia> mybits = bits([3.14, 2.71]);

julia> floats(mybits)
2-element Vector{Float64}:
 3.140000104904175
 2.7100000381469727

```

# References
Satman, Mehmet Hakan, and Emre Akadal. "Machine Coded Compact Genetic Algorithms 
for Real Parameter Optimization Problems." Alphanumeric Journal 8.1 (2020): 43-58.

Satman, Mehmet Hakan, and Emre Akadal. "Makine Kodlu Hibrit Kompakt Genetik Algoritmalar 
Optimizasyon Yöntemi", TR Patent 2018-GE-510,239    
"""
function floats(bitarray::Array{T,1})::Array{Float64,1} where {T<:Integer}
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
