export DisplayRow, render

struct DisplayRow
    size::Int
    background::Char
    content::Vector{Char}
end

function DisplayRow(len::Int; background=' ')
    isone(textwidth(background)) || (throw(
        "Invalid background character. " *
        "Text width of background character must be 1."
    ))

    return DisplayRow(len, background, fill(background, len))
end

Base.length(row::DisplayRow) = row.size

Base.lastindex(row::DisplayRow) = row.size

function get_element_index(row::DisplayRow, display_index::Int)
    (mapreduce(textwidth, +, row.content) < display_index) && (throw(BoundsError))

    accumulate_width = index = pre = post = 0
    for c in row.content
        width = textwidth(c)
        accumulate_width += width
        index += 1
        if accumulate_width >= display_index
            pre = display_index - (accumulate_width-width) - 1
            post = accumulate_width-display_index
            break
        end
    end

    return (i=index, pre=pre, post=post)
end

function Base.deleteat!(row::DisplayRow, display_index::Int)
    index = get_element_index(row, display_index)
    deleteat!(row.content, index.i)
    for i=1:(index.pre+index.post+1)
        insert!(row.content, index.i, row.background)
    end
end

function Base.setindex!(row::DisplayRow, c::Char, display_index::Int)
    start = display_index
    stop = display_index + textwidth(c) - 1

    i1, pre, _ = get_element_index(row, start)
    i2, _, post = get_element_index(row, stop)

    deleteat!(row.content, collect(i1:i2))

    for i=1:post insert!(row.content, i1, row.background) end
    insert!(row.content, i1, c)
    for i=1:pre insert!(row.content, i1, row.background) end
end

function Base.setindex!(row::DisplayRow, str::String, display_range::UnitRange{Int64})
    start, stop = display_range.start, display_range.stop
    (length(display_range) == textwidth(str)) || (throw(DimensionMismatch))

    i1, pre, _ = get_element_index(row, start)
    i2, _, post = get_element_index(row, stop)

    deleteat!(row.content, collect(i1:i2))

    for i=1:post insert!(row.content, i1, row.background) end
    for c in reverse(str) insert!(row.content, i1, c) end
    for i=1:pre insert!(row.content, i1, row.background) end
end

function render(io::IO, row::DisplayRow; style=Symbol[], color=(-1, -1, -1))
    println_style(io, row.content, style, color)
end
