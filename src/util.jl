export pad2width
export print_style, println_style

# +------+
# | util |
# +------+

function pad2width(str::String, width::Int; background=' ')
    str_width = textwidth(str)
    (width < str_width) && (throw(BoundsError))

    str *= background^(width-str_width)

    return str
end

# +------------+
# | font style |
# +------------+

function set_font_style(io::IO, style::Vector{Symbol}, color::Tuple{Int, Int, Int})
    R, G, B = color
    !(R==G==B==-1) && (print(io, "\033[38;2;$(R);$(G);$(B)m"))
    (:bold in style) && (print(io, "\033[1m"))
    (:underline in style) && (print(io, "\033[4m"))
    (:blink in style) && (print(io, "\033[5m"))
    (:reverse in style) && (print(io, "\033[7m"))
    (:hidden in style) && (print(io, "\033[8m"))
end

reset_font_style(io::IO) = print(io, "\033[0m")

function print_style(io::IO, context::String, style::Vector{Symbol}, color::Tuple{Int, Int, Int})
    set_font_style(io, style, color)
    print(io, context)
    reset_font_style(io)
end

function println_style(io::IO, context::String, style::Vector{Symbol}, color::Tuple{Int, Int, Int})
    set_font_style(io, style, color)
    println(io, context)
    reset_font_style(io)
end
