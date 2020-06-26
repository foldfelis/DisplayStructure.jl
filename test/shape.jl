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
        "\e[$(TERM_SIZE[1]);1H" *
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
        "\e[0m" *
        "\e[$(TERM_SIZE[1]);1H"

    rectangle = DS.Rectangle(10, 20)
    DS.@cursor_resetted io begin
        DS.@cursor_explored io begin
            DS.@styled io style color DS.render(io, DS.DisplayArray(rectangle))
        end
    end
    @test String(take!(io)) == str

    rectangle = DS.Rectangle((10, 20))
    DS.@cursor_resetted io begin
        DS.@cursor_explored io begin
            DS.@styled io style color DS.render(io, DS.DisplayArray(rectangle))
        end
    end
    @test String(take!(io)) == str

end
