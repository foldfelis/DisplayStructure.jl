@testset "feature" begin

    io = IOBuffer()

    line = DS.Line(20)
    DS.render(io, DS.DisplayRow(line))
    @test String(take!(io)) ==
        "────────────────────\e[0m"

    line = DS.DashLine(20)
    DS.render(io, DS.DisplayRow(line))
    @test String(take!(io)) ==
        "--------------------\e[0m"

    str =
        "\e[$(TERM_SIZE[1]);1H\e[1;1H" *
        "\e[s\e[38;2;255;100;0m\e[1m\e[5m┌──────────────────┐\e[0m\e[u\e[1B" *
        "\e[s\e[38;2;255;100;0m\e[1m\e[5m│                  │\e[0m\e[u\e[1B" *
        "\e[s\e[38;2;255;100;0m\e[1m\e[5m│                  │\e[0m\e[u\e[1B" *
        "\e[s\e[38;2;255;100;0m\e[1m\e[5m│                  │\e[0m\e[u\e[1B" *
        "\e[s\e[38;2;255;100;0m\e[1m\e[5m│                  │\e[0m\e[u\e[1B" *
        "\e[s\e[38;2;255;100;0m\e[1m\e[5m│                  │\e[0m\e[u\e[1B" *
        "\e[s\e[38;2;255;100;0m\e[1m\e[5m│                  │\e[0m\e[u\e[1B" *
        "\e[s\e[38;2;255;100;0m\e[1m\e[5m│                  │\e[0m\e[u\e[1B" *
        "\e[s\e[38;2;255;100;0m\e[1m\e[5m│                  │\e[0m\e[u\e[1B" *
        "\e[s\e[38;2;255;100;0m\e[1m\e[5m└──────────────────┘\e[0m\e[u\e[1B" *
        "\e[$(TERM_SIZE[1]);1H"
    rectangle = DS.Rectangle(10, 20)
    DS.render(io, DS.DisplayArray(rectangle), style=[:bold, :blink], color=(255, 100, 0))
    @test String(take!(io)) == str

    rectangle = DS.Rectangle((10, 20))
    DS.render(io, DS.DisplayArray(rectangle), style=[:bold, :blink], color=(255, 100, 0))
    @test String(take!(io)) == str

end
