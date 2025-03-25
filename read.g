#
# GAPic: GAP image creator, for visualizing structures
#
# Reading the implementation part of the package.
#
ReadPackage( "GAPic", "gap/GAPic.gi");
ReadPackage( "GAPic", "gap/io.gi");

#if not IsBound(GAPInfo.PackageExtensionsLoaded) then
    ReadPackage( "GAPic", "gap/javascript/examples_polyhedra.gi");
    ReadPackage( "GAPic", "gap/javascript/draw.gi");
    ReadPackage( "GAPic", "gap/tikz/drawing.gi");
#fi;
