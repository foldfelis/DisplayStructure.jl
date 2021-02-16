@testset "display_obj.jl" begin
    label = DS.Label("我是字串", [3, 5])
    DS.render(label)
    @test T.read_stream(T.out_stream) == "\e[32m\e[3;5H我是字串\e[0m"

    label = DS.Label("我是字串", [3, 5], style=Crayon(foreground=:blue, bold=true))
    DS.render(label)
    @test T.read_stream(T.out_stream) == "\e[34;1m\e[3;5H我是字串\e[0m"

    panel = DS.Panel(" 我是標題 ", [3, 20], [3, 5])
    DS.render(panel)
    @test T.read_stream(T.out_stream) ==
        "\e[34;1m\e[3;5H" *
        "\e[s┌ 我是標題 ────────┐\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s└──────────────────┘\e[u\e[1B" *
        "\e[0m"

    panel = DS.Panel(" 我是標題 ", [3, 20], [3, 5], style=Crayon(foreground=:green))
    DS.render(panel)
    @test T.read_stream(T.out_stream) ==
        "\e[32m\e[3;5H" *
        "\e[s┌ 我是標題 ────────┐\e[u\e[1B" *
        "\e[s│                  │\e[u\e[1B" *
        "\e[s└──────────────────┘\e[u\e[1B" *
        "\e[0m"

    panel = DS.Panel(" 我是標題 ", [3, 10], [3, 5])
    DS.render(panel)
    @test T.read_stream(T.out_stream) ==
        "\e[34;1m\e[3;5H" *
        "\e[s┌────────┐\e[u\e[1B" *
        "\e[s│        │\e[u\e[1B" *
        "\e[s└────────┘\e[u\e[1B" *
        "\e[0m"
end
