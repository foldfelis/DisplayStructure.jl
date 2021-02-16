using DataStructures: OrderedDict

export
    DisplayStack,
    render

struct DisplayStack
    elements::OrderedDict{Symbol, DisplayObj}
end

function DisplayStack()
    return DisplayStack(OrderedDict{Symbol, DisplayObj}())
end

function Base.push!(stack::DisplayStack, e::Pair)
    push!(stack.elements, e)
end

function Base.getindex(stack::DisplayStack, key::Symbol)
    return stack.elements[key]
end

function render(stream::IO, stack::DisplayStack)
    T.buffered(stream) do buffer
        foreach(e->render(buffer, e.second), stack.elements)
        T.cmove_line_last(buffer)
    end
end

render(stack::DisplayStack) = render(T.out_stream, stack)
