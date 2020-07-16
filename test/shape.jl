@testset "feature" begin

    line = DS.Line(20)
    DS.render(DS.DisplayRow(line))
    @test T.read_strem(stream=T.out_stream)  ==
        "────────────────────"

    line = DS.DashLine(20)
    DS.render(DS.DisplayRow(line))
    @test T.read_strem(stream=T.out_stream)  ==
        "--------------------"

    str =
        "\e[s┌──────────────────┐\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s└──────────────────┘\e[u\e[1B"

    rectangle = DS.Rectangle(10, 20)
    DS.render(DS.DisplayArray(rectangle))
    @test T.read_strem(stream=T.out_stream)  == str

    rectangle = DS.Rectangle((10, 20))
    DS.render(DS.DisplayArray(rectangle))
    @test T.read_strem(stream=T.out_stream)  == str

end
