#
# GAPic: GAP image creator, for visualizing structures
#
# This file is a script which compiles the package manual.
#
if fail = LoadPackage("AutoDoc", "2016.02.16") then
    Error("AutoDoc version 2016.02.16 or newer is required.");
fi;

AutoDoc(rec(
    scaffold := rec(
        includes := [
            "_Chapter_Javascript.xml",
            "_Chapter_ExamplePolyhedra.xml",
            "_Chapter_Drawing_A_Graph.xml",
        ],
    ),
    gapdoc := rec(
        LaTeXOptions := rec(
            LateExtraPreamble := "\\usepackage{graphicx,amsfonts,tipa,makecell}",
        ),
    ),
));
