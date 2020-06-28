@testset "feature" begin

    io = IOBuffer()

    line = DS.Line(20)
    DS.render(io, DS.DisplayRow(line))
    @test String(take!(io)) ==
        "────────────────────"

    line = DS.DashLine(20)
    DS.render(io, DS.DisplayRow(line))
    @test String(take!(io)) ==
        "--------------------"

    style=[:bold, :blink]
    R, G, B = color=(255, 100, 0)
    str =
        "\e[38;2;$(R);$(G);$(B)m\e[1m\e[5m" *
        "\e[s┌──────────────────┐\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s└──────────────────┘\e[u\e[1B" *
        "\e[0m"

    rectangle = DS.Rectangle(10, 20)

    DS.set_style(io, style, color)
    DS.render(io, DS.DisplayArray(rectangle))
    DS.reset_style(io)

    @test String(take!(io)) == str

    rectangle = DS.Rectangle((10, 20))

    DS.set_style(io, style, color)
    DS.render(io, DS.DisplayArray(rectangle))
    DS.reset_style(io)

    @test String(take!(io)) == str

end
