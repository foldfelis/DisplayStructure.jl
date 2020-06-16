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
    print(io, "DisplayArray(" *
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

function render(io::IO, array::DisplayArray; pos=(-1, -1), style=Symbol[], color=(-1, -1, -1))
    move_cursor2last_line(io)
    if pos != (-1, -1)
        move_cursor(io, pos[1], pos[2])
    else
        move_cursor(io, 1, 1)
    end
    foreach(
        row->(
            save_cursor(io);
            render(io, row, style=style, color=color);
            restore_cursor(io);
            move_cursor_down(io, 1)
        ),
        array.content
    )
    move_cursor2last_line(io)
end
