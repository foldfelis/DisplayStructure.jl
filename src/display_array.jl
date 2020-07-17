export DisplayArray, render

struct DisplayArray
    size::Tuple{Int, Int}
    background::Char
    content::Vector{DisplayRow}
end

function DisplayArray(h, w; background=' ')
    (textwidth(background) != 1) && (throw(
        "Invalid background character. " *
        "Text width of background character must be 1."
    ))

    content = Array{DisplayRow}(undef, h)
    foreach(i->content[i]=DisplayRow(w, background=background), 1:h)

    return DisplayArray(
        (h, w),
        background,
        content
    )
end

function Base.show(io::IO, row::DisplayArray)
    Base.print(io, "DisplayArray(" *
        "size=$(size(row)), " *
        "background char=Char($(convert(UInt16, row.background)))" *
        ")")
end

Base.size(array::DisplayArray) = array.size

Base.lastindex(array::DisplayArray, d::Int) = size(array)[d]

function Base.setindex!(
    array::DisplayArray,
    c::Char,
    display_row::Int, display_col::Int
)
    array.content[display_row][display_col] = c
end

function Base.setindex!(
    array::DisplayArray,
    str::String,
    display_row_range::UnitRange{Int64}, display_col_range::UnitRange{Int64}
)
    split_str = split(str, '\n')
    length(split_str) == length(display_row_range) || throw(DimensionMismatch)
    (display_row_range.stop > size(array)[1]) && (throw(BoundsError))

    width = length(display_col_range)
    for (i, s) in zip(display_row_range, split_str)
        s = padding(s, width, background=array.background)
        array.content[i][display_col_range] = s
    end
end

function render(array::DisplayArray; pos=(-1, -1), stream=T.out_stream)
    (pos != (-1, -1)) && T.cmove(pos[1], pos[2], stream=stream)
    foreach(
        row->(
            T.csave(stream=stream);
            render(row, stream=stream);
            T.crestore(stream=stream);
            T.cmove_down(stream=stream)
        ),
        array.content
    )
end
