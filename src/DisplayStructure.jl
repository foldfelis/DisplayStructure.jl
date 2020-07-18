module DisplayStructure

    using Terming
    const T = Terming

    include("util.jl")
    include("display_row.jl")
    include("display_array.jl")
    include("shape.jl")

    __init__() = T.mark_bufferable(:render)
end
