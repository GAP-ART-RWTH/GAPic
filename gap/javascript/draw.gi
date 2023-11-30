BindGlobal( "__GAPIC__IsCoordinates3D",
    function(surface, coordinates)
        local coord,i, j, diff;

        # check if every vertex has a coordinate set
        diff := Difference(Vertices(surface), Filtered([1..Length(coordinates)],i->IsBound(coordinates[i])));
        if not IsEmpty(diff) then
            return [false, diff];
	    fi;

        # Check whether all coordinates are dense lists of 3 floats or ints
        for coord in coordinates do
            if not IsDenseList(coord) then
                return [false, Position(coordinates, coord), coord];
            fi;
            if Length(coord) <> 3 then
                return [false, Position(coordinates, coord), coord];
            fi;
            for j in coord do
                if not IsFloat(j) then
                    if not IsInt(j) then
                        return [false, Position(coordinates, coord), j];
                    fi;
                fi;
            od;
        od;
        return [true];
    end
);

InstallMethod( SetVertexCoordinates3D,
    "for a simplicial surface, a list of coordinates and a record",
    [IsTriangularComplex, IsList, IsRecord],
    function(surface, coordinates, printRecord)
    local error;
    error := __GAPIC__IsCoordinates3D(surface, coordinates);
	if not error[1] then
        if IsBound(error[3]) then
            Error( "invalid coordinate format at coordinate: ", error[2], " and with content: ", error[3], " \n");
        else
            Error( "invalid, coordinates not set for vertices ", error[2] , "\n");
        fi;
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
	local error;
    error := __GAPIC__IsCoordinates3D(surface, printRecord.vertexCoordinates3D);
	if not error[1] then
        if IsBound(error[3]) then
            Error( "invalid coordinate format at coordinate: ", error[2], " and with content: ", error[3], " \n");
        else
            Error( "invalid, coordinates not set for vertices ", error[2] , "\n");
        fi;
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
        if not IsBound(printRecord.drawInnerCircles) then
            return true;
        fi;
        if not IsBound(printRecord.drawInnerCircles[face]) then
            return true;
        fi;
        return printRecord.drawInnerCircles[face] = true;
    end
);

InstallMethod( ActivateNormalOfInnerCircles,
    "for a simplicial surface and a record",
    [IsTriangularComplex, IsRecord],
    function(surface, printRecord)
        local face;
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
        if not IsBound(printRecord.drawNormalOfInnerCircles) then
            return true;
        fi;
        if not IsBound(printRecord.drawNormalOfInnerCircles[face]) then
            return true;
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
		local circleColours, i;
        circleColours := [];
        for i in [1..Length(Edges(surface))] do
            Add(circleColours, GetCircleColour(surface, i, printRecord));
        od;

        return circleColours;
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

InstallMethod( ActivateLineWidth,
    [IsTriangularComplex, IsRecord],
    function(surface,printRecord)
    printRecord.lineWidth := true;
 
	return printRecord;
    end
);

InstallMethod( DeactivateLineWidth,
    [IsTriangularComplex, IsRecord],
    function(surface,printRecord)
    printRecord.lineWidth := false;
 
	return printRecord;
    end
);

InstallMethod( IsLineWidth,
    [IsTriangularComplex, IsRecord],
    function(surface,printRecord)
    if not IsBound(printRecord.lineWidth) then
        return false;
    fi;
 
	return printRecord.linewidth;
    end
);

InstallMethod( ActivatePerformanceOverlay,
    [IsTriangularComplex, IsRecord],
    function(surface,printRecord)
    printRecord.performanceOverlay := true;
 
	return printRecord;
    end
);

InstallMethod( DeactivatePerformanceOverlay,
    [IsTriangularComplex, IsRecord],
    function(surface,printRecord)
    printRecord.performanceOverlay := false;
 
	return printRecord;
    end
);

InstallMethod( IsPerformanceOverlay,
    [IsTriangularComplex, IsRecord],
    function(surface,printRecord)
    if not IsBound(printRecord.performanceOverlay) then
        return false;
    fi;
    
	return printRecord.performanceOverlay;
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
        incenter,inradius, normal, a, b, c, material, vertexParameters, p, vertexParameterNames, vertexParameterString,
        maxXcoord, maxYcoord, maxZcoord, minXcoord, minYcoord, minZcoord, x, y, z, range, vertexA, vertexB, vertexC,
        uniqueEdgeColorsActive, delete, pos, error;

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

    # Check if surface is in 3d coords to use NC versions later
    if not IsParameterizedVertices(surface, printRecord) then
        error := __GAPIC__IsCoordinates3D(surface, printRecord.vertexCoordinates3D);
        if not error[1] then
            if IsBound(error[3]) then
                Error( "invalid coordinate format at coordinate: ", error[2], " and with content: ", error[3], " \n");
            else
                Error( "invalid, coordinates not set for vertices ", error[2] , "\n");
            fi; 
        fi;
    fi;

    # generate a list of all unique colors of the edges and faces
    # vertexColors := GetVertexColours(surface, printRecord);
    # uniqueVertexColors := [];
    # for color in vertexColors do
    #     if not color in uniqueVertexColors then
    #         Add(uniqueVertexColors, color);
    #     fi; 
    # od;
    
    edgeColors := GetEdgeColours(surface, printRecord);
    uniqueEdgeColors := [];
    for color in edgeColors do
        if not color in uniqueEdgeColors then
            Add(uniqueEdgeColors, color);
        fi; 
    od;
    
    faceColors := GetFaceColours(surface, printRecord);
    uniqueFaceColors := [];
    for color in faceColors do
        if not color in uniqueFaceColors then
            Add(uniqueFaceColors, color);
        fi; 
    od;

    AppendTo(output, "\n\t// --- start of generated output --- //\n\n");

    # write the incidence, colours and coordinates in a single place to reduce storage later
    # all the numbers are going to be relative to a dense list of [1..NumberOfVertices(surface)] as to make adressing them easy in JS
    # vertices:=Vertices(surface);
    # AppendTo(output, "\tconst numberOfVertices = ", NumberOfVertices(surface), ";\n\n");

    # AppendTo(output, "\tconst coordinates = [\n");
    # for vertex in [1..NumberOfVertices(surface)] do
    #     AppendTo(output, "\t\t", GetVertexCoordinates3DNC(surface, vertices[vertex], printRecord), ",\n");
    # od;
    # AppendTo(output, "\t];\n\n");

    # AppendTo(output, "\tconst uniqueVertexColors = [\n");
    # for colour in uniqueVertexColors do
    #     AppendTo(output, "\t\t\"", colour ,"\",\n");
    # od;
    # AppendTo(output, "\t];\n\n");

    # AppendTo(output, "\t// the vertex colours w.r.t. the uniqueVertexColours defined before so vertex[i] has uniqueVertexColour[vertexColour[i]]\n");
    # AppendTo(output, "\tconst vertexColors = [");
    # for vertex in Vertices(surface) do
    #     AppendTo(output, Position(uniqueVertexColors, GetVertexColour(oct, vertex, printRecord)) ,", ");
    # od;
    # AppendTo(output, "];\n\n");

    # AppendTo(output, "\tconst edges = [\n");
    # for edge in Edges(surface) do
    #     AppendTo(output, "\t\t[", Position(vertices, VerticesOfEdge(surface, edge)[1]), ", ", Position(vertices, VerticesOfEdge(surface, edge)[2]), "],\n");
    # od;
    # AppendTo(output, "\t];\n\n");

    # AppendTo(output, "\tconst uniqueEdgeColors = [\n");
    # for colour in uniqueEdgeColors do
    #     AppendTo(output, "\t\t\"", colour ,"\",\n");
    # od;
    # AppendTo(output, "\t];\n\n");

    # AppendTo(output, "\t// the edge colours w.r.t. the uniqueEdgeColours defined before so edge[i] has uniqueEdgeColour[edgeColour[i]]\n");
    # AppendTo(output, "\tconst edgeColors = [");
    # for edge in Edges(surface) do
    #     AppendTo(output, Position(uniqueEdgeColors, GetEdgeColour(oct, edge, printRecord)) ,", ");
    # od;
    # AppendTo(output, "];\n\n");

    # AppendTo(output, "\tconst faces = [\n");
    # for face in Faces(surface) do
    #     AppendTo(output, "\t\t[", Position(vertices, VerticesOfFace(surface, face)[1]), ", ", 
    #                                 Position(vertices, VerticesOfFace(surface, face)[2]),", ", 
    #                                 Position(vertices, VerticesOfFace(surface, face)[3]), "],\n");
    # od;
    # AppendTo(output, "\t];\n\n");

    # AppendTo(output, "\tconst uniqueFaceColors = [\n");
    # for colour in uniqueFaceColors do
    #     AppendTo(output, "\t\t\"", colour ,"\",\n");
    # od;
    # AppendTo(output, "\t];\n\n");

    # AppendTo(output, "\t// the face colours w.r.t. the uniqueFaceColours defined before so face[i] has uniqueFaceColour[faceColour[i]]\n");
    # AppendTo(output, "\tconst faceColors = [");
    # for face in Faces(surface) do
    #     AppendTo(output, Position(uniqueFaceColors, GetFaceColour(oct, face, printRecord)) ,", ");
    # od;
    # AppendTo(output, "];\n\n");

    # preperations for parameterized vertex coordinates
    AppendTo(output, "\t// preperations for parameterized vertex coordinates \n");
    vertexParameterNames := "";
    vertexParameterString := "";
    if IsParameterizedVertices(surface, printRecord) then
        vertexParameters := GetVertexParameters(surface, printRecord);

        AppendTo(output, "\tvar vParams = new function(){\n");
        for p in vertexParameters do
            AppendTo(output, "\t\tthis.",p[1],"=",p[2],";\n");
        od;
        AppendTo(output, "\t}\n\n");

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

        AppendTo(output, "\tconst vertexParametriziation = true;\n");

        AppendTo(output, "\tconst parameterFolder = gui.addFolder(\"Parameters\");\n");
        for p in vertexParameters do
            AppendTo(output, "\tparameterFolder.add(vParams, '",p[1],"', ",p[3][1],",",p[3][2],");\n");
        od;
        AppendTo(output, "\tparameterFolder.open();\n\n");
    else 
        AppendTo(output, "\tconst vertexParametriziation = false;\n");
    fi;

    # add faces to geometry by iterating over all colors
    # for each color there is a new geometry and material generated. these are then combined into a mesh and added to the root group
    # for each of the unique colors add the faces to a gemeometry and generate a mesh with corresponding color from it
    # also generate a wireframe which can be made visible via the gui
    AppendTo(output, "\t// generate the faces color by color \n");
    for i in [1..Length(uniqueFaceColors)] do
        color := uniqueFaceColors[i];
        if not StartsWith(color, "0x") then
            colour := Concatenation("\"", color, "\"");
        fi;

        # generate a geometry with all vertices of the faces belonging to the current face
        AppendTo(output, "\tconst geometry",i," = new THREE.BufferGeometry();\n");
        AppendTo(output, "\tfunction setVertices",i,"(",vertexParameterNames,"){\n");
        AppendTo(output, "\t\tvar vertices",i," = new Float32Array( [\n\t\t\t\t");

        colorPositions := Positions(faceColors, color);
        for face in colorPositions do
            if IsFaceActive(surface, face, printRecord) then
                # we assume there is always at least one active face               
                # as we can assume that all faces of a simplicial surface have exactly 3 vertices we add them to the geometry individually
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[1], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[2], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1], printRecord)[3], ",\n\t\t\t");

                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[1], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[2], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2], printRecord)[3], ",\n\t\t\t");

                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[1], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[2], ",");
                AppendTo(output, GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3], printRecord)[3], ",\n\n\t\t\t");
            fi;
        od;
        AppendTo(output, "\t\t] ); \n\n");
        AppendTo(output, "\t\treturn vertices",i,"; \n\t}\n\n");

        AppendTo(output, "\tgeometry",i,".setAttribute( 'position', new THREE.BufferAttribute( setVertices",i,"(",vertexParameterString,"), 3 ) );\n\n");

        AppendTo(output, "\t// generate materials in the given color and normals material for the faces \n");
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

        AppendTo(output, "\n\t// generate meshes for the faces from the materials with the vertex coordinates from before \n");
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
        AppendTo(output, "function updateFaceCoordinates(){\n");
        for i in [1..Length(uniqueFaceColors)] do
            AppendTo(output, "\t\tgeometry",i,".setAttribute( 'position', new THREE.BufferAttribute( setVertices",i,"(",vertexParameterString,"), 3 ) );\n");
        od;
        AppendTo(output, "\t}\n\n");
    fi;

    # add edges to geometry by iterating over all colors
    # for each color there is a new geometry and material generated. these are then combined into a mesh and added to the edgeRoot group
    AppendTo(output, "\n\t// generate the edges grouped by color\n");

    uniqueEdgeColorsActive := [];
    for color in uniqueEdgeColors do
        delete := true;
        colorPositions := Positions(edgeColors, color);
        for pos in colorPositions do
            edge := Edges(surface)[pos];
            if IsEdgeActive(surface, edge, printRecord) then
                delete := false;
            fi;
        od;
        if not delete then
            Add(uniqueEdgeColorsActive, color);
        fi;
    od;

    # remove slider if not functional
    if not IsLineWidth(surface, printRecord) then
        AppendTo(output, "\t\tcontrolFolder.remove(edgeWidthGUI);\n");
    fi;

    # for each of the unique colors add the edges to a gemeometry and generate a mesh with corresponding color from it
    for i in [1..Length(uniqueEdgeColorsActive)] do
        color := uniqueEdgeColorsActive[i];
        if not StartsWith(color, "0x") then
            colour := Concatenation("\"", color, "\"");
        fi;

        edgeThickness := printRecord.edgeThickness*100;
        

        if IsLineWidth(surface, printRecord) then
            AppendTo(output, """
    const edgeMaterial""",i,""" = new LineMaterial( {
        color: """,color,""",
        linewidth: """,edgeThickness,""",
    } );
        """);
        else
            AppendTo(output, """
    const edgeMaterial""",i,""" = new THREE.LineBasicMaterial( {
        color: """,color,""",
        linewidth: """,edgeThickness,""",
    } );
        """);
        fi;

        AppendTo(output, "\n\tfunction getEdges",i,"(",vertexParameterNames,"){\n");
        AppendTo(output, "\t\tconst edges",i," = new Float32Array( [\n");

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

                AppendTo(output, "\t\t\t",coordinateStringA,"\n\t\t\t",coordinateStringB,"\n\n");
            fi;
        od;

        AppendTo(output, "\t\t]);\n");

        AppendTo(output, "\t\treturn edges",i,";\n\t}\n\n");

        AppendTo(output, "\n\t// generate geometries and lines for the edges \n");

        if IsLineWidth(surface, printRecord) then
            AppendTo(output, """
    const edgeGeometry""",i,""" = new LineSegmentsGeometry();
    edgeGeometry""",i,""".setPositions(getEdges""",i,"""(""",vertexParameterString,""") );

    const edgeLine""",i,""" = new Line2( edgeGeometry""",i,""", edgeMaterial""",i,""" );
    edgeRoot.add(edgeLine""",i,""");
        """);

            AppendTo(output, "\n\t// update function to be called every frame \n");
            if IsParameterizedVertices(surface, printRecord) then
                AppendTo(output, "\n\tfunction updateEdgeCoordinates(){\n");
                for i in [1..Length(uniqueFaceColors)] do
                    AppendTo(output, "\t\tedgeGeometry",i,".setPositions(getEdges",i,"(",vertexParameterString,") );\n");
                od;
                AppendTo(output, "\t}\n\n");
            fi; 
        else
            AppendTo(output, """
    const edgeGeometry""",i,""" = new THREE.BufferGeometry();
    edgeGeometry""",i,""".setAttribute( 'position', new THREE.BufferAttribute( getEdges""",i,"""(""",vertexParameterString,"""), 3 ) );

    const edgeLine""",i,""" = new THREE.LineSegments( edgeGeometry""",i,""", edgeMaterial""",i,""" );
    edgeRoot.add(edgeLine""",i,""");
        """);

            AppendTo(output, "\n\t// update function to be called every frame \n");
            if IsParameterizedVertices(surface, printRecord) then
                AppendTo(output, "\n\tfunction updateEdgeCoordinates(){\n");
                for i in [1..Length(uniqueFaceColors)] do
                    AppendTo(output, "\t\tedgeGeometry",i,".setAttribute( 'position', new THREE.BufferAttribute( getEdges",i,"(",vertexParameterString,"), 3 ) );\n");
                od;
                AppendTo(output, "\t}\n\n");
            fi; 
        fi;
    od;

    # generate a string with the coordinates for later use
    for vertex in Vertices(surface) do
        coordinateString := "";
        Append(coordinateString, String(GetVertexCoordinates3DNC(surface, vertex, printRecord)[1]));
        Append(coordinateString, ",");
        Append(coordinateString, String(GetVertexCoordinates3DNC(surface, vertex, printRecord)[2]));
        Append(coordinateString, ",");
        Append(coordinateString, String(GetVertexCoordinates3DNC(surface, vertex, printRecord)[3]));
        Append(coordinateString, ",");

        AppendTo(output, "\n\n\tfunction getVertex",vertex,"(",vertexParameterNames,"){\n");
        AppendTo(output, "\t\treturn [",coordinateString,"];\n\t}\n");
    od;

    # add spheres and lables on all vertices if they are active
    AppendTo(output, "\t// generate labels and spheres for the vertices\n");
    for vertex in Vertices(surface) do
        if IsVertexActive(surface, vertex, printRecord) then
            # add spheres with radius edgeThickness around the active vertices
            AppendTo(output, "\tconst sphereMaterial",vertex," = new THREE.MeshBasicMaterial( { color: ",GetVertexColour(surface, vertex, printRecord)," } );\n");
            AppendTo(output, "\tconst sphere",vertex," = new THREE.Mesh( sphereGeometry, sphereMaterial",vertex," );\n");
            AppendTo(output, "\tvertexRoot.add(sphere",vertex,");\n");
            AppendTo(output, "\tsphere",vertex,".position.set(getVertex",vertex,"(",vertexParameterString,")[0],"); 
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

    if IsParameterizedVertices(surface, printRecord) then
    AppendTo(output, "\n\t// function to call every frame and update the vertex coordinates \n");
        AppendTo(output, "\n\tfunction updateVertexCoordinates(){\n");
        for vertex in Vertices(surface) do
            if IsVertexActive(surface, vertex, printRecord) then 
                # in three steps as return is an array
                AppendTo(output, "\tsphere",vertex,".position.set(getVertex",vertex,"(",vertexParameterString,")[0],"); 
                AppendTo(output, "getVertex",vertex,"(",vertexParameterString,")[1],");
                AppendTo(output, "getVertex",vertex,"(",vertexParameterString,")[2]);\n");
                AppendTo(output, "\tvertexLabel",vertex,".position.set(getVertex",vertex,"(",vertexParameterString,")[0],");
                AppendTo(output, "getVertex",vertex,"(",vertexParameterString,")[1],");
                AppendTo(output, "getVertex",vertex,"(",vertexParameterString,")[2]);\n\n");
            fi;
        od;
        AppendTo(output, "\t}\n\n");
    fi;

    # generate innercircle for all (active) innercircle faces
    AppendTo(output, "\t// generate the rings for the incircles \n");
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

            AppendTo(output, "\n\tvar inradius",face," = calulateInradius(getVertex",vertexA,"(",vertexParameterString,"), getVertex",vertexB,"(",vertexParameterString,"), getVertex",vertexC,"(",vertexParameterString,"));\n");
            AppendTo(output, "\tvar incenter",face," = calulateIncenter(getVertex",vertexA,"(",vertexParameterString,"), getVertex",vertexB,"(",vertexParameterString,"), getVertex",vertexC,"(",vertexParameterString,"));\n");

            AppendTo(output, "\tvar ringGeometry",face," = new THREE.RingGeometry((inradius",face," - 0.005),inradius",face,", 32);\n");
            AppendTo(output, "\tconst ringMaterial",face," = new THREE.LineBasicMaterial( { color: ",GetCircleColour(surface, face, printRecord),", side: THREE.DoubleSide } );\n");
            AppendTo(output, "\tconst ringMesh",face," = new THREE.Mesh(ringGeometry",face,", ringMaterial",face,");\n");
        
            AppendTo(output, "\n\tfunction setCircleRotation",face,"(",vertexParameterNames,"){\n");
            
            AppendTo(output, """
        //translate ring to incenter
        var incenter = calulateIncenter([""",coordinateStringA,"""],[ """,coordinateStringB,"""],[""",coordinateStringC,"""]);

        ringMesh""",face,""".position.setX(incenter[0]);
        ringMesh""",face,""".position.setY(incenter[1]);
        ringMesh""",face,""".position.setZ(incenter[2]);

        // set the size right. Is done relative to the initial value, as we can only scale the mesh
        var inradius = calulateInradius(getVertex""",vertexA,"""(""",vertexParameterString,"""), getVertex""",vertexB,"""(""",vertexParameterString,"""), getVertex""",vertexC,"""(""",vertexParameterString,"""));
        var relRadius = inradius/inradius""",face,""";

        ringMesh""",face,""".scale.set(relRadius, relRadius, relRadius);

        // rotate ring to right angle
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
    AppendTo(output, "\t// function to update the circles every frame \n");
    AppendTo(output, "\tfunction updateCircles(){\n");
    for face in Faces(surface) do
        if(IsInnerCircleActive(surface, face, printRecord)) then
            AppendTo(output, "\t\tsetCircleRotation",face,"(",vertexParameterString,");\n");
        fi;
    od;
    AppendTo(output, "\t}\n\n");
    AppendTo(output, "\t// needs to be called once to be initialized \n");
    AppendTo(output, "\tupdateCircles();\n\n");

    # set circle width from the gui
    AppendTo(output, "\t// function to update the circles width, that is called every frame even if the surface is not parameterized \n");
    AppendTo(output, "\tfunction updateCircleWidth(){\n");
    for face in Faces(surface) do
        if(IsInnerCircleActive(surface, face, printRecord)) then
            AppendTo(output, "\t\tringGeometry",face,".dispose();\n");
            AppendTo(output, "\t\tringGeometry",face," = new THREE.RingGeometry((inradius",face," - guiParameters.circleWidth),inradius",face,", 32);\n");
            AppendTo(output, "\t\tringMesh",face,".geometry = ringGeometry",face,"; \n");
        fi;
    od;
    AppendTo(output, "\t}\n\n");
    AppendTo(output, "\tupdateCircleWidth();\n\n");
    
    # we first get the parameterized vectors which define the normal of the faces
    AppendTo(output, "\t// generate the normals trough the incenter orthogonal to the face \n");
    AppendTo(output, "\t// getNormalsVectors generates the coordinates for the current values of the parameterized surface \n");
    AppendTo(output, "\tfunction getNormalsVectors(",vertexParameterNames,"){\n");
    AppendTo(output, "\t\tvar vector1;\n");
    AppendTo(output, "\t\tvar vector2;\n\n");
    AppendTo(output, "\t\tvar normals = [];\n");
    for face in Faces(surface) do
        if IsNormalOfInnerCircleActive(surface, face, printRecord) then
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

            a := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[1] ,printRecord);
            b := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[2] ,printRecord);
            c := GetVertexCoordinates3DNC(surface, VerticesOfFace(surface, face)[3] ,printRecord);

            AppendTo(output, "\t\tvector1 = [];\n");
            AppendTo(output, "\t\tvector2 = [];\n");

            AppendTo(output, "\t\tvector1[0] = (",b[1],")-(",a[1],");\n");
            AppendTo(output, "\t\tvector1[1] = (",b[2],")-(",a[2],");\n");
            AppendTo(output, "\t\tvector1[2] = (",b[3],")-(",a[3],");\n\n");

            AppendTo(output, "\t\tvector2[0] = (",c[1],")-(",a[1],");\n");
            AppendTo(output, "\t\tvector2[1] = (",c[2],")-(",a[2],");\n");
            AppendTo(output, "\t\tvector2[2] = (",c[3],")-(",a[3],");\n\n");

            AppendTo(output, "\t\tvar incenter = calulateIncenter([",coordinateStringA,"],[ ",coordinateStringB,"],[",coordinateStringC,"]);\n");

            AppendTo(output, "\t\tnormals.push([vector1, vector2, incenter]);\n\n");
        fi;
    od;
    AppendTo(output, "\treturn normals;\n");
    AppendTo(output, "\t}\n");

    # then we calculate the normals after evaluating them with the current parameters
    AppendTo(output, "\t// getNormalsCoordinates calculates the right coordinates for the ortogonality and fitting values from the gui \n");
    AppendTo(output, "\tfunction getNormalsCoordinates(){\n");
    AppendTo(output, "\t\tvar res = [];\n");
    AppendTo(output, "\t\tvar normals = getNormalsVectors(",vertexParameterString,");");
    AppendTo(output, """ 
        for(var i = 0; i < normals.length; i++){
            var plus = [];
            var minus = [];

            minus[0] = normals[i][2][0] - (1/2)*guiParameters.normalsLength*(normals[i][0][1]*normals[i][1][2] - normals[i][0][2]*normals[i][1][1]);
            minus[1] = normals[i][2][1] - (1/2)*guiParameters.normalsLength*(normals[i][0][2]*normals[i][1][0] - normals[i][0][0]*normals[i][1][2]);
            minus[2] = normals[i][2][2] - (1/2)*guiParameters.normalsLength*(normals[i][0][0]*normals[i][1][1] - normals[i][0][1]*normals[i][1][0]);

            plus[0] = normals[i][2][0] + (1/2)*guiParameters.normalsLength*(normals[i][0][1]*normals[i][1][2] - normals[i][0][2]*normals[i][1][1]);
            plus[1] = normals[i][2][1] + (1/2)*guiParameters.normalsLength*(normals[i][0][2]*normals[i][1][0] - normals[i][0][0]*normals[i][1][2]);
            plus[2] = normals[i][2][2] + (1/2)*guiParameters.normalsLength*(normals[i][0][0]*normals[i][1][1] - normals[i][0][1]*normals[i][1][0]);

            res.push(minus[0]);
            res.push(minus[1]);
            res.push(minus[2]);
            res.push(plus[0]);
            res.push(plus[1]);
            res.push(plus[2]);
        }
        res = Float32Array.from(res);

    """);
    
    AppendTo(output, "\n\t\treturn res;\n");
    AppendTo(output, "\t}\n\n");

    AppendTo(output, """
    const normalsMaterial = new THREE.LineBasicMaterial( {
        color: 0x000000,
    } );
    """);

    AppendTo(output, """
    const normalsGeometry = new THREE.BufferGeometry();
    normalsGeometry.setAttribute( 'position', new THREE.BufferAttribute( getNormalsCoordinates(), 3 ) );
    var normalsLine = new THREE.LineSegments( normalsGeometry, normalsMaterial );

    function updateNormals(){
        normalsGeometry.setAttribute( 'position', new THREE.BufferAttribute( getNormalsCoordinates(), 3 ) );
        normalsLine = new THREE.LineSegments( normalsGeometry, normalsMaterial );
    }
    
    normalsRoot.add(normalsLine);

    """);
    AppendTo(output, "\n");

    # only try automatic vertices if not parameterized, otherwise to complicated
    AppendTo(output, "\t// generate automatic ranges for the intersections if the surface is not parameterized \n");
    if not GetPlaneRange(surface, printRecord) = fail then
        range := GetPlaneRange(surface, printRecord);
        AppendTo(output, "\tguiParameters.maxX = ",range[1][2],";\n");
        AppendTo(output, "\tguiParameters.maxY = ",range[2][2],";\n");
        AppendTo(output, "\tguiParameters.maxZ = ",range[3][2],";\n");
        AppendTo(output, "\tguiParameters.minX = ",range[1][1],";\n");
        AppendTo(output, "\tguiParameters.minY = ",range[2][1],";\n");
        AppendTo(output, "\tguiParameters.minZ = ",range[3][1],";\n\n");
    else
        if not IsParameterizedVertices(surface, printRecord) then
            # calculate maximal values in all directions for intersection plane slider and automatic camera position
            maxXcoord := Float(GetVertexCoordinates3DNC(surface, Vertices(surface)[1], printRecord)[1]);
            maxYcoord := Float(GetVertexCoordinates3DNC(surface, Vertices(surface)[1], printRecord)[2]);
            maxZcoord := Float(GetVertexCoordinates3DNC(surface, Vertices(surface)[1], printRecord)[3]);
            minXcoord := Float(GetVertexCoordinates3DNC(surface, Vertices(surface)[1], printRecord)[1]);
            minYcoord := Float(GetVertexCoordinates3DNC(surface, Vertices(surface)[1], printRecord)[2]);
            minZcoord := Float(GetVertexCoordinates3DNC(surface, Vertices(surface)[1], printRecord)[3]);
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

            AppendTo(output, "\tguiParameters.maxX = ",maxXcoord,";\n");
            AppendTo(output, "\tguiParameters.maxY = ",maxYcoord,";\n");
            AppendTo(output, "\tguiParameters.maxZ = ",maxZcoord,";\n");
            AppendTo(output, "\tguiParameters.minX = ",minXcoord,";\n");
            AppendTo(output, "\tguiParameters.minY = ",minYcoord,";\n");
            AppendTo(output, "\tguiParameters.minZ = ",minZcoord,";\n\n");

            AppendTo(output, "\tguiParameters.planeX = ",(minXcoord+maxXcoord)/2,";\n");
            AppendTo(output, "\tguiParameters.planeY = ",(minYcoord+maxYcoord)/2,";\n");
            AppendTo(output, "\tguiParameters.planeZ = ",(minZcoord+maxZcoord)/2,";\n");
        fi;
    fi;

    # enable performance overlay if enabled
    AppendTo(output, "\tvar performanceOverlayEnabled = false;\n");
    if IsPerformanceOverlay(surface, printRecord) then
        AppendTo(output, """
        // add performance overlay
        import Stats from 'three/addons/libs/stats.module';

        const stats = new Stats();
        document.body.appendChild(stats.dom);    
        performanceOverlayEnabled = true;
        """);
    fi;

    AppendTo(output, "\t// --- end of generated output --- //\n\n");

    AppendTo( output, __GAPIC__ReadTemplateFromFile("three_end.template") );

    CloseStream(output);
    return printRecord;
    end
);
