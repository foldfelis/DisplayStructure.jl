using DisplayStructure
const DS = DisplayStructure
using Test

const TERM_SIZE = displaysize(stdout)

@testset "DisplayStructure.jl" begin

    include("util.jl")
    include("display_row.jl")
    include("display_array.jl")
    include("shape.jl")

end
