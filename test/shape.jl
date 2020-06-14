@testset "feature" begin

    io = IOBuffer()

    line = DS.Line(20)
    DS.render(io, DS.DisplayRow(line))
    @test String(take!(io)) ==
        "────────────────────\n\e[0m"

    line = DS.DashLine(20)
    DS.render(io, DS.DisplayRow(line))
    @test String(take!(io)) ==
        "--------------------\n\e[0m"

    rectangle = DS.Rectangle(10, 20)
    DS.render(io, DS.DisplayArray(rectangle), style=[:bold, :blink], color=(255, 100, 0))
    @test String(take!(io)) ==
        "\e[38;2;255;100;0m\e[1m\e[5m┌──────────────────┐\n\e[0m" *
        "\e[38;2;255;100;0m\e[1m\e[5m│                  │\n\e[0m" *
        "\e[38;2;255;100;0m\e[1m\e[5m│                  │\n\e[0m" *
        "\e[38;2;255;100;0m\e[1m\e[5m│                  │\n\e[0m" *
        "\e[38;2;255;100;0m\e[1m\e[5m│                  │\n\e[0m" *
        "\e[38;2;255;100;0m\e[1m\e[5m│                  │\n\e[0m" *
        "\e[38;2;255;100;0m\e[1m\e[5m│                  │\n\e[0m" *
        "\e[38;2;255;100;0m\e[1m\e[5m│                  │\n\e[0m" *
        "\e[38;2;255;100;0m\e[1m\e[5m│                  │\n\e[0m" *
        "\e[38;2;255;100;0m\e[1m\e[5m└──────────────────┘\n\e[0m"

end
