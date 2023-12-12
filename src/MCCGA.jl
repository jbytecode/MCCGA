module MCCGA

import Optim
import Statistics

export Functions


export bits
export floats
export initialprobs
export sample
export isfeasible
export mccga



include("stats.jl")
include("bitworks.jl")
include("thealgorithm.jl")
include("funcset.jl")

end # module
