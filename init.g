#
# GAPic: GAP image creator, for visualizing structures
#
# Reading the declaration part of the package.
#

ReadPackage( "GAPic", "gap/GAPic.gd");

#if not IsBound(GAPInfo.PackageExtensionsLoaded) then
    ReadPackage( "GAPic", "gap/javascript/examples_polyhedra.gd");
    ReadPackage( "GAPic", "gap/javascript/draw.gd");
    ReadPackage( "GAPic", "gap/tikz/drawing.gd");
#fi;
