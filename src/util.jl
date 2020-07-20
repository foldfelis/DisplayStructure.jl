export padding

function padding(str::AbstractString, width::Int; background=' ')
    str_width = textwidth(str)
    (width < str_width) && (throw(BoundsError))

    str *= background^(width-str_width)

    return str
end
