using Crayons
using Terming
const T = Terming
using DisplayStructure
const DS = DisplayStructure

display =
    "######                                      \n" *
    "#     # #  ####  #####  #        ##   #   # \n" *
    "#     # # #      #    # #       #  #   # #  \n" *
    "#     # #  ####  #    # #      #    #   #   \n" *
    "#     # #      # #####  #      ######   #   \n" *
    "#     # # #    # #      #      #    #   #   \n" *
    "######  #  ####  #      ###### #    #   #    "

structure =
    "\t   #####                                                        \n" *
    "\t  #     # ##### #####  #    #  ####  ##### #    # #####  ###### \n" *
    "\t  #         #   #    # #    # #    #   #   #    # #    # #      \n" *
    "\t   #####    #   #    # #    # #        #   #    # #    # #####  \n" *
    "\t        #   #   #####  #    # #        #   #    # #####  #      \n" *
    "\t  #     #   #   #   #  #    # #    #   #   #    # #   #  #      \n" *
    "\t   #####    #   #    #  ####   ####    #    ####  #    # ######  "

function paint()
    h, w = size = (20, 75)
    T.displaysize(h, w)

    area = DS.DisplayArray(DS.Rectangle(h, w))

    logo = DS.DisplayArray(DS.Rectangle(4, 8))
    logo[2, 4] = Char(0x2B24)
    logo[3, 3] = Char(0x2B24)
    logo[3, 5] = Char(0x2B24)

    display_block = DS.DisplayArray(DS.Rectangle(7, 45))
    display_block[1:end, 1:end] = display

    structure_block = DS.DisplayArray(DS.Rectangle(7, 65))
    structure_block[1:end, 1:end] = structure

    T.buffered() do buffer
        T.cshow(false); T.clear()

        T.print(buffer, Crayon(foreground=(93, 173, 226)))
        DS.render(buffer, area, pos=(1, 1))

        T.print(buffer, Crayon(foreground=(149, 88, 178)))
        DS.render(buffer, logo, pos=(3, 64))

        T.print(buffer, Crayon(foreground=(205, 92, 92), bold=true))
        DS.render(buffer, display_block, pos=(3, 5))

        T.print(buffer, Crayon(foreground=(82, 190, 128)))
        DS.render(buffer, structure_block, pos=(12, 5))

        T.print(buffer, Crayon(reset = true))
    end

    readline()
    T.cmove_line_last()
    T.cshow(true)
    return
end

paint()
