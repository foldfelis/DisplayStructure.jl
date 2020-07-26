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
    str::AbstractString,
    display_row::Int, display_col_range::UnitRange{Int64}
)
    array.content[display_row][display_col_range] = str
end

function Base.setindex!(
    array::DisplayArray,
    str::AbstractString,
    display_row_range::UnitRange{Int64}, display_col_range::UnitRange{Int64}
)
    str = padding_vertical(str, length(display_row_range))
    split_str = split(str, '\n')

    for (i, s) in zip(display_row_range, split_str)
        array[i, display_col_range] = s
    end
end

function Base.setindex!(
    array::DisplayArray,
    str::AbstractString,
    display_row_range::UnitRange{Int64}, display_col::Int
)
    str = padding_vertical(str, length(display_row_range))
    split_str = split(str, '\n')

    for (i, s) in zip(display_row_range, split_str)
        (length(s) > 1) && throw(BoundsError)
        array[i, display_col:(display_col+textwidth(s))] = s
    end
end

function render(stream::IO, array::DisplayArray; pos=(-1, -1))
    T.buffered(stream, array, pos) do buffer, array, pos
        (pos != (-1, -1)) && T.cmove(buffer, pos[1], pos[2])
        foreach(
            row->(
                T.csave(buffer);
                render(buffer, row);
                T.crestore(buffer);
                T.cmove_down(buffer)
            ),
            array.content
        )
    end
end

render(array::DisplayArray; pos=(-1, -1)) = render(T.out_stream, array, pos=pos)
