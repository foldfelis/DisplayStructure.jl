@testset "Util" begin

    str = "This is a 寬度不一的 Char array."
    str = DS.padding(str, 50)
    @test textwidth(str) == 50

    str = ""
    str = DS.padding(str, 50)
    @test textwidth(str) == 50

    str = "apple\norange"
    str = DS.padding_vertical(str, 3)
    @test str == "apple\norange\n"

end
