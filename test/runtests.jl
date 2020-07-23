using DisplayStructure
const DS = DisplayStructure
using Terming
const T = Terming
using Test

@testset "DisplayStructure.jl" begin

    T.set_term!(T.PseudoTerminal(
        Base.BufferStream(), Base.BufferStream(), Base.BufferStream()
    ))

    TERM_SIZE = T.displaysize()

    include("util.jl")
    include("display_row.jl")
    include("display_array.jl")
    include("shape.jl")

end
