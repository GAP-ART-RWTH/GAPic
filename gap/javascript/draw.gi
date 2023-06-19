BindGlobal( "__GAPIC__IsCoordinates3D",
    function(surface, coordinates)
        local coord,i;
        if Filtered([1..Length(coordinates)],i->IsBound(coordinates[i])) <> Vertices(surface) then
            return false;
	fi;

        # Check whether all coordinates are 3D-coordinates
        for coord in coordinates do
            if not IsDenseList(coord) then
                return false;
            fi;
            if Length(coord) <> 3 then
                return false;
            fi;
        od;
        return true;
    end
);

InstallMethod( SetVertexCoordinates3D,
    "for a simplicial surface, a list of coordinates and a record",
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, coordinates, printRecord)
	if not __GAPIC__IsCoordinates3D(surface, coordinates) then
	    Error( " invalid coordinate format " );
	fi;
	return SetVertexCoordinates3DNC(surface, coordinates, printRecord);
    end
);
RedispatchOnCondition( SetVertexCoordinates3D, true, 
    [IsTwistedPolygonalComplex,IsList,IsRecord], 
    [IsTriangularComplex, IsList], 0 );

InstallOtherMethod( SetVertexCoordinates3D,
    "for a simplicial surface and a list of coordinates",
    [IsTriangularComplex, IsList],
    function(surface, coordinates)
	return SetVertexCoordinates3D(surface, coordinates, rec());
    end
);
RedispatchOnCondition( SetVertexCoordinates3D, true, 
    [IsTwistedPolygonalComplex,IsList], 
    [IsTriangularComplex, IsList], 0 );

InstallMethod( SetVertexCoordinates3DNC,
    "for a simplicial surface, a list of coordinates and a record",
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, coordinates, printRecord)
	printRecord.vertexCoordinates3D := coordinates;
        return printRecord;
    end
);
RedispatchOnCondition( SetVertexCoordinates3DNC, true, 
    [IsTwistedPolygonalComplex,IsList,IsRecord], 
    [IsTriangularComplex, IsList], 0 );
InstallOtherMethod( SetVertexCoordinates3DNC,
    "for a simplicial surface and a list of coordinates",
    [IsTriangularComplex, IsList],
    function(surface, coordinates)
	return SetVertexCoordinates3DNC(coordinates, rec());
    end
);
RedispatchOnCondition( SetVertexCoordinates3DNC, true, 
    [IsTwistedPolygonalComplex,IsList], 
    [IsTriangularComplex, IsList], 0 );

InstallMethod( GetVertexCoordinates3D,
    "for a simplicial surface, a vertex and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, vertex, printRecord)
	if not __GAPIC__IsCoordinates3D(surface, printRecord.vertexCoordinates3D) then
	    Error( " invalid coordinate format " );
        fi;
	return GetVertexCoordinates3DNC(surface, vertex, printRecord);
    end
);
RedispatchOnCondition(GetVertexCoordinates3D, true, [IsTwistedPolygonalComplex, IsPosInt, IsRecord],
    [IsTriangularComplex], 0);

InstallMethod( GetVertexCoordinates3DNC,
    "for a simplicial surface, a vertex and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, vertex, printRecord)
	return printRecord.vertexCoordinates3D[vertex];
    end
);
RedispatchOnCondition(GetVertexCoordinates3DNC, true, [IsTwistedPolygonalComplex, IsPosInt, IsRecord],
    [IsTriangularComplex], 0);	

InstallMethod( ActivateInnerCircles,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
	local face;
	for face in Faces(surface) do
	    printRecord := ActivateInnerCircle(surface, face, printRecord);
	od;
        return printRecord;
    end
);
RedispatchOnCondition( ActivateInnerCircles, true, 
    [IsTwistedPolygonalComplex, IsRecord],
    [IsTriangularComplex], 0);



InstallMethod( DeactivateInnerCircles,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
			printRecord.drawInnerCircles := [];
			return printRecord;
    end
);

InstallMethod( ActivateInnerCircle,
    "for a simplicial surface, a face and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.drawInnerCircles) then
				printRecord.drawInnerCircles := [];
			fi;
			printRecord.drawInnerCircles[face] := true;
			return printRecord;
    end
);

InstallMethod( DeactivateInnerCircle,
    "for a simplicial surface, a face and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.drawInnerCircles) then
				return printRecord;
			fi;
			printRecord.drawInnerCircles[face] := false;
			return printRecord;
    end
);

InstallMethod( IsInnerCircleActive,
    "for a simplicial surface, a face and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, face, printRecord)
        if not IsBound(printRecord.drawInnerCircles) or (face <= 0) then
            return false;
        fi;
        if not IsBound(printRecord.drawInnerCircles[face]) then
            return false;
        fi;
        return printRecord.drawInnerCircles[face] = true;
    end
);

InstallMethod( ActivateNormalOfInnerCircles,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
			local face;
			if not IsBound(printRecord.innerCircles) then
				printRecord := CalculateParametersOfInnerCircle(surface, printRecord);
			fi;
			for face in Faces(surface) do
				printRecord := ActivateNormalOfInnerCircle(surface, face, printRecord);
			od;
			return printRecord;
    end
);

InstallMethod( DeactivateNormalOfInnerCircles,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
			printRecord.drawNormalOfInnerCircles := [];
			return printRecord;
    end
);

InstallMethod( ActivateNormalOfInnerCircle,
    "for a simplicial surface, a face and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.innerCircles) then
				printRecord := CalculateParametersOfInnerCircle(surface, printRecord);
			fi;
			if not IsBound(printRecord.drawNormalOfInnerCircles) then
				printRecord.drawNormalOfInnerCircles := [];
			fi;
			printRecord.drawNormalOfInnerCircles[face] := true;
			return printRecord;
    end
);

InstallMethod( DeactivateNormalOfInnerCircle,
    "for a simplicial surface, a face and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.drawNormalOfInnerCircles) then
				return printRecord;
			fi;
			printRecord.drawNormalOfInnerCircles[face] := false;
			return printRecord;
    end
);

InstallMethod( IsNormalOfInnerCircleActive,
    "for a simplicial surface, a face and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.innerCircles) then
					return false;
				fi;
				if not IsBound(printRecord.drawNormalOfInnerCircles) or (face <= 0) then
					return false;
				fi;
				if not IsBound(printRecord.drawNormalOfInnerCircles[face]) then
					return false;
				fi;
				return printRecord.drawNormalOfInnerCircles[face] = true;
    end
);

InstallMethod( ActivateEdges,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
        local edge;
        for edge in Edges(surface) do
            printRecord := ActivateEdge(surface, edge, printRecord);
        od;
        return printRecord;
    end
);

InstallMethod( DeactivateEdges,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
        local edge;
        for edge in Edges(surface) do
            printRecord := DeactivateEdge(surface, edge, printRecord);
        od;
        return printRecord;
    end
);

InstallMethod( ActivateEdge,
    "for a simplicial surface, an edge and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, edge, printRecord)
        if not IsBound(printRecord.drawEdges) then
            printRecord.drawEdges := [];
        fi;
        printRecord.drawEdges[edge] := true;
        return printRecord;
    end
);

InstallMethod( DeactivateEdge,
    "for a simplicial surface, an edge and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, edge, printRecord)
        if not IsBound(printRecord.drawEdges) then
            printRecord.drawEdges := [];
        fi;
        printRecord.drawEdges[edge] := false;
        return printRecord;
    end
);

InstallMethod( IsEdgeActive,
    "for a simplicial surface, an edge and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, edge, printRecord)
        if not IsBound(printRecord.drawEdges) then
            return true;
        fi;
        if (edge <= 0) then
            return false;
        fi;
        if not IsBound(printRecord.drawEdges[edge]) then
            return true;
        fi;
        return printRecord.drawEdges[edge] = true;
    end
);

InstallMethod( ActivateFaces,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
			printRecord.drawFaces := [];
			return printRecord;
    end
);

InstallMethod( DeactivateFaces,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
			local face;
			for face in Faces(surface) do
				printRecord := DeactivateFace(surface, face, printRecord);
			od;
			return printRecord;
    end
);

InstallMethod( ActivateFace,
    "for a simplicial surface, a face and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.drawFaces) then
				printRecord.drawFaces := [];
				return printRecord;
			fi;
			printRecord.drawFaces[face] := true;
			return printRecord;
    end
);

InstallMethod( DeactivateFace,
    "for a simplicial surface, a face and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, face, printRecord)
			if not IsBound(printRecord.drawFaces) then
				printRecord.drawFaces := [];
			fi;
			printRecord.drawFaces[face] := false;
			return printRecord;
    end
);

InstallMethod( IsFaceActive,
    "for a simplicial surface, a face and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, face, printRecord)
				if not IsBound(printRecord.drawFaces) then
					return true;
				fi;
				if (face <= 0) then
					return false;
				fi;
				if not IsBound(printRecord.drawFaces[face]) then
					return true;
				fi;
				return printRecord.drawFaces[face] = true;
    end
);

InstallMethod( ActivateVertices,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
			if not IsBound(printRecord.vertexCoordinates3D) then
				Error(" The 3D-coordinates of the vertices are not set ");
			fi;
			printRecord.drawVertices := [];
			return printRecord;
    end
);

InstallMethod( DeactivateVertices,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
			local vertex;
			for vertex in Vertices(surface) do
				printRecord := DeactivateVertex(surface, vertex, printRecord);
			od;
			return printRecord;
    end
);

InstallMethod( ActivateVertex,
    "for a simplicial surface, a vertex and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, vertex, printRecord)
			if not IsBound(printRecord.vertexCoordinates3D) then
				Error(" The 3D-coordinates of the vertices are not set ");
			fi;
			if not IsBound(printRecord.drawVertices) then
				printRecord.drawVertices := [];
				return printRecord;
			fi;
			printRecord.drawVertices[vertex] := true;
			return printRecord;
    end
);

InstallMethod( DeactivateVertex,
    "for a simplicial surface, a vertex and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, vertex, printRecord)
			if not IsBound(printRecord.drawVertices) then
				printRecord.drawVertices := [];
			fi;
			printRecord.drawVertices[vertex] := false;
			return printRecord;
    end
);

InstallMethod( IsVertexActive,
    "for a simplicial surface, a vertex and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, vertex, printRecord)
			if not IsBound(printRecord.vertexCoordinates3D) then
					return false;
				fi;
				if not IsBound(printRecord.drawVertices) then
					return true;
				fi;
				if (vertex <= 0) then
					return false;
				fi;
				if not IsBound(printRecord.drawVertices[vertex]) then
					return true;
				fi;
				return printRecord.drawVertices[vertex] = true;
    end
);

InstallMethod( SetFaceColour,
    "for a simplicial surface, a face, a string and a record",
    [IsTriangularComplex, IsPosInt, IsString, IsRecord],
    function(surface, face, colour, printRecord)
				if not IsBound(printRecord.faceColours) then
					printRecord.faceColours := [];
				fi;
				printRecord.faceColours[face] := colour;
				return printRecord;
    end
);

InstallMethod( GetFaceColour,
    "for a simplicial surface, a face and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, face, printRecord)
				local default;
				default := "0x049EF4";
				if not IsBound(printRecord.faceColours) or (face <= 0) then
					return default;
				fi;
				if not IsBound(printRecord.faceColours[face]) and not IsString(printRecord.faceColours) then
					return default;
				fi;
				if IsString(printRecord.faceColours) then
                    return printRecord.faceColours;
                else
    				return printRecord.faceColours[face];
                fi;
    end
);

InstallMethod( SetFaceColours,
    "for a simplicial surface, a list and a record",
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, faceColours, printRecord)
				printRecord.faceColours := faceColours;
				return printRecord;
    end
);

InstallMethod( GetFaceColours,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
    local res, i;
        res := [];
        for i in Faces(surface) do
            res[i]:= GetFaceColour(surface, i, printRecord);
        od;

        return res;
    end
);

InstallMethod( SetVertexColour,
    "for a simplicial surface, a vertex, a string and a record",
    [IsTriangularComplex, IsPosInt, IsString, IsRecord],
    function(surface, vertex, colour, printRecord)
				if not IsBound(printRecord.vertexColours) then
					printRecord.vertexColours := [];
				fi;
				printRecord.vertexColours[vertex] := colour;
				return printRecord;
    end
);

InstallMethod( GetVertexColour,
    "for a simplicial surface, a vertex and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, vertex, printRecord)
				local default;
				default := "0xF58137";
				if not IsBound(printRecord.vertexColours) or (vertex <= 0) then
					return default;
				fi;
				if not IsBound(printRecord.vertexColours[vertex]) then
					return default;
				fi;
				return printRecord.vertexColours[vertex];
    end
);

InstallMethod( SetVertexColours,
    "for a simplicial surface, a list and a record",
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, vertexColours, printRecord)
				printRecord.vertexColours := vertexColours;
				return printRecord;
    end
);

InstallMethod( GetVertexColours,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
        local vertexColours, i;
        vertexColours := [];
        for i in [1..Length(Vertices(surface))] do
            Add(vertexColours, GetVertexColour(surface, i, printRecord));
        od;

        return vertexColours;
    end
);

InstallMethod( SetEdgeColour,
    "for a simplicial surface, an edge, a string and a record",
    [IsTriangularComplex, IsPosInt, IsString, IsRecord],
    function(surface, edge, colour, printRecord)
				if not IsBound(printRecord.edgeColours) then
					printRecord.edgeColours := [];
				fi;
				printRecord.edgeColours[edge] := colour;
				return printRecord;
    end
);

InstallMethod( GetEdgeColour,
    "for a simplicial surface, an edge and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, edge, printRecord)
				local default;
				default := "0x000000";
				if not IsBound(printRecord.edgeColours) or (edge <= 0) then
					return default;
				fi;
				if not IsBound(printRecord.edgeColours[edge]) then
					return default;
				fi;
				return printRecord.edgeColours[edge];
    end
);

InstallMethod( SetEdgeColours,
    "for a simplicial surface, a list and a record",
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, edgeColours, printRecord)
				printRecord.edgeColours := edgeColours;
				return printRecord;
    end
);

InstallMethod( GetEdgeColours,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
        local edgeColours, i;
        edgeColours := [];
        for i in [1..Length(Edges(surface))] do
            Add(edgeColours, GetEdgeColour(surface, i, printRecord));
        od;

        return edgeColours;
    end
);

InstallMethod( SetCircleColour,
    "for a simplicial surface, a face, a string and a record",
    [IsTriangularComplex, IsPosInt, IsString, IsRecord],
    function(surface, face, colour, printRecord)
				if not IsBound(printRecord.circleColours) then
					printRecord.circleColours := [];
				fi;
				printRecord.circleColours[face] := colour;
				return printRecord;
    end
);

InstallMethod( GetCircleColour,
    "for a simplicial surface, a face and a record",
    [IsTriangularComplex, IsPosInt, IsRecord],
    function(surface, face, printRecord)
				local default;
				default := "0x000000";
				if not IsBound(printRecord.circleColours) or (face <= 0) then
					return default;
				fi;
				if not IsBound(printRecord.circleColours[face]) then
					return default; 
				fi;
				return printRecord.circleColours[face];
    end
);

InstallMethod( SetCircleColours,
    "for a simplicial surface, a list and a record",
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, circleColours, printRecord)
				printRecord.circleColours := circleColours;
				return printRecord;
    end
);

InstallMethod( GetCircleColours,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
				if not IsBound(printRecord.circleColours) then
					return [];
				fi;
				return printRecord.circleColours;
    end
);

# set neccessary values for the printrecord
BindGlobal( "__GAPIC__InitializePrintRecordDrawSurfaceToJavascript",
    function(surface,printRecord)
	local edgeThickness;
	if not IsBound(printRecord.edgeThickness) then
	    printRecord.edgeThickness := 0.03;
	fi;
	

	return printRecord;
    end
);

# function to calculate the incenter of a triangle/face. Used for inner circles
# we follow the math and variable names from here: https://math.stackexchange.com/questions/740111/incenter-of-triangle-in-3d
BindGlobal( "__GAPIC__CalculateIncenter",
    function(surface,printRecord,face)
	local a, b, c, A, B, C, atemp, btemp, ctemp, incenter;

    #get the coordinates
    A := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord);
    B := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord);
    C := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord);

    atemp := B-C;
    btemp := C-A;
    ctemp := A-B;

    a := Sqrt(Float(atemp[1]^2+atemp[2]^2+atemp[3]^2));
    b := Sqrt(Float(btemp[1]^2+btemp[2]^2+btemp[3]^2));
    c := Sqrt(Float(ctemp[1]^2+ctemp[2]^2+ctemp[3]^2));

    incenter := a/(a+b+c)*A + b/(a+b+c)*B + c/(a+b+c)*C;
 
    return incenter;
    end
);

# function to calculate the inradius of a triangle/face. Used for inner circles
# we follow the math and variable names from here: https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle#Radius
BindGlobal( "__GAPIC__CalculateInradius",
    function(surface,printRecord,face)
	local a, b, c, A, B, C, atemp, btemp, ctemp, s, inradius;

    #get the coordinates
    A := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord);
    B := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord);
    C := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord);

    atemp := B-C;
    btemp := C-A;
    ctemp := A-B;

    a := Sqrt(Float(atemp[1]^2+atemp[2]^2+atemp[3]^2));
    b := Sqrt(Float(btemp[1]^2+btemp[2]^2+btemp[3]^2));
    c := Sqrt(Float(ctemp[1]^2+ctemp[2]^2+ctemp[3]^2));

    s := (a+b+c)/2;
    inradius := Sqrt(Float( ((s-a)*(s-b)*(s-c)) / s ));
 
	return inradius;
    end
);

# function to calculate the normalvector of a triangle/face. Used for normals of inner circles
# we use just the cross product of two of the defining edges, generated by the vertices
BindGlobal( "__GAPIC___CalculateNormalvector",
    function(surface,printRecord,face)
	local A, B, C, atemp, btemp, normal;

    #get the coordinates
    A := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord);
    B := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord);
    C := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord);

    atemp := C-B;
    btemp := C-A;

    normal := [];

    normal[1] := atemp[2]*btemp[3] - atemp[3]*btemp[2];
    normal[2] := atemp[3]*btemp[1] - atemp[1]*btemp[3];
    normal[3] := atemp[1]*btemp[2] - atemp[2]*btemp[1];
 
	return (1/2)*normal;
    end
);


InstallMethod( ActivateParameterizedVertices,
    [IsTriangularComplex, IsRecord],
    function(surface,printRecord)
    printRecord.parameterVertices := true;
 
	return printRecord;
    end
);

InstallMethod( DeactivateParameterizedVertices,
    [IsTriangularComplex, IsRecord],
    function(surface,printRecord)
    printRecord.parameterVertices := false;
 
	return printRecord;
    end
);

InstallMethod( IsParameterizedVertices,
    [IsTriangularComplex, IsRecord],
    function(surface,printRecord)
    if not IsBound(printRecord.parameterVertices) then
        return false;
    fi;
 
	return true;
    end
);


InstallMethod( SetVertexCoordinatesParameterized,
    "for a simplicial surface, a list of coordinates and a record",
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, coordinates, printRecord)

    printRecord := ActivateParameterizedVertices(surface, printRecord);
	
	return SetVertexCoordinates3DNC(surface, coordinates, printRecord);
    end
);

InstallMethod( SetVertexParameters,
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, parameters, printRecord)
    
    #TODO: check if sensible list is given
    printRecord.vertexParameters := parameters;
 
	return printRecord;
    end
);

InstallMethod( GetVertexParameters,
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
 
    if IsParameterizedVertices(surface, printRecord) then
        return printRecord.vertexParameters;
    else 
        return fail;
    fi;
    end
);

InstallMethod( SetPlaneRange,
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, range, printRecord)
    
    #TODO: check if sensible list is given
    printRecord.planeRange := range;
 
	return printRecord;
    end
);

InstallMethod( GetPlaneRange,
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
 
    if IsBound(printRecord.planeRange) then
        return printRecord.planeRange;
    else
        return fail;
    fi;
    end
);

# general method
InstallMethod( DrawComplexToJavaScript,
    "for a simplicial surface, a filename and a record",
    [IsTriangularComplex, IsString, IsRecord],
    function(surface, fileName, printRecord)
        local file, output, template, coords, i, j, colour,
        vertOfFace, vertOfEdge, parametersOfCircle, 
        parametersOfEdge, temp, vertex, edge ,face,vertices,edges,
        faceColors, addedFaceColors, uniqueFaceColors, colorPositions, color, coordinateString, edgeThickness,
        faces, coordinateStringA, coordinateStringB, coordinateStringC, edgeVertexA, edgeVertexB, edgeColors, uniqueEdgeColors,
        incenter,inradius, normal, atemp, btemp, material, vertexParameters, p, vertexParameterNames, vertexParameterString,
        maxXcoord, maxYcoord, maxZcoord, minXcoord, minYcoord, minZcoord, x, y, z, range, vertexA, vertexB, vertexC;

    # make sure the defaults are set
    printRecord := __GAPIC__InitializePrintRecordDrawSurfaceToJavascript(surface, printRecord);
    
    #predefine some lists
	vertices:=Vertices(surface);
	edges:=Edges(surface);
	faces:=Faces(surface);

    # Make the file end with .html
    if not EndsWith( fileName, ".html" ) then
        fileName := Concatenation( fileName, ".html" );
    fi;

    # Try to open the given file
    file := Filename( DirectoryCurrent(), fileName ); #TODO allow absolute paths
    output := OutputTextFile( file, false ); # override other files
    if output = fail then
        Error(Concatenation("File ", String(file), " can't be opened.") );
    fi;
    SetPrintFormattingStatus( output, false );

    AppendTo( output, __GAPIC__ReadTemplateFromFile("three_start.template") );

    # Check if surface is in 3d coords
    # TODO neccessary?
    if not __GAPIC__IsCoordinates3D(surface, printRecord.vertexCoordinates3D) then
        Error( " invalid coordinate format " );
    fi;

    # add faces to geometry by iterating over all colors
    # for each color there is a new geometry and material generated. these are then combined into a mesh and added to the root group
    faceColors := GetFaceColours(surface, printRecord);

    # generate a list of all unique colors of the faces
    uniqueFaceColors := [];
    for color in faceColors do
        if not color in uniqueFaceColors then
            Add(uniqueFaceColors, color);
        fi; 
    od;

    vertexParameterNames := "";
    vertexParameterString := "";
    if IsParameterizedVertices(surface, printRecord) then
        vertexParameters := GetVertexParameters(surface, printRecord);

        AppendTo(output, "\t\t\tvar vParams = new function(){\n");
        for p in vertexParameters do
            AppendTo(output, "\t\t\t\tthis.",p[1],"=",p[2],";\n");
        od;
        AppendTo(output, "\t\t\t}\n\n");

        vertexParameterString := "";
        for p in vertexParameters do
            Append(vertexParameterString, "vParams.");
            Append(vertexParameterString, String(p[1]));
            Append(vertexParameterString, ",");
        od;

        vertexParameterNames := "";
        for p in vertexParameters do
            Append(vertexParameterNames, String(p[1]));
            Append(vertexParameterNames, ",");
        od;

        AppendTo(output, "\t\t\tconst vertexParametriziation = true;\n");

        AppendTo(output, "\t\t\tconst parameterFolder = gui.addFolder(\"Parameters\");\n");
        for p in vertexParameters do
            AppendTo(output, "\t\t\tparameterFolder.add(vParams, '",p[1],"', ",p[3][1],",",p[3][2],");\n");
        od;
        AppendTo(output, "\t\t\tparameterFolder.open();\n\n");
    else 
        AppendTo(output, "\t\t\tconst vertexParametriziation = false;\n");
    fi;

    AppendTo(output, "\t\t\tconst numberOfFaceGeometries = ",Length(uniqueFaceColors),";\n\n");

    # for each of the unique colors add the faces to a gemeometry and generate a mesh with corresponding color from it
    # also generate a wireframe which can be made visible via the gui
    for i in [1..Length(uniqueFaceColors)] do
        color := uniqueFaceColors[i];
        if not StartsWith(color, "0x") then
            colour := Concatenation("\"", color, "\"");
        fi;

        # generate a geometry with all vertices of the faces belonging to the current face
        AppendTo(output, "\t \t \tconst geometry",i," = new THREE.BufferGeometry();\n");
        AppendTo(output, "\t\t\tfunction setVertices",i,"(",vertexParameterNames,"){\n");
        AppendTo(output, "\t \t \var vertices",i," = new Float32Array( [\n \t \t \t \t");

        colorPositions := Positions(faceColors, color);
        for face in colorPositions do
            if IsFaceActive(surface, face, printRecord) then
                # we assume there is always at least one active face               
                # as we can assume that all faces of a simplicial surface have exactly 3 vertices we add them to the geometry individually
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[1], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[2], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[3], ",\n \t \t \t \t");

                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[1], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[2], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[3], ",\n\t \t \t \t");

                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[1], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[2], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[3], ",\n\n\t \t \t \t");
            fi;
        od;
        AppendTo(output, "] ); \n\n");
        AppendTo(output, "\t\t\t\treturn vertices",i,"; \n \t\t\t}\n\n");

        AppendTo(output, "\t \t \tgeometry",i,".setAttribute( 'position', new THREE.BufferAttribute( setVertices",i,"(",vertexParameterString,"), 3 ) );\n\n");

        # generate a material with the corresponding color
        AppendTo(output, """
            const materialNormal""",i,""" = new THREE.MeshNormalMaterial({       
                flatShading: true,       
            });
            materialNormal""",i,""".transparent = true;
            materialNormal""",i,""".side = THREE.DoubleSide;
        """);
        AppendTo(output, """
            const material""",i,""" = new THREE.MeshPhongMaterial({
                color: """,GetFaceColour(surface, face, printRecord),""",          
                flatShading: true,       
            });
            material""",i,""".transparent = true;
            material""",i,""".side = THREE.DoubleSide;
        """);

        # generate a mesh from the geometry and material above
        AppendTo(output, """
            const mesh""",i,""" = new THREE.Mesh( geometry""",i,""", material""",i,""" );
            mesh""",i,""".castShadow = true;                         
            mesh""",i,""".receiveShadow = true;                      
                                        
            meshRoot.add(mesh""",i,""");
        """);
        AppendTo(output, """
            const meshNormal""",i,""" = new THREE.Mesh( geometry""",i,""", materialNormal""",i,""" );
            mesh""",i,""".castShadow = true;                         
            mesh""",i,""".receiveShadow = true;                      
                                        
            normalMeshRoot.add(meshNormal""",i,""");
        """);
    od;

    if IsParameterizedVertices(surface, printRecord) then
        AppendTo(output, "function updateVerticesCoordinates(){\n");
        for i in [1..Length(uniqueFaceColors)] do
            AppendTo(output, "\t\t\t\tgeometry",i,".setAttribute( 'position', new THREE.BufferAttribute( setVertices",i,"(",vertexParameterString,"), 3 ) );\n");
        od;
        AppendTo(output, "\t\t\t}\n\n");
    fi;

    # add edges to geometry by iterating over all colors
    # for each color there is a new geometry and material generated. these are then combined into a mesh and added to the edgeRoot group
    edgeColors := GetEdgeColours(surface, printRecord);

    # generate a list of all unique colors of the faces
    uniqueEdgeColors := [];
    for color in edgeColors do
        if not color in uniqueEdgeColors then
            Add(uniqueEdgeColors, color);
        fi; 
    od;

    

    # for each of the unique colors add the edges to a gemeometry and generate a mesh with corresponding color from it
    # also generate a wireframe from the edges which can be made visible via the gui
    for i in [1..Length(uniqueEdgeColors)] do
        color := uniqueEdgeColors[i];
        if not StartsWith(color, "0x") then
            colour := Concatenation("\"", color, "\"");
        fi;

        edgeThickness := printRecord.edgeThickness*100;
        AppendTo(output, """
            const edgeMaterial""",i,""" = new THREE.LineBasicMaterial( {
                color: """,color,""",
                linewidth: """,edgeThickness,""",
            } );        
        """);

        AppendTo(output, "\t\t\tfunction setEdges",i,"(",vertexParameterNames,"){\n");
        AppendTo(output, "\tconst edges",i," = new Float32Array( [\n");

        colorPositions := Positions(edgeColors, color);
        for j in colorPositions do
            edge := Edges(surface)[j];
            if IsEdgeActive(surface, edge, printRecord) then
                # generate a string with the coordinates for later use
                edgeVertexA := VerticesOfEdge(surface, edge)[1];
                edgeVertexB := VerticesOfEdge(surface, edge)[2];
                coordinateStringA := "";
                Append(coordinateStringA, String(GetVertexCoordinates3DNC(surface, edgeVertexA, printRecord)[1]));
                Append(coordinateStringA, ",");
                Append(coordinateStringA, String(GetVertexCoordinates3DNC(surface, edgeVertexA, printRecord)[2]));
                Append(coordinateStringA, ",");
                Append(coordinateStringA, String(GetVertexCoordinates3DNC(surface, edgeVertexA, printRecord)[3]));
                Append(coordinateStringA, ",");

                coordinateStringB := "";
                Append(coordinateStringB, String(GetVertexCoordinates3DNC(surface, edgeVertexB, printRecord)[1]));
                Append(coordinateStringB, ",");
                Append(coordinateStringB, String(GetVertexCoordinates3DNC(surface, edgeVertexB, printRecord)[2]));
                Append(coordinateStringB, ",");
                Append(coordinateStringB, String(GetVertexCoordinates3DNC(surface, edgeVertexB, printRecord)[3]));
                Append(coordinateStringB, ",");

                AppendTo(output, "\t \t \t",coordinateStringA,"\n \t \t \t",coordinateStringB,"\n \n");
            fi;
        od;

        AppendTo(output, "\t \t \t]);");

        AppendTo(output, "\t\t\t\treturn edges",i,"; \n \t\t\t}\n\n");

        # AppendTo(output, "\t \t \tgeometry",i,".setAttribute( 'position', new THREE.BufferAttribute( setVertices",i,"(",vertexParameterString,"), 3 ) );\n\n");

        AppendTo(output, """
            const edgeGeometry""",i,""" = new THREE.BufferGeometry();
            edgeGeometry""",i,""".setAttribute( 'position', new THREE.BufferAttribute( setEdges""",i,"""(""",vertexParameterString,"""), 3 ) );

            const edgeLine""",i,""" = new THREE.LineSegments( edgeGeometry""",i,""", edgeMaterial""",i,""" );
            edgeRoot.add(edgeLine""",i,""");
        """);

        if IsParameterizedVertices(surface, printRecord) then
            AppendTo(output, "function updateEdgeCoordinates(){\n");
            for i in [1..Length(uniqueFaceColors)] do
                AppendTo(output, "\t\t\t\tedgeGeometry",i,".setAttribute( 'position', new THREE.BufferAttribute( setEdges",i,"(",vertexParameterString,"), 3 ) );\n");
            od;
            AppendTo(output, "\t\t\t}\n\n");
        fi; 
    od;

    # add spheres and lables on all vertices if they are active
    AppendTo(output, "\n\n\t//add the vertices with lables\n");
    for vertex in Vertices(surface) do
        if IsVertexActive(surface, vertex, printRecord) then                
            # generate a string with the coordinates for later use
            coordinateString := "";
            Append(coordinateString, String(GetVertexCoordinates3DNC(surface, vertex, printRecord)[1]));
            Append(coordinateString, ",");
            Append(coordinateString, String(GetVertexCoordinates3DNC(surface, vertex, printRecord)[2]));
            Append(coordinateString, ",");
            Append(coordinateString, String(GetVertexCoordinates3DNC(surface, vertex, printRecord)[3]));
            Append(coordinateString, ",");

            AppendTo(output, "\n\n\t\t\tfunction getVertex",vertex,"(",vertexParameterNames,"){\n");
            AppendTo(output, "\t\t\t\treturn [",coordinateString,"];\n\t\t\t}\n");

            # add spheres with radius edgeThickness around the active vertices
            AppendTo(output, "\t\t\tconst sphereMaterial",vertex," = new THREE.MeshBasicMaterial( { color: ",GetVertexColour(surface, vertex, printRecord)," } );\n");
            AppendTo(output, "\t \t \tconst sphere",vertex," = new THREE.Mesh( sphereGeometry, sphereMaterial",vertex," );\n");
            AppendTo(output, "\t \t \tvertexRoot.add(sphere",vertex,");\n");
            AppendTo(output, "\t\t\tsphere",vertex,".position.set(getVertex",vertex,"(",vertexParameterString,")[0],"); 
            AppendTo(output, "getVertex",vertex,"(",vertexParameterString,")[1],");
            AppendTo(output, "getVertex",vertex,"(",vertexParameterString,")[2]);\n");

            
            # generate the lable for the given vertex
            AppendTo(output, """
            const lableDiv""",vertex,""" = document.createElement( 'div' );
            lableDiv""",vertex,""".className = 'label';
            lableDiv""",vertex,""".textContent = '""",vertex,"""';
            lableDiv""",vertex,""".style.marginTop = '-1em';

            const vertexLabel""",vertex,""" = new CSS2DObject( lableDiv""",vertex,""" );
            vertexLabel""",vertex,""".position.set(getVertex""",vertex,"""(""",vertexParameterString,""")[0],getVertex""",vertex,"""(""",vertexParameterString,""")[1],getVertex""",vertex,"""(""",vertexParameterString,""")[2]);
            vertexlabelRoot.add( vertexLabel""",vertex,""" );
            
            """);
        fi;
    od;

    AppendTo(output, "function updateVertexCoordinates(){\n");
    for vertex in Vertices(surface) do
        if IsVertexActive(surface, vertex, printRecord) then 
            if IsParameterizedVertices(surface, printRecord) then
                #in three steps as return is an array
                AppendTo(output, "\t\t\t\tsphere",vertex,".position.set(getVertex",vertex,"(",vertexParameterString,")[0],"); 
                AppendTo(output, "getVertex",vertex,"(",vertexParameterString,")[1],");
                AppendTo(output, "getVertex",vertex,"(",vertexParameterString,")[2]);\n");
                AppendTo(output, "\t\t\t\tvertexLabel",vertex,".position.set(getVertex",vertex,"(",vertexParameterString,")[0],");
                AppendTo(output, "getVertex",vertex,"(",vertexParameterString,")[1],");
                AppendTo(output, "getVertex",vertex,"(",vertexParameterString,")[2]);\n");
            fi; 
        fi;
    od;
    AppendTo(output, "\t\t\t}\n\n");

    #TODO: apply parameters to everything else

    # generate innercircle for all (active) innercircle faces
    for face in Faces(surface) do
        if(IsInnerCircleActive(surface, face, printRecord)) then
            # generate the right strings of the coordinates
            coordinateStringA := "";
            Append(coordinateStringA, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[1]));
            Append(coordinateStringA, ",");
            Append(coordinateStringA, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[2]));
            Append(coordinateStringA, ",");
            Append(coordinateStringA, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[3]));

            coordinateStringB := "";
            Append(coordinateStringB, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[1]));
            Append(coordinateStringB, ",");
            Append(coordinateStringB, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[2]));
            Append(coordinateStringB, ",");
            Append(coordinateStringB, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[3]));

            coordinateStringC := "";
            Append(coordinateStringC, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[1]));
            Append(coordinateStringC, ",");
            Append(coordinateStringC, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[2]));
            Append(coordinateStringC, ",");
            Append(coordinateStringC, String(GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[3]));

            vertexA := VerticesOfFace(surface, face)[1];
            vertexB := VerticesOfFace(surface, face)[2];
            vertexC := VerticesOfFace(surface, face)[3];

            AppendTo(output, "\t\t\tvar inradius",face," = calulateInradius(getVertex",vertexA,"(",vertexParameterString,"), getVertex",vertexB,"(",vertexParameterString,"), getVertex",vertexC,"(",vertexParameterString,"));\n");
            AppendTo(output, "\t\t\tvar incenter",face," = calulateIncenter(getVertex",vertexA,"(",vertexParameterString,"), getVertex",vertexB,"(",vertexParameterString,"), getVertex",vertexC,"(",vertexParameterString,"));\n");

            AppendTo(output, "\t\t\var ringGeometry",face," = new THREE.RingGeometry((inradius",face," - 0.005),inradius",face,", 32);\n");
            AppendTo(output, "\t\t\tconst ringMaterial",face," = new THREE.LineBasicMaterial( { color: ",GetCircleColour(surface, face, printRecord),", side: THREE.DoubleSide } );\n");
            AppendTo(output, "\t\t\tconst ringMesh",face," = new THREE.Mesh(ringGeometry",face,", ringMaterial",face,");\n");
        
            AppendTo(output, "\t\t\tfunction setCircleRotation",face,"(",vertexParameterNames,"){\n");
            
            # incenter := __GAPIC__CalculateIncenter(surface, printRecord, face);
            # inradius := __GAPIC__CalculateInradius(surface, printRecord, face);

            

            AppendTo(output, """
                //translate ring to incenter
                var incenter = calulateIncenter([""",coordinateStringA,"""],[ """,coordinateStringB,"""],[""",coordinateStringC,"""]);

                ringMesh""",face,""".position.setX(incenter[0]);
                ringMesh""",face,""".position.setY(incenter[1]);
                ringMesh""",face,""".position.setZ(incenter[2]);

                // set the size right. Is done relative to the initial value, as we only can scale the mesh
                var inradius = calulateInradius(getVertex""",vertexA,"""(""",vertexParameterString,"""), getVertex""",vertexB,"""(""",vertexParameterString,"""), getVertex""",vertexC,"""(""",vertexParameterString,"""));
                var relRadius = inradius/inradius""",face,""";

                ringMesh""",face,""".scale.set(relRadius, relRadius, relRadius);

                // rotate ring to right angle
                //calculations for this are done in THREE.js as there are already the right functions for generating and applying the rotation
                const A""",face,""" = new THREE.Vector3(""",coordinateStringA,""");
                const B""",face,""" = new THREE.Vector3(""",coordinateStringB,""");
                const C""",face,""" = new THREE.Vector3(""",coordinateStringC,""");

                const normalVec""",face,""" = new THREE.Vector3();
                normalVec""",face,""".crossVectors(B""",face,""".sub(A""",face,"""), C""",face,""".sub(A""",face,"""));
                normalVec""",face,""".normalize();

                //initial normal vector of ringGeometry is (0,0,1), so we use that
                const initialNormal""",face,""" = new THREE.Vector3(0,0,1);

                const quaternionRotation""",face,""" = new THREE.Quaternion();
                quaternionRotation""",face,""".setFromUnitVectors(initialNormal""",face,""", normalVec""",face,""");

                ringMesh""",face,""".setRotationFromQuaternion(quaternionRotation""",face,""");
                
                return quaternionRotation""",face,""";
            }

                ringRoot.add(ringMesh""",face,""");
            """);
        fi;
    od;

    # make single function to calculate circles 
    AppendTo(output, "function updateCircles(){\n");
    for face in Faces(surface) do
        if(IsInnerCircleActive(surface, face, printRecord)) then
            AppendTo(output, "\t\t\t\tsetCircleRotation",face,"(",vertexParameterString,");\n");
        fi;
    od;
    AppendTo(output, "\t\t\t}\n\n");
    AppendTo(output, "\t\t\tupdateCircles();\n\n");

    # set circle width from the gui
    AppendTo(output, "function updateCircleWidth(){\n");
    for face in Faces(surface) do
        if(IsInnerCircleActive(surface, face, printRecord)) then
            AppendTo(output, "\t\t\t ringGeometry",face," = new THREE.RingGeometry((inradius",face," - guiParameters.circleWidth),inradius",face,", 32);\n");
            AppendTo(output, "\t\t\t ringMesh",face,".geometry = ringGeometry",face,"; \n");
        fi;
    od;
    AppendTo(output, "\t\t\t}\n\n");
    AppendTo(output, "\t\t\tupdateCircleWidth();\n\n");

    coordinateString := "";
    for face in Faces(surface) do
        if IsNormalOfInnerCircleActive(surface, face, printRecord) then
            normal := __GAPIC___CalculateNormalvector(surface, printRecord, face);
            incenter := __GAPIC__CalculateIncenter(surface, printRecord, face);

            # set the two points as incenter plus normal and incenter minus normal
            # TODO: check if the non-normalized normals generated from the face have a good length, otherwise automate
            atemp := incenter-normal;
            btemp := incenter+normal;

            # add to string for later use
            Append(coordinateString, "\t \t \t");
            Append(coordinateString, String(atemp[1]));
            Append(coordinateString, ",");
            Append(coordinateString, String(atemp[2]));
            Append(coordinateString, ",");
            Append(coordinateString, String(atemp[3]));
            Append(coordinateString, ", \n");

            Append(coordinateString, "\t \t \t");
            Append(coordinateString, String(btemp[1]));
            Append(coordinateString, ",");
            Append(coordinateString, String(btemp[2]));
            Append(coordinateString, ",");
            Append(coordinateString, String(btemp[3]));
            Append(coordinateString, ", \n \n");
        fi;
    od;
    if not coordinateString = "" then
        AppendTo(output, """
            const normalsMaterial = new THREE.LineBasicMaterial( {
                color: 0x000000,
            } );        
        """);

        AppendTo(output, "\tconst normals = new Float32Array( [\n");
        AppendTo(output, coordinateString);

        AppendTo(output, "\t \t \t]);");
        AppendTo(output, """
            const normalsGeometry = new THREE.BufferGeometry();
            normalsGeometry.setAttribute( 'position', new THREE.BufferAttribute( normals, 3 ) );

            const normalsLine = new THREE.LineSegments( normalsGeometry, normalsMaterial );
            normalsRoot.add(normalsLine);
        """);
    fi;

    # only try automatic vertices if not parameterized, otherwise to complicated
    if not GetPlaneRange(surface, printRecord) = fail then
        range := GetPlaneRange(surface, printRecord);
        AppendTo(output, "\t\t\tguiParameters.maxX = ",range[1][2],";\n");
        AppendTo(output, "\t\t\tguiParameters.maxY = ",range[2][2],";\n");
        AppendTo(output, "\t\t\tguiParameters.maxZ = ",range[3][2],";\n");
        AppendTo(output, "\t\t\tguiParameters.minX = ",range[1][1],";\n");
        AppendTo(output, "\t\t\tguiParameters.minY = ",range[2][1],";\n");
        AppendTo(output, "\t\t\tguiParameters.minZ = ",range[3][1],";\n\n");
    else
        if not IsParameterizedVertices(surface, printRecord) then
            # calculate maximal values in all directions for intersection plane slider 
            maxXcoord := 0.0;
            maxYcoord := 0.0;
            maxZcoord := 0.0;
            minXcoord := 0.0;
            minYcoord := 0.0;
            minZcoord := 0.0;
            for vertex in Vertices(surface) do
                x := Float(GetVertexCoordinates3DNC(surface, vertex, printRecord)[1]);
                y := Float(GetVertexCoordinates3DNC(surface, vertex, printRecord)[2]);
                z := Float(GetVertexCoordinates3DNC(surface, vertex, printRecord)[3]);

                if x >= maxXcoord then
                    maxXcoord := x;
                fi;
                if y >= maxYcoord then
                    maxYcoord := y;
                fi;
                if z >= maxZcoord then
                    maxZcoord := z;
                fi;
                if x <= minXcoord then
                    minXcoord := x;
                fi;
                if y <= minYcoord then
                    minYcoord := y;
                fi;
                if z <= minZcoord then
                    minZcoord := z;
                fi;
            od;

            AppendTo(output, "\t\t\tguiParameters.maxX = ",maxXcoord,";\n");
            AppendTo(output, "\t\t\tguiParameters.maxY = ",maxYcoord,";\n");
            AppendTo(output, "\t\t\tguiParameters.maxZ = ",maxZcoord,";\n");
            AppendTo(output, "\t\t\tguiParameters.minX = ",minXcoord,";\n");
            AppendTo(output, "\t\t\tguiParameters.minY = ",minYcoord,";\n");
            AppendTo(output, "\t\t\tguiParameters.minZ = ",minZcoord,";\n\n");

            AppendTo(output, "\t\t\tguiParameters.planeX = ",(minXcoord+maxXcoord)/2,";\n");
            AppendTo(output, "\t\t\tguiParameters.planeY = ",(minYcoord+maxYcoord)/2,";\n");
            AppendTo(output, "\t\t\tguiParameters.planeZ = ",(minZcoord+maxZcoord)/2,";\n");
        fi;
    fi;

    AppendTo( output, __GAPIC__ReadTemplateFromFile("three_end.template") );

    CloseStream(output);
    return printRecord;
    end
);
