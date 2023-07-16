
DeclareOperation( "SetVertexCoordinates3D", [IsTriangularComplex, IsList, IsRecord] );
DeclareOperation( "SetVertexCoordinates3DNC", [IsTriangularComplex, IsList, IsRecord] );

DeclareOperation( "GetVertexCoordinates3D", [IsTriangularComplex, IsPosInt, IsRecord] );
DeclareOperation( "GetVertexCoordinates3DNC", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "DrawComplexToJavaScript", [IsTriangularComplex, IsString, IsRecord] );

DeclareOperation( "ActivateVertices", [IsTriangularComplex, IsRecord] );
DeclareOperation( "ActivateVertex", [IsTriangularComplex, IsPosInt, IsRecord] );
DeclareOperation( "IsVertexActive", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "DeactivateVertices", [IsTriangularComplex, IsRecord] );
DeclareOperation( "DeactivateVertex", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "ActivateFaces", [IsTriangularComplex, IsRecord] );
DeclareOperation( "ActivateFace", [IsTriangularComplex, IsPosInt, IsRecord] );
DeclareOperation( "IsFaceActive", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "DeactivateFaces", [IsTriangularComplex, IsRecord] );
DeclareOperation( "DeactivateFace", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "SetVertexColours", [IsTriangularComplex, IsList, IsRecord] );
DeclareOperation( "SetVertexColour", [IsTriangularComplex, IsPosInt, IsString, IsRecord] );

DeclareOperation( "GetVertexColours", [IsTriangularComplex, IsRecord] );
DeclareOperation( "GetVertexColour", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "SetEdgeColours", [IsTriangularComplex, IsList, IsRecord] );
DeclareOperation( "SetEdgeColour", [IsTriangularComplex, IsPosInt, IsString, IsRecord] );

DeclareOperation( "GetEdgeColours", [IsTriangularComplex, IsRecord] );
DeclareOperation( "GetEdgeColour", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "SetFaceColours", [IsTriangularComplex, IsList, IsRecord] );
DeclareOperation( "SetFaceColour", [IsTriangularComplex, IsPosInt, IsString, IsRecord] );

DeclareOperation( "GetFaceColours", [IsTriangularComplex, IsRecord] );
DeclareOperation( "GetFaceColour", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "ActivateInnerCircles", [IsTriangularComplex, IsRecord] );
DeclareOperation( "ActivateInnerCircle", [IsTriangularComplex, IsPosInt, IsRecord] );
DeclareOperation( "IsInnerCircleActive", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "DeactivateInnerCircles", [IsTriangularComplex, IsRecord] );
DeclareOperation( "DeactivateInnerCircle", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "SetCircleColours", [IsTriangularComplex, IsList, IsRecord] );
DeclareOperation( "SetCircleColour", [IsTriangularComplex, IsPosInt, IsString, IsRecord] );

DeclareOperation( "GetCircleColours", [IsTriangularComplex, IsRecord] );
DeclareOperation( "GetCircleColour", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "ActivateNormalOfInnerCircles", [IsTriangularComplex, IsRecord] );
DeclareOperation( "ActivateNormalOfInnerCircle", [IsTriangularComplex, IsPosInt, IsRecord] );
DeclareOperation( "IsNormalOfInnerCircleActive", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "DeactivateNormalOfInnerCircles", [IsTriangularComplex, IsRecord] );
DeclareOperation( "DeactivateNormalOfInnerCircle", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "ActivateParameterizedVertices", [IsTriangularComplex, IsRecord]);
DeclareOperation( "DeactivateParameterizedVertices", [IsTriangularComplex, IsRecord]);
DeclareOperation( "IsParameterizedVertices", [IsTriangularComplex, IsRecord]);
DeclareOperation( "SetVertexCoordinatesParameterized", [IsTriangularComplex, IsList, IsRecord]);
DeclareOperation( "SetVertexParameters", [IsTriangularComplex, IsList, IsRecord]);
DeclareOperation( "GetVertexParameters", [IsTriangularComplex, IsRecord]);
DeclareOperation( "SetPlaneRange", [IsTriangularComplex, IsList, IsRecord]);
DeclareOperation( "GetPlaneRange", [IsTriangularComplex, IsRecord]);

DeclareOperation( "ActivateEdges", [IsTriangularComplex, IsRecord] );
DeclareOperation( "ActivateEdge", [IsTriangularComplex, IsPosInt, IsRecord] );
DeclareOperation( "IsEdgeActive", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "DeactivateEdges", [IsTriangularComplex, IsRecord] );
DeclareOperation( "DeactivateEdge", [IsTriangularComplex, IsPosInt, IsRecord] );



DeclareOperation( "SetTransparencyJava", [IsTriangularComplex, IsPosInt, IsFloat, IsRecord] );

DeclareOperation( "RemoveTransparencyJava", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "GetTransparencyJava", [IsTriangularComplex, IsPosInt, IsRecord] );

DeclareOperation( "CalculateParametersOfInnerCircle", [IsTriangularComplex, IsRecord] );