#
# GAPic: GAP image creator, for visualizing structures
#
# This file is a script which compiles the package manual.
#

path := Directory("doc/lib/");;
main := "GAPic.xml";;
files := ["../../gap/GAPic.gd", "../../gap/GAPic.gi", 
            "../../gap/javascript/draw.gi", "../../gap/javascript/draw.gd"];;
bookname := "GAPic Manual";;
# doc := ComposedDocument("GAPDoc", path, main, files, true);;

MakeGAPDocDoc(path, main, files, bookname);

# create the build folder if not exists
Exec("mkdir -p doc/build");

# copy a version of the relevant files to the doc directory

Exec("cp doc/lib/manual.pdf doc/");
Exec("cp doc/lib/chap*.html doc/html-version");
# Exec("cp doc/lib/chap*.txt doc/");

# move the created files to the build folder
Exec("mv doc/lib/chap* doc/build");
Exec("mv doc/lib/GAPic.aux doc/build");
Exec("mv doc/lib/GAPic.bbl doc/build");
Exec("mv doc/lib/GAPic.blg doc/build");
Exec("mv doc/lib/GAPic.idx doc/build");
Exec("mv doc/lib/GAPic.ilg doc/build");
Exec("mv doc/lib/GAPic.ind doc/build");
Exec("mv doc/lib/GAPic.log doc/build");
Exec("mv doc/lib/GAPic.out doc/build");
Exec("mv doc/lib/GAPic.pnr doc/build");
Exec("mv doc/lib/GAPic.tex doc/build");
Exec("mv doc/lib/GAPic.toc doc/build");
Exec("mv doc/lib/manual.* doc/build");

quit;
