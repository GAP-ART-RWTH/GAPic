
DeclareProperty( "IsAnomalyFree", IsPolygonalComplex );
DeclareSynonym( "IsVertexFaithful", IsAnomalyFree );

DeclareAttribute( "EdgeAnomalyClasses", IsPolygonalComplex );

DeclareOperation( "EdgeAnomalyClassOfEdge", [IsPolygonalComplex, IsPosInt] );
DeclareOperation( "EdgeAnomalyClassOfEdgeNC", [IsPolygonalComplex, IsPosInt] );

DeclareAttribute( "FaceAnomalyClasses", IsPolygonalComplex );

DeclareOperation( "FaceAnomalyClassOfFace", [IsPolygonalComplex, IsPosInt] );
DeclareOperation( "FaceAnomalyClassOfFaceNC", [IsPolygonalComplex, IsPosInt] );

DeclareOperation( "DrawSurfaceToTikz", [IsPolygonalComplex and IsNotEdgeRamified, IsString, IsRecord] );

DeclareOperation("SetFaceCoordinates2D", [IsSimplicialSurface,IsList,IsRecord]);
DeclareOperation("SetFaceCoordinates2DNC", [IsSimplicialSurface, IsList,IsRecord]);

DeclareOperation( "DrawConvexFacegraphToTikz", [IsSimplicialSurface ,IsString,IsRecord]);
DeclareOperation( "DrawPlaneGraphToTikz", [IsDigraph ,IsString,IsRecord]);
