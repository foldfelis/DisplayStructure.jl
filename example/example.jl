using REPL
using DisplayStructure
const DS = DisplayStructure

read_next_char(io::IO) = Char(read(io, 1)[1])

function read_key(t)
    c = string(read_next_char(t.in_stream))

    stream_size = t.in_stream.buffer.size
    if stream_size > 1
        for i=1:stream_size-1
            c *= read_next_char(t.in_stream)
        end
    end

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
    a_h = 20; a_w = 100
    area = DS.DisplayArray(DS.Rectangle(a_h, a_w))
    a_color = (93, 173, 226)
    a_style = [:bold]

    str = "會動的字串"
    width = textwidth(str)
    label = DS.DisplayRow(width)
    l_color = (82, 190, 128)
    l_style = Symbol[]
    label[1:end] = str
    label_pos = [5, 5]

    # prepare terminal
    REPL.Terminals.raw!(t, true)
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
        DS.render(buffer, label, pos=Tuple(label_pos))
        DS.reset_style(buffer)

        content = take!(buffer)
        write(io, content)

        # read char
        c = read_key(t)
        if c == "\e"
            is_running = false
        elseif c == "w"
            label_pos[1] -= 1
        elseif c == "s"
            label_pos[1] += 1
        elseif c == "a"
            label_pos[2] -= 1
        elseif c == "d"
            label_pos[2] += 1
        end

        # adj label_pos value
        (label_pos[1] < 2) && (label_pos[1] = 2)
        (label_pos[1]+1 > a_h) && (label_pos[1] = a_h-1)
        (label_pos[2] < 2) && (label_pos[2] = 2)
        (label_pos[2]+width > a_w) && (label_pos[2] = a_w-width)
    end

    # reset terminal
    REPL.Terminals.raw!(t, false)
    DS.move_cursor2last_line(io)
    DS.show_cursor(io, true)
end

run_app()
