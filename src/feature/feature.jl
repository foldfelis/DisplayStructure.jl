export Shape
export Line, DashLine, Rectangle

abstract type Shape end

struct Line <: Shape
    len::Int
    background::Char
end

Line(len::Int; background=' ') = Line(len, background)

function DisplayRow(line::Line)
    fill_char = Char(0x2500)

    return DisplayRow(
        line.len,
        line.background,
        fill(fill_char, line.len)
    )
end

struct DashLine <: Shape
    len::Int
    background::Char
end

DashLine(len::Int; background=' ') = DashLine(len, background)

function DisplayRow(line::DashLine)
    fill_char = '-'

    return DisplayRow(
        line.len,
        line.background,
        fill(fill_char, line.len)
    )
end

struct Rectangle <: Shape
    h::Int
    w::Int
    background::Char
    border::Bool
end

Rectangle(h::Int, w::Int; background=' ', border=true) = Rectangle(h, w, background, border)

function DisplayArray(rectangle::Rectangle)
    h, w, background = rectangle.h, rectangle.w, rectangle.background
    array = DisplayArray(h, w, background=background)
    if rectangle.border

        # top, bottom ─
        line = Line(w, background)
        array.content[1] = DisplayRow(line)
        array.content[end] = DisplayRow(line)

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
