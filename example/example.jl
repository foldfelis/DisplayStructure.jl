using REPL
using DisplayStructure
const DS = DisplayStructure

read_next_char(io::IO) = Char(read(io, 1)[1])

function read_key(t)
    REPL.Terminals.raw!(t, true)
    c = string(read_next_char(t.in_stream))

    stream_size = t.in_stream.buffer.size
    if stream_size > 1
        for i=1:stream_size-1
            c *= read_next_char(t.in_stream)
        end
    end

    REPL.Terminals.raw!(t, false)

    return c
end

function run_app(
    t=REPL.Terminals.TTYTerminal(
        get(ENV, "TERM", Sys.iswindows() ? "" : "dumb"),
        stdin, stdout, stderr
    )
)
    # const
    io = stdout

    # design
    area = DS.DisplayArray(DS.Rectangle(20, 100))
    a_color = (93, 173, 226)
    a_style = [:bold]

    str = "會動的字串"
    label = DS.DisplayRow(textwidth(str))
    l_color = (82, 190, 128)
    l_style = Symbol[]
    label[1:end] = str
    label_pos = (5, 5)

    # prepare terminal
    DS.show_cursor(io, false)
    DS.clear(io)

    # main loop
    is_running = true
    while is_running
        # render
        buffer = IOBuffer()

        DS.set_style(buffer, a_style, a_color)
        DS.render(buffer, area, pos=(1, 1))
        DS.reset_style(buffer)

        DS.set_style(buffer, l_style, l_color)
        DS.render(buffer, label, pos=label_pos)
        DS.reset_style(buffer)

        content = String(take!(buffer))
        print(io, content)

        # read char
        c = read_key(t)
        if c == "\e"
            is_running = false
        elseif c == "w"
            label_pos = label_pos .- (1, 0)
        elseif c == "s"
            label_pos = label_pos .+ (1, 0)
        elseif c == "a"
            label_pos = label_pos .- (0, 1)
        elseif c == "d"
            label_pos = label_pos .+ (0, 1)
        end
    end

    # reset terminal
    DS.move_cursor2last_line(io)
    DS.show_cursor(io, true)
end

run_app()
