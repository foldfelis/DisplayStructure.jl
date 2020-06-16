export padding
export print_style
export clear, move_cursor
export move_cursor_up, move_cursor_down, move_cursor_right, move_cursor_left
export get_term_size

# +---------+
# | cursors |
# +---------+

clear(io::IO) = print(io, "\033[2J")

move_cursor(io::IO, y::Int, x::Int) = print(io, "\033[$(y);$(x)H")
move_cursor_up(io::IO, n::Int) = print(io, "\033[$(n)A")
move_cursor_down(io::IO, n::Int) = print(io, "\033[$(n)B")
move_cursor_right(io::IO, n::Int) = print(io, "\033[$(n)C")
move_cursor_left(io::IO, n::Int) = print(io, "\033[$(n)D")

function move_cursor2last_line(io::IO)
    y, _ = displaysize(stdout)
    print(io, "\033[$(y);1H")
end

save_cursor(io::IO) = print(io, "\033[s")
restore_cursor(io::IO) = print(io, "\033[u")

get_term_size() = displaysize(stdout) .- (1, 0)

# +------+
# | util |
# +------+

function padding(str::AbstractString, width::Int; background=' ')
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

function print_style(io::IO, content::Vector{String}, style::Vector{Symbol}, color::Tuple{Int, Int, Int})
    set_font_style(io, style, color)
    join(io, content)
    reset_font_style(io)
end

function print_style(io::IO, content::Vector{Char}, style::Vector{Symbol}, color::Tuple{Int, Int, Int})
    set_font_style(io, style, color)
    join(io, content)
    reset_font_style(io)
end

# function println_style(io::IO, content::Vector{String}, style::Vector{Symbol}, color::Tuple{Int, Int, Int})
#     set_font_style(io, style, color)
#     join(io, content)
#     println(io)
#     reset_font_style(io)
# end

# function println_style(io::IO, content::Vector{Char}, style::Vector{Symbol}, color::Tuple{Int, Int, Int})
#     set_font_style(io, style, color)
#     join(io, content)
#     println(io)
#     reset_font_style(io)
# end
