@testset "feature" begin

    io = IOBuffer()

    DS.render(io, DS.area(10, 20), style=[:bold, :blink], color=(255, 100, 0))
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
