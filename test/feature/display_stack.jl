@testset "display_obj.jl" begin
    ds = DS.DisplayStack()

    panel = DS.Panel(" 我是標題 ", [10, 30], [3, 5])
    label1 = DS.Label("我是字串1", [5, 10])
    push!(ds, :panel=>panel)
    push!(ds, :label=>label1)
    render(ds)
    @test T.read_stream(T.out_stream) ==
        "\e[34;1m\e[3;5H" *
        "\e[s┌ 我是標題 ──────────────────┐\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s└────────────────────────────┘\e[u\e[1B" *
        "\e[0m" *
        "\e[32m\e[5;10H我是字串1\e[0m" *
        "\e[24;1H"
    @test ds[:panel] == panel
    @test ds[:label] == label1

    label2 = DS.Label("我是字串2", [6, 11])
    push!(ds, label2)
    render(ds)
    @test T.read_stream(T.out_stream) ==
        "\e[34;1m\e[3;5H" *
        "\e[s┌ 我是標題 ──────────────────┐\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s│                            │\e[u\e[1B" *
        "\e[s└────────────────────────────┘\e[u\e[1B" *
        "\e[0m" *
        "\e[32m\e[5;10H我是字串1\e[0m" *
        "\e[32m\e[6;11H我是字串2\e[0m" *
        "\e[24;1H"
end
