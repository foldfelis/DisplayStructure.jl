export DisplayArray, render

struct DisplayArray
    size::Tuple{Int, Int}
    background::Char
    context::Vector{DisplayRow}
end

function DisplayArray(h, w; background=' ')
    (textwidth(background) != 1) && (throw("Bad background char"))

    context = DisplayRow[]
    for i=1:h
        push!(context, DisplayRow(w, background=background))
    end

    return DisplayArray(
        (h, w),
        background,
        context
    )
end

Base.size(array::DisplayArray) = array.size

function Base.setindex!(
    array::DisplayArray,
    c::Char,
    display_row::Int, display_col::Int
)
    array.context[display_row][display_col] = c
end

function Base.setindex!(
    array::DisplayArray,
    str::String,
    display_row_range::UnitRange{Int64}, display_col_range::UnitRange{Int64}
)
    split_str = split(str, '\n')
    start, stop = display_row_range.start, display_row_range.stop
    (stop != start + length(split_str) - 1) && (throw(DimensionMismatch))
    (stop > size(array)[1]) && (throw(BoundsError))

    for (i, s) in enumerate(split_str)
        width = display_col_range.stop-display_col_range.start+1
        s = pad2width(string(s), width, background=array.background)
        array.context[start+i-1][display_col_range] = s
    end
end

render(io::IO, array::DisplayArray) = (for row in array.context render(io, row) end)
