# tests if a file is generated after calling the basic example from the quick start in the manual

gap> tmpdir := DirectoryTemporary();;
gap> ChangeDirectoryCurrent(Filename(tmpdir, ""));
true
gap> oct := Octahedron();;
gap> verticesPositions := [[ 0, 0, Sqrt(2.) ], [ 1, 1, 0 ], [ 1, -1, 0 ], [ -1, -1, 0 ], [ -1, 1, 0 ], [ 0, 0, -Sqrt(2.) ] ];;
gap> printRecord := SetVertexCoordinates3D(oct, verticesPositions, rec());;
gap> DrawComplexToJavaScript(oct, "octahedron.html", printRecord);;
gap> not (Filename([tmpdir], "octahedron.html") = fail);
true