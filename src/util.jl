export padding

function padding(str::AbstractString, width::Int; background=' ')
    str_width = textwidth(str)
    (width < str_width) && (throw(BoundsError))

    str *= background^(width-str_width)

    return str
end

function padding_vertical(str::String, height::Int)
    str_height = length(findall("\n", str))+1
    (height < str_height) && (throw(BoundsError))

    str *= '\n'^(height-str_height)

    return str
end
