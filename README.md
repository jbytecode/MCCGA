## Warning: This algorithm is included in the Metaheuristics.jl package; please use the version available in that package.

__________________________________________


# MCCGA
Machine-coded Compact Genetic Algorithms for real-valued optimization problems in Julia

## Installation

```julia
] add https://github.com/jbytecode/MCCGA.git
```

## Updating the package

```julia
] update
``` 

## Basic Usage

```julia
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

println(result)
```

## Citation
- Satman, M. H. & Akadal, E. (2020). Machine Coded Compact Genetic Algorithms for Real Parameter Optimization Problems . Alphanumeric Journal , 8 (1) , 43-58 . DOI: 10.17093/alphanumeric.576919

- Mehmet Hakan Satman, Emre Akadal, Makine Kodlu Hibrit Kompakt Genetik Algoritmalar Optimizasyon Yöntemi, Patent, TR, 2022/01, 2018-GE-510239
