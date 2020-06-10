export line, area

line(len::Int; background=' ') = DisplayRow(len, background, fill(Char(0x2500), len))

function area(h::Int, w::Int; background=' ', border=true)
    array = DisplayArray(h, w, background=background)
    if border

        # top, bottom ─
        array.context[1] = line(w, background=background)
        array.context[end] = line(w, background=background)

        # side │
        for i=2:(h-1) array[i, 1] = Char(0x2502) end
        for i=2:(h-1) array[i, end] = Char(0x2502) end

        # corner
        array[1, 1] = Char(0x250C) # ┌
        array[1, end] = Char(0x2510) # ┐
        array[end, 1] = Char(0x2514) # └
        array[end, end] = Char(0x2518) # ┘
    end

    return array
end
