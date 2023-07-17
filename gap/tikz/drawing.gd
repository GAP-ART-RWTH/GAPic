
if not __SIMPLICIAL_MANUAL_MODE then
    Error("The file 'drawing.gd' should only be read to generate the manual.");
fi;

oct := Octahedron();;
DrawSurfaceToTikz( oct, "Octahedron_example" );;

pr := DrawSurfaceToTikz( oct, "Octahedron_example" );;
pr.edgeLabelsActive := false;;
pr.vertexColours := "green";;

DrawSurfaceToTikz( oct, "Octahedron_recoloured.tex", pr );;

pr.compileLaTeX := true;;

pr.scale;

pr.scale := 3;;
pr.faceLabels := ["I","II","III","IV","V","VI","VII","VIII"];;
DrawSurfaceToTikz( oct, "Octahedron_customized.tex", pr );;

pr.edgeLabelsActive := true;;
DrawSurfaceToTikz( oct, "Octahedron_edgeLabels", pr );;
pr.edgeLengths;

pr.edgeLengths := [ 1, 1, 1, 1, 1.5, 1.5, 1, 1.5, 1, 1.5, 1, 1 ];;

Unbind( pr.angles );
DrawSurfaceToTikz( oct, "Octahedron_reshaped", pr );

cube := PolygonalComplexByDownwardIncidence([ [ 1, 2 ], [ 2, 3 ], [ 3, 4 ], 
[ 1, 4 ], [ 2, 7 ], , [ 3, 8 ], [ 4, 9 ], [ 1, 6 ], [ 7, 8 ] ,[ 8, 9 ],
[ 6, 9 ], [ 6, 7 ] ],[ [ 1, 2, 3, 4 ], ,[ 1, 5, 9, 13 ], [ 2, 5, 7, 10 ], 
[ 4, 8, 9, 12 ], [ 3, 7, 8, 11 ], [ 10, 11, 12, 13 ] ]);;
DrawSurfaceToTikz(cube, "Cube_example");;

pr := rec( vertexColours :=
   ["red", "blue", "green",, "pink", "black!20!yellow"] );;
DrawSurfaceToTikz(cube, "Cube_vertexColouredLocal", pr);;

pr := rec( vertexColours := "blue!60!white" );;
DrawSurfaceToTikz(cube, "Cube_vertexColouredGlobal", pr);;

pr := rec( edgeColours :=
   [,,,,"red", "purple", "blue", "green!80!black"] );;
DrawSurfaceToTikz( cube, "Cube_edgeColouredLocal", pr );;

pr := rec( edgeColours := "red" );;
DrawSurfaceToTikz( cube, "Cube_edgeColouredGlobal", pr );;

pr := rec( faceColours := ["\\faceColorY", "\\faceColorB", 
    "\\faceColorC", "\\faceColorR", "\\faceColorG", "\\faceColorO"] );;
DrawSurfaceToTikz( cube, "Cube_faceColouredLocal", pr );;

pr := rec( faceColours := "olive!20!white" );;
DrawSurfaceToTikz( cube, "Cube_faceColouredGlobal", pr );;

tetra := SimplicialSurfaceByDownwardIncidence([ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ], 
[ 3, 4 ], ,[ 3, 5 ], [ 4, 5 ] ], [ [ 1, 2, 4 ], [ 1, 3, 6 ], ,
[ 4, 6, 7 ], [ 2, 3, 7 ] ]);;
DrawSurfaceToTikz( tetra, "Tetrahedron_example" );;

pr := rec( vertexLabelsActive := false );;
DrawSurfaceToTikz( tetra, "Tetrahedron_vertexLabelsOff", pr);;

pr := rec( vertexLabels := ["V_1", "X", , "++"] );;
DrawSurfaceToTikz( tetra, "Tetrahedron_vertexLabels", pr);;

pr := rec( edgeLabelsActive := false );;
DrawSurfaceToTikz( tetra, "Tetrahedron_edgeLabelsOff", pr);;

pr := rec( edgeLabels := ["a", , "e_3", , "?"] );;
DrawSurfaceToTikz( tetra, "Tetrahedron_edgeLabels", pr);;

pr := rec( faceLabelsActive := false );;
DrawSurfaceToTikz( tetra, "Tetrahedron_faceLabelsOff", pr);;

pr := rec( faceLabels := ["I", "f_2", "42", ,] );;
DrawSurfaceToTikz( tetra, "Tetrahedron_faceLabels", pr);;

tetra := SimplicialSurfaceByDownwardIncidence([ [ 1, 3 ], [ 1, 4 ], [ 1, 5 ],
[ 3, 4 ], ,[ 3, 5 ], [ 4, 5 ] ], [ [ 1, 2, 4 ], [ 1, 3, 6 ], ,
[ 4, 6, 7 ], [ 2, 3, 7 ] ]);;
DrawSurfaceToTikz( tetra, "Tetrahedron_example" );;

pr := rec( scale := 1.5 );;
DrawSurfaceToTikz( tetra, "Tetrahedron_rescaled", pr);;

pr := rec( edgeLengths := [1.5, 1.5, 1, 1.5, 2, 1, 1] );;
DrawSurfaceToTikz( tetra, "Tetrahedron_edgeLengths", pr);;

rectangle:=PolygonalSurfaceByVerticesInFaces([[1,2,3,4]]);;
pr:=DrawSurfaceToTikz( rectangle, "Rectangle_example" );;

pr.angles:=[[[ 0.866025, 0.5 ],[ 0.866025, -0.5 ],[ 0.866025, 0.5 ],
[ 0.866025, -0.5 ]]];;
DrawSurfaceToTikz( rectangle, "Rectangle_angles", pr);;

butterfly := TriangularComplexByVerticesInFaces( 7, 4, [ [1,2,3], 
[1,6,7], [1,3,4], [1,5,6] ]);;
pr := DrawSurfaceToTikz(butterfly,"Butterfly");;

pr := rec( startingFaces := [3,4] );;
DrawSurfaceToTikz( butterfly, "Butterfly_startingFaces", pr);;

doubleSixGon:=SimplicialSurfaceByUmbrellaDescriptor([(1,2,3,4,5,6),
(7,8,9,10,11,12),(1,2,8,7),(2,3,9,8),(3,4,10,9),(4,5,11,10),(5,6,12,11),
(6,1,7,12)]);;
pr:=DrawSurfaceToTikz(doubleSixGon,"DoubleSixGon");;

pr!.edgeDrawOrder:=[[1,2,10,8,6,4,7,15,13,14,18,17,16]];;
DrawSurfaceToTikz(doubleSixGon,"DoubleSixGon_edgeDraw",pr);;

oct := Octahedron();;
DrawFacegraphToTikz( oct, "facephgraph_oct_example" );;

pr := DrawFacegraphToTikz( oct, "facegraph_oct" );;

pr.edgeLabelsActive := true;;

pr.vertexLabelsActive := true;;

pr.edgeColours := "green";;

pr.faceCoordinates2D[1]:=[-2.,4.];;

pr.faceCoordinates2D[1]:=[0.,0.];;pr.faceCoordinates2D[4]:=[4.,0.];;
pr.faceCoordinates2D[3]:=[4.,1.];;pr.faceCoordinates2D[7]:=[4.,2.];;
pr.faceCoordinates2D[2]:=[0.,1.];;pr.faceCoordinates2D[6]:=[0.,2.];;
pr.faceCoordinates2D[5]:=[0.,3.];;pr.faceCoordinates2D[8]:=[4.,3.];;

tetra :=SimplicialSurfaceByVerticesInFaces([[1,2,3],[1,2,4],
[1,3,4],[2,3,4]]);;
DrawFacegraphToTikz(tetra, "facegraph_tetrahedron");;

pr := rec( faceColours :=
   ["blue", "green",, "black!20!yellow"] );;
DrawFacegraphToTikz(tetra, 
"facegraph_tetrahedron_vertexColouredLocal", pr);;

pr := rec( vertexColours := "blue!60!white" );;
DrawFacegraphToTikz(tetra, 
"facegraph_tetrahedron_vertexColouredGlobal.tex",pr);;

pr := rec( edgeColours :=
   [,,"red","purple","blue","green!80!black"] );;
DrawFacegraphToTikz(tetra,
"facegraph_tetrahedron_edgeColouredLocal.tex", pr);;

pr := rec( edgeColours := "red" );;
DrawFacegraphToTikz( tetra, 
"facegraph_tetrahedron_edgeColouredGlobal.tex", pr );;

double6Gon := SimplicialSurfaceByVerticesInFaces([[1,2,3],[1,3,4],[1,4,5],
[1,5,6],[1,6,7],[1,2,7],[2,3,8],[3,4,8],[4,5,8],[5,6,8],[6,7,8],[2,7,8]]);;

DrawFacegraphToTikz( double6Gon, "facegraph_Double6Gon.tex" );;

pr := rec( vertexLabelsActive := true);;
DrawFacegraphToTikz( double6Gon,"facegraph_Double6Gon_VertexLabelsOn" , pr);;

pr := rec( vertexLabels := ["V_1", "X", , "++"] );;
DrawFacegraphToTikz( double6Gon, "facegraph_Double6Gon_vertexLabels", pr);;

pr := rec( edgeLabelsActive := true  );;
DrawFacegraphToTikz( double6Gon, "facegraph_Double6Gon_EdgeLabelsOn", pr);;

pr := rec( edgeLabels := ["a", , "e_3", , "?"] );;
DrawFacegraphToTikz( double6Gon, "facegraph_Double6Gon_EdgeLabels", pr);;

pr := rec( faceLabelsActive := false );;
DrawFacegraphToTikz( double6Gon, "facegraph_Double6Gon_FaceLabelsOff", pr);;

pr := rec( faceLabels := ["I", "f_2", "42", ,] );;
DrawFacegraphToTikz( double6Gon, "facegraph_Double6Gon_FaceLabels", pr);;

oct:=Octahedron();;
DrawFacegraphToTikz( oct, "facegraph_oct" );;

pr := rec( scale := 1.5 );;
DrawFacegraphToTikz( tetra, "facegraph_oct_rescaled", pr);;

tetra :=SimplicialSurfaceByVerticesInFaces([[1,2,3],[1,2,4],
[1,3,4],[2,3,4]]);;
DrawFacegraphToTikz(tetra, "facegraph_tetrahedron");;

pr := rec( faceCoordinates2D:=[[0.,0.],[4.,0.],[4.,4.],[0.,4.]]);;
DrawFacegraphToTikz(tetra, 
"facegraph_tetrahedron_Coordinates", pr);;

oct:=Octahedron();
DrawFacegraphToTikz( oct, "facegraph_Octahedron.tex" );;

pr := rec( geodesicActive := true);;
DrawFacegraphToTikz( oct,
"facegraph_octGeodesics.tex" , pr);;

double6Gon := SimplicialSurfaceByVerticesInFaces([[1,2,3],[1,3,4],[1,4,5],
[1,5,6],[1,6,7],[1,2,7],[2,3,8],[3,4,8],[4,5,8],[5,6,8],[6,7,8],[2,7,8]]);;

DrawConvexFacegraphToTikz( double6Gon, "convex_facegraph_Double6Gon.tex" );;
