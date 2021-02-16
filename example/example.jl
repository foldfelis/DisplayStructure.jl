using DisplayStructure
const DS = DisplayStructure
using Terming
const T = Terming

##### Views #####

function gen_views(h, w, title, str)
    display_stack =  DS.DisplayStack()
    push!(display_stack, :form => DS.Panel(title, [h, w], [1, 1]))
    push!(display_stack, :str => DS.Label(str, [5, 5]))

    return display_stack
end

##### Models #####

abstract type Model end

struct MovableStr <: Model
    reachable_size::Tuple{UnitRange{Int64}, UnitRange{Int64}}
    pos::Vector{Int}
end

function MovableStr(
    y_range::UnitRange{Int64},
    x_range::UnitRange{Int64}
)
    return MovableStr((y_range, x_range),[5, 5])
end

function move(str::MovableStr, direction::Symbol)
    if direction === :up
        new_y = str.pos[1] - 1
        (new_y in str.reachable_size[1]) && (str.pos[1] = new_y; return true)
    elseif direction === :down
        new_y = str.pos[1] + 1
        (new_y in str.reachable_size[1]) && (str.pos[1] = new_y; return true)
    elseif direction === :right
        new_x = str.pos[2] + 1
        (new_x in str.reachable_size[2]) && (str.pos[2] = new_x; return true)
    elseif direction === :left
        new_x = str.pos[2] - 1
        (new_x in str.reachable_size[2]) && (str.pos[2] = new_x; return true)
    end

    return false
end

##### Controls #####

function init_term()
    T.raw!(true)
    T.alt_screen(true)
    T.cshow(false)
    T.clear()
end

function reset_term()
    T.raw!(false)
    T.alt_screen(false)
    T.cshow(true)
end

struct App
    views::DisplayStack
    model::Model
end

function App()
    h, w = T.displaysize()
    title = " Title "
    str = "會動的字串"

    return App(
        gen_views(h, w, title, str),
        MovableStr(2:(h-1), 2:(w-1-textwidth(str)+1))
    )
end

render(app::App) = DS.render(app.views)

function update(app::App)
    app.views[:str].pos .= app.model.pos
    render(app)
end

function handle_quit(::App)
    keep_running = false
    T.cmove_line_last()
    T.println("\nShutting down")
    return keep_running
end

function handle_event(app::App)
    is_running = true
    while is_running
        sequence = T.read_stream()
        if sequence == "\e"
            is_running = handle_quit(app)
        elseif sequence == "w"
            move(app.model, :up) && update(app)
        elseif sequence == "s"
            move(app.model, :down) && update(app)
        elseif sequence == "d"
            move(app.model, :right) && update(app)
        elseif sequence == "a"
            move(app.model, :left) && update(app)
        end
    end
end

function Base.run(app::App)
    init_term()
    render(app)
    handle_event(app)
    reset_term()
    return
end

##### Main #####

run(App())
