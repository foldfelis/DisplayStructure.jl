export
    DisplayObj,
    Label,
    Panel

"""
DisplayObj

the inheritance of DisplayObj must have the following fields:
* `content::DisplayRow` or `content::DisplayArray`
* `style::Crayon`
* `pos::Vector{Int}` or `pos::Tuple{Int, Int}`
"""
abstract type DisplayObj end

function render(stream::IO, display_obj::DisplayObj)
    T.print(stream, display_obj.style);
    render(stream, display_obj.content, pos=display_obj.pos);
    T.print(stream, string(Crayon(reset=true)))
end

render(display_obj::DisplayObj) = render(T.out_stream, display_obj)

struct Label <: DisplayObj
    content::DisplayRow
    style::Crayon
    pos::Vector{Int}
end

function Label(
    str::String,
    pos::Vector{Int};
    style::Crayon=Crayon(foreground=:green)
)
    content = DisplayRow(textwidth(str))
    content[1:end] = str

    return Label(content, style, pos)
end

struct Panel <: DisplayObj
    content::DisplayArray
    style::Crayon
    pos::Vector{Int}
end

function Panel(
    str::String,
    size::Vector{Int},
    pos::Vector{Int};
    style::Crayon=Crayon(foreground=:blue, bold=true)
)
    h, w = size
    content = DisplayArray(Rectangle(h, w))
    str_width = textwidth(str)
    (w-str_width > 2) && (content[1, 2:(str_width+1)] = str)

    return Panel(content, style, pos)
end
