# Basic concept:
# 
# The drawing method relies on the following separation: First, a complex
# is divided into its strongly connected components. Then, each of these
# components is split into several "drawing blocks" (depending on the
# concrete edge lengths). Each of these drawing blocks is assigned a "drawIndex".
#
# The general method starts with one face of a strongly connected
# component and draws this face.


BindGlobal("__SIMPLICIAL_EqualFloats",
    function(x,y, eps)
        return (x-y)^2 < eps;
    end
);
BindGlobal( "__SIMPLICIAL_EqualPoints",
    function( p, q, eps )
        return (p[1]-q[1])^2 + (p[2]-q[2])^2 < eps;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordInitStringList",
    function(printRecord, entry, indices)
        local ls, i;

        if not IsBound(printRecord!.(entry)) then
            printRecord!.(entry) := [];
            return;
        fi;

        if printRecord!.(entry) = [] then
            return;
        fi;

        if IsString( printRecord!.(entry) ) then
            ls := [];
            for i in indices do
                ls[i] := printRecord!.(entry);
            od;
            printRecord!.(entry) := ls;
            return;
        fi;

        if not IsList( printRecord!.(entry) ) then
            printRecord!.(entry) := [];
        fi;

        printRecord!.(entry) := List( printRecord!.(entry), String );
    end
);
BindGlobal( "__SIMPLICIAL_PrintRecordInitBool",
    function(printRecord, entry, default)
        if not IsBound(printRecord!.(entry)) or not IsBool(printRecord!.(entry)) then
            printRecord!.(entry) := default;
        fi;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordInit",
    function(printRecord, surface)
        local givenStarts, v, e, givenEdgeDrawOrder, i, col, f;

        # Starting faces
        if not IsBound(printRecord.startingFaces) and IsBound(printRecord.startingFace) then
            # If someone spells startingFace instead of startingFaces, we are lenient..
            printRecord.startingFaces := printRecord.startingFace;
            Unbind(printRecord.startingFace);
        fi;
        if IsBound(printRecord!.startingFaces) then
            if IsPosInt(printRecord!.startingFaces) then
                givenStarts := [ printRecord!.startingFaces ];
            elif IsList( printRecord!.startingFaces ) and ForAll( printRecord!.startingFaces, IsPosInt ) then
                givenStarts := printRecord!.startingFaces;
            else
                Print("Given starting faces are neither a list of faces nor a single face.");
                givenStarts := [];
            fi;
        else
            givenStarts := [];
        fi;
        printRecord!.givenStartingFaces := givenStarts;
        printRecord!.startingFaces := [];
        
        # Edge draw order
        if IsBound(printRecord.edgeDrawOrder) then
            givenEdgeDrawOrder := printRecord.edgeDrawOrder;
            if not IsList(givenEdgeDrawOrder) then
                givenEdgeDrawOrder := [];
            elif ForAll( givenEdgeDrawOrder, IsPosInt ) then
                givenEdgeDrawOrder := [ givenEdgeDrawOrder ];
            fi;
            #TODO more checks and warnings?
        else
            givenEdgeDrawOrder := [];
        fi;
        printRecord!.givenEdgeDrawOrder := givenEdgeDrawOrder;
        printRecord!.edgeDrawOrder := [];

        # Draw components and drawing indices
        printRecord.drawComponents := [];
        printRecord.drawIndices := [];

        # edge lengths and angles
        if not IsBound( printRecord!.edgeLengths ) then
            printRecord!.edgeLengths := [];
        fi;
        printRecord!.givenEdgeLengths := printRecord!.edgeLengths;

        if not IsBound( printRecord!.angles ) then
            printRecord!.angles := [];
        fi;
        printRecord!.givenAngles := printRecord!.angles;

        # float accuracy
        if not IsBound( printRecord!.floatAccuracy ) then
            printRecord!.floatAccuracy := 0.001;
        fi;

        # coordinates (always recomputed)
        printRecord!.vertexCoordinates := [];
        for v in VerticesAttributeOfComplex(surface) do
            printRecord!.vertexCoordinates[v] := [];
        od;
        printRecord!.edgeEndpoints := [];
        for e in Edges(surface) do
            printRecord!.edgeEndpoints[e] := [];
        od;
        printRecord!.faceVertices := [];
        for f in Faces(surface) do
            printRecord.faceVertices[f] := [];
        od;

        # openEdges
        printRecord!.openEdges := [];


        # drawing options
        __SIMPLICIAL_PrintRecordInitBool( printRecord, "vertexLabelsActive", true );
        __SIMPLICIAL_PrintRecordInitStringList( printRecord, "vertexLabels", 
            VerticesAttributeOfComplex(surface) );

        __SIMPLICIAL_PrintRecordInitBool( printRecord, "edgeLabelsActive", true );
        __SIMPLICIAL_PrintRecordInitStringList( printRecord, "edgeLabels", Edges(surface) );

        __SIMPLICIAL_PrintRecordInitBool( printRecord, "faceLabelsActive", true );
        __SIMPLICIAL_PrintRecordInitStringList( printRecord, "faceLabels", Faces(surface) );
        
        if not IsBound( printRecord!.scale ) then
            printRecord!.scale := 2;
        fi;
        __SIMPLICIAL_PrintRecordInitBool(printRecord, "avoidIntersections", true);

        # colours
        __SIMPLICIAL_PrintRecordInitStringList(printRecord, "vertexColours", 
            VerticesAttributeOfComplex(surface));
        __SIMPLICIAL_PrintRecordInitStringList(printRecord, "edgeColours", Edges(surface));
        __SIMPLICIAL_PrintRecordInitStringList(printRecord, "faceColours", Faces(surface));
        # if the faceColours are custom given, we check for errors
        for i in [1..Length(printRecord!.faceColours)] do
            if IsBound( printRecord!.faceColours[i] ) then
                col := printRecord!.faceColours[i];
                if StartsWith( col, "\\faceColour" ) then
                    Remove(col,10);
                    printRecord!.faceColours[i] := col;
                fi;
            fi;
        od;
#        if not IsBound( printRecord!.faceSwapColoursActive ) then
#            printRecord!.faceSwapColoursActive := false;
#        fi;


        # automatic compilation
        __SIMPLICIAL_PrintRecordInitBool( printRecord, "compileLaTeX", false );
        # only write the tikzpicture (this will not be able to compile on its own!)
        __SIMPLICIAL_PrintRecordInitBool( printRecord, "onlyTikzpicture", false );
        if printRecord!.compileLaTeX and printRecord!.onlyTikzpicture then
            Error("DrawSurfaceToTikz: The options 'compileLaTeX' and 'onlyTikzpicture' can't be true simultaneously.");
        fi;

        if not IsBound(printRecord.latexDocumentclass) then
            printRecord.latexDocumentclass := "article";
        fi;

        __SIMPLICIAL_PrintRecordInitBool(printRecord, "noOutput", false);
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordCleanup",
    function(printRecord)
        Unbind( printRecord!.openEdges );
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordInitializePolygons",
    function(printRecord, surface)
        local lengths, angles, edges, vertices, f, v, e, regAngle, sin, cos,
            radAngles, angleSum, i, oppVert, j, k;

        lengths := printRecord!.edgeLengths;
        angles := printRecord!.angles;

        #TODO allow different way to give angles

        # each angle is stored as a pair of floats [sin(alpha), cos(alpha)]
        for f in Faces(surface) do
            edges := EdgesOfFaces(surface)[f];
            vertices := VerticesOfFaces(surface)[f];
            if not IsBound(angles[f]) then
                angles[f] := [];
            fi;

#TODO can we do something to avoid recomputing angles every time?

            # Case triangle (this will overwrite the angle information!)
            if Length(edges) = 3 and ForAll(edges, e -> IsBound(lengths[e])) then
                for i in [1,2,3] do
                    # find opposing vertex
                    oppVert := Difference(vertices, VerticesOfEdges(surface)[edges[i]])[1];
                    j := i mod 3 + 1;
                    k := (i+1) mod 3 + 1;
                    cos := Float( (lengths[edges[i]]^2 - lengths[edges[j]]^2 - lengths[edges[k]]^2) / ( -2*lengths[edges[j]]*lengths[edges[k]] ) );
                    sin := Sqrt(1 - cos^2);
                    # TODO test validity of edge lengths
                    angles[f][oppVert] := [sin, cos];
                od;
                continue;
            fi;


            # Case all values are set (only relevant for non-triangles because of case before)
            if ForAll(edges, e -> IsBound(lengths[e])) and ForAll(vertices, v -> IsBound(angles[f][v])) then
                # Check inner angle sum
                radAngles := List( vertices, v -> Atan2(angles[f][v][1], angles[f][v][2]) );
                angleSum := Sum( radAngles );
                if not __SIMPLICIAL_EqualFloats( angleSum, ( Length(edges) - 2 )*FLOAT.PI, printRecord!.floatAccuracy ) then
                    Error(Concatenation("Wrong angles for face ", String(f), " given."));
                else
                    continue; # We don't check whether the face closes since this is checked in __SIMPLICIAL_PrintRecordComputeFace
                fi;
            fi;

            # Define everything to be a regular polygon with side length 1
            for e in edges do
                lengths[e] := 1;
            od;
            regAngle := SinCos( (Length(edges) - 2) / Length(edges) * FLOAT.PI );
            for v in vertices do
                angles[f][v] := regAngle;
            od;
        od;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordStartingFace",
    function(printRecord, surface, unplacedFaces)
        local f;

        # Try to find a starting face in the givenStartingFaces
        for f in printRecord!.givenStartingFaces do
            if f in unplacedFaces then
                return f;
            fi;
        od;

        # Otherwise return the smallest remaining face
        return Minimum(unplacedFaces);
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordFindVertex",
    function(printRecord, prVertex, drawIndex)
        local i, pos, compareCoords;

        pos := 0;
        for i in [1..Length(printRecord!.vertexCoordinates[prVertex[1]])] do
            compareCoords := printRecord!.vertexCoordinates[prVertex[1]][i];
            if compareCoords[3] <> drawIndex then
                continue;
            fi;

            # The test only checks the first two entries
            if __SIMPLICIAL_EqualPoints( compareCoords, prVertex[2], printRecord!.floatAccuracy ) then
                pos := i;
                break;
            fi;
        od;

        return pos;
    end
);

# The return value of compute face is complicated since we want to perform 
# some checks after the computation but before we save the data.
# 
# It returns a list with two components:
# 1. A list of vertices around the face, stored either as [v, pos] or [v, coord]
# 2. A list of edges around the face (correctly oriented), stored as
#       [e, vertexPair], where vertexPair consists of two vertex-numbers
#       The initial edge is not part of this list.
BindGlobal( "__SIMPLICIAL_PrintRecordComputeFace",
    function(printRecord, surface, face, edge, drawIndex)
        local givenEdge, givenPRVertexFirst, givenPRVertexSecond, 
            returnedVertices, returnedEdges, lastVertex, lastVertexCoord, 
            currentVertex, currentVertexCoord, lastEdge, vector, nextEdge,
            nextVertex, newVector, angle, nextVertexCoords, pos, i, 
            compareCoords, givenSpecEdge;

        givenEdge := edge;
        # Pick the first edge with the correct drawIndex
        givenSpecEdge := Filtered( printRecord.edgeEndpoints[edge], x -> x[3] = drawIndex )[1];
        givenPRVertexFirst := givenSpecEdge[1];
        givenPRVertexSecond := givenSpecEdge[2];

        returnedVertices := [ givenPRVertexSecond ];
        returnedEdges := [];

        lastVertex := givenPRVertexFirst[1];
        lastVertexCoord := printRecord!.vertexCoordinates[lastVertex][givenPRVertexFirst[2]]{[1,2]};
        currentVertex := givenPRVertexSecond[1];
        currentVertexCoord := printRecord!.vertexCoordinates[currentVertex][givenPRVertexSecond[2]]{[1,2]};
        lastEdge := givenEdge;

        while Length(returnedVertices) < Length(VerticesOfFaces(surface)[face]) do
            vector := lastVertexCoord - currentVertexCoord;

            nextEdge := OtherEdgeOfVertexInFace( surface, currentVertex, lastEdge, face );
            nextVertex := OtherVertexOfEdge( surface, currentVertex, nextEdge );

            # rescale the vector
            vector := vector * Float( printRecord!.edgeLengths[nextEdge] / printRecord!.edgeLengths[lastEdge] );

            # rotate the vector
            angle := printRecord!.angles[face][currentVertex];
            newVector := [ angle[2]*vector[1]+angle[1]*vector[2], -angle[1]*vector[1]+angle[2]*vector[2] ];

            nextVertexCoords := currentVertexCoord + newVector;

            # Check if this vertex coordinates already appear somewhere
            pos := __SIMPLICIAL_PrintRecordFindVertex( printRecord, [nextVertex, nextVertexCoords], drawIndex );
            if pos = 0 then
                Add( returnedVertices, [nextVertex, nextVertexCoords] );
            else
                Add( returnedVertices, [nextVertex, pos] );
            fi;
            Add( returnedEdges, [nextEdge, [nextVertex, currentVertex]]  );

            lastVertex := currentVertex;
            lastVertexCoord := currentVertexCoord;
            currentVertex := nextVertex;
            currentVertexCoord := nextVertexCoords;
            lastEdge := nextEdge;
        od;

        # Check if the face was closed
        lastVertex := returnedVertices[ Length(returnedVertices) ];
        if lastVertex <> givenPRVertexFirst then
            Error("Face does not close.");
        fi;

        return [returnedVertices, returnedEdges];
    end
);
BindGlobal( "__SIMPLICIAL_PrintRecordComputeFirstFace",
    function(printRecord, surface, face, drawIndex)
        local edges, len, verts, res, v1, v2;

        edges := EdgesOfFaces(surface)[face];
        len := printRecord!.edgeLengths[edges[1]];
        verts := VerticesOfEdges(surface)[edges[1]];

        # Save those coordinates
        Add( printRecord!.vertexCoordinates[verts[1]], [0.,0.,drawIndex] );
        Add( printRecord!.vertexCoordinates[verts[2]], [Float(len),0.,drawIndex] );
        v1 := [ verts[1], Length(printRecord.vertexCoordinates[verts[1]]) ];
        v2 := [ verts[2], Length(printRecord.vertexCoordinates[verts[2]]) ];
        Add( printRecord!.edgeEndpoints[edges[1]], [ v1, v2, drawIndex ] );

        res := __SIMPLICIAL_PrintRecordComputeFace( printRecord, surface, face, edges[1], drawIndex );
        printRecord!.edgeEndpoints[edges[1]][Length(printRecord.edgeEndpoints[edges[1]])] := [ v2, v1, drawIndex ];
        return res;
    end
);

BindGlobal( "__SIMPLICIAL_IsFloatZero",
    function( fl, accuracy )
        if AbsoluteValue(fl) < accuracy then
            return 0.;
        else
            return fl;
        fi;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordAddFace",
    function( printRecord, surface, returnedVertices, returnedEdges, face, drawIndex )
        local vertexPositions, prVertex, pos, prEdge, vertices, i, 
            draw, specificVerts, generalVerts, first, second;

        # We store the position of the vertex coordinates
        vertexPositions := [];
        for prVertex in returnedVertices do
            if IsPosInt( prVertex[2] ) then
                vertexPositions[prVertex[1]] := prVertex[2];
            else
                # Try to find this vertex
                pos := __SIMPLICIAL_PrintRecordFindVertex( printRecord, prVertex, drawIndex );
                if pos = 0 then
                    # It is new
                    first := __SIMPLICIAL_IsFloatZero(prVertex[2][1], printRecord.floatAccuracy);
                    second := __SIMPLICIAL_IsFloatZero(prVertex[2][2], printRecord.floatAccuracy);

                    Add( printRecord!.vertexCoordinates[prVertex[1]], [first, second, drawIndex] );
                    pos := Length( printRecord!.vertexCoordinates[prVertex[1]] );
                fi;
                vertexPositions[prVertex[1]] := pos;
            fi;
        od;

        # Add the edges
        for prEdge in returnedEdges do
            vertices := List( prEdge[2], v -> [v, vertexPositions[v]] );
            # Check if the (drawn) edge already exists
            pos := 0;
            draw := true;
            for i in [1..Length(printRecord!.edgeEndpoints[prEdge[1]])] do
                specificVerts := Set( printRecord!.edgeEndpoints[prEdge[1]][i]{[1,2]} );
                generalVerts := List( specificVerts, m -> m[1] );
                if generalVerts = Set( prEdge[2] ) then
                    # This edge has been added before
                    pos := i;
                    # Check if it has been drawn before
                    if specificVerts = Set(vertices) then
                        draw := false;
                    fi;
                    break;
                fi;
            od;
            if draw then
                Add( printRecord!.edgeEndpoints[prEdge[1]], [vertices[1],vertices[2],drawIndex] );
            fi;
        od;


        # Add the face
        printRecord!.faceVertices[face][drawIndex] := List( returnedVertices, v -> [ v[1], vertexPositions[v[1]] ] );
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordNextEdge",
    function( printRecord, rejected )
        local diff;
        #TODO implement more involved methods
        # Naive method that returns the minimum open edge
        diff := Difference( printRecord!.openEdges, rejected );
        if Length(diff) = 0 then
            return fail;
        else
            return diff[1];
        fi;
    end
);
BindGlobal( "__SIMPLICIAL_PrintRecordNextEdgeByDrawOrder",
    function( printRecord, rejected )
        local currentCompNr, order, i, tryEdge;

        # The number of starting faces corresponds to the number of the current component
        currentCompNr := Length( printRecord!.startingFaces );

        if IsBound( printRecord!.givenEdgeDrawOrder[currentCompNr] ) then
            order := printRecord!.givenEdgeDrawOrder[currentCompNr];
            for i in [1..Length(order)] do
                tryEdge := order[i];
                if IsPosInt(tryEdge) and tryEdge in printRecord!.openEdges and not tryEdge in rejected then
                    return order[i];
                fi;
            od;
        fi;
        return fail;
    end
);


# We use the answer of
# https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
# to compute the intersection of two line segments
BindGlobal( "__SIMPLICIAL_IntersectingLineSegments",
    function( edgeCoords1, edgeCoords2, eps )
        local Cross, vtx1, vtx2, det, diff, factor1, factor2, min, max;

        Cross := function( v, w )
            return v[1]*w[2] - v[2]*w[1];
        end;

        # Rewrite the lines into p + t * v
        vtx1 := edgeCoords1[2] - edgeCoords1[1];
        vtx2 := edgeCoords2[2] - edgeCoords2[1];

        # Check first if the lines are parallel
        det := Cross( vtx1, vtx2 );
        diff := edgeCoords2[1] - edgeCoords1[1];
        if __SIMPLICIAL_EqualFloats(det, 0., eps) then
            # parallel case:
            # We have to check if the lines coincide
            # For that we check if the vector between the two base
            # points is parallel to the line directions
            if not __SIMPLICIAL_EqualFloats( Cross( vtx1, diff ), Float(0), eps) then
                return false;
            fi;
            
            # Now we know that the associated lines coincide
            # Determine factor1 such that
            # p_2 = p_1 + factor1 * vtx_1
            # and factor2 such that
            # p_2 + vtx_2 = p_1 + factor * vtx_1
            if not __SIMPLICIAL_EqualFloats( vtx1[1], Float(0) , eps) then
                factor1 := diff[1]/vtx1[1];
                factor2 := factor1 + vtx2[1]/vtx1[1];
            else
                factor1 := diff[2]/vtx1[2];
                factor2 := factor1 + vtx2[2]/vtx1[2];
            fi;
            
            # The segments intersect if the segment between the factors
            # intersects (0,1)
            min := Minimum( factor1, factor2 );
            max := Maximum( factor1, factor2 );
            if min <= Float(0) and max > Float(0) then
                return true;
            elif min > Float(1) and max < Float(1) then
                return true;
            else
                return false;
            fi;
        else
            # the associated lines intersect
            factor1 := Cross( diff, vtx2 ) / det;
            factor2 := Cross( diff, vtx1 ) / det;
            if factor1 < Float(0) or factor1 > Float(1) then
                return false;
            elif factor2 < Float(0) or factor2 > Float(1) then
                return false;
            elif ( __SIMPLICIAL_EqualFloats(factor1,0., eps) or __SIMPLICIAL_EqualFloats(factor1,1., eps) )
                and ( __SIMPLICIAL_EqualFloats(factor2,0., eps) or __SIMPLICIAL_EqualFloats(factor2,1., eps) ) then
                return false;
            else
                return true;
            fi;
        fi;
    end
);


BindGlobal("__SIMPLICIAL_PrintRecordNoIntersection",
    function( printRecord, surface, vertexData, edgeData, drawIndex, testResults )
        local cleanEdges, edge, edgePos, edgeEndpoints, vertex1, vertex2,
            vertex1Coord, vertex2Coord, newEdge, newVertex1Name, newVertex2Name,
            correspondenceMatrix, newVertex1Coord, newVertex2Coord, vertexInfo,
            pair;

        # If there were intersections before, there are so now
        if testResults <> [] and testResults[1] = false then
            return testResults;
        fi;

        # If intersections should be ignored, return true
        if not printRecord!.avoidIntersections then
            return [true, []];
        fi;

        # Convert the vertexData into a list v -> second entry
        vertexInfo := [];
        for pair in vertexData do
            vertexInfo[pair[1]] := pair[2];
        od;

        # We only have to check if there are new intersections
        # For that reason we store the checked edges in testResults
        if testResults = [] then
            cleanEdges := [];
        else
            cleanEdges := testResults[2];
        fi;
        for edge in Edges(surface) do
            if Length(printRecord.edgeEndpoints[edge]) = 0 then
                continue;
            fi;
            for edgePos in [1..Length(printRecord!.edgeEndpoints[edge])] do
                if printRecord.edgeEndpoints[edge][edgePos][3] <> drawIndex then
                    continue;
                fi;
                if [edge, edgePos] in cleanEdges then
                    continue;
                fi;

                # We have not checked this edge before
                edgeEndpoints := printRecord!.edgeEndpoints[edge][edgePos];
                vertex1 := edgeEndpoints[1];
                vertex2 := edgeEndpoints[2];
                vertex1Coord := printRecord!.vertexCoordinates[ vertex1[1] ][ vertex1[2] ];
                vertex2Coord := printRecord!.vertexCoordinates[ vertex2[1] ][ vertex2[2] ];

                for newEdge in edgeData do
                    newVertex1Name := newEdge[2][1];
                    newVertex2Name := newEdge[2][2];

                    # if vertex(i) = newVertex(j) then position [i][j] = 1
                    correspondenceMatrix := [ [0,0], [0,0] ];

                    #TODO get rid of code duplication
                    if IsPosInt(vertexInfo[newVertex1Name]) then
                        newVertex1Coord := printRecord!.vertexCoordinates[newVertex1Name][vertexInfo[newVertex1Name]];
                        # compare directly with original vertices
                        if vertex1{[1,2]} = [newVertex1Name, vertexInfo[newVertex1Name]] then #TODO can it happen that the new vertex v is identified with the old vertex w??
                            correspondenceMatrix[1][1] := 1;
                        elif vertex2{[1,2]} = [newVertex1Name, vertexInfo[newVertex1Name]] then
                            correspondenceMatrix[2][1] := 1;
                        fi;
                    else
                        # compare coordinates
                        newVertex1Coord := vertexInfo[newVertex1Name];
                        if __SIMPLICIAL_EqualPoints( vertex1Coord, vertexInfo[newVertex1Name], printRecord!.floatAccuracy ) then
                            if newVertex1Name <> vertex1[1] then
                                # Conflict with two different vertices at the same position
                                return [false, cleanEdges];
                            else
                                correspondenceMatrix[1][1] := 1;
                            fi;
                        elif __SIMPLICIAL_EqualPoints( vertex2Coord, vertexInfo[newVertex1Name], printRecord!.floatAccuracy) then
                            if newVertex1Name <> vertex2[1] then
                                return [false, cleanEdges];
                            else
                                correspondenceMatrix[2][1] := 1;
                            fi;
                        fi;
                    fi;

                    if IsPosInt(vertexInfo[newVertex2Name]) then
                        newVertex2Coord := printRecord!.vertexCoordinates[newVertex2Name][vertexInfo[newVertex2Name]];
                        # compare directly with original vertices
                        if vertex1{[1,2]} = [newVertex2Name, vertexInfo[newVertex2Name]] then 
                            correspondenceMatrix[1][2] := 1;
                        elif vertex2{[1,2]} = [newVertex2Name, vertexInfo[newVertex2Name]] then
                            correspondenceMatrix[2][2] := 1;
                        fi;
                    else
                        newVertex2Coord := vertexInfo[newVertex2Name];
                        # compare coordinates
                        if __SIMPLICIAL_EqualPoints( vertex1Coord, vertexInfo[newVertex2Name], printRecord!.floatAccuracy ) then
                            if newVertex2Name <> vertex1[1] then
                                # Conflict with two different vertices at the same position
                                return [false, cleanEdges];
                            else
                                correspondenceMatrix[1][2] := 1;
                            fi;
                        elif __SIMPLICIAL_EqualPoints( vertex2Coord, vertexInfo[newVertex2Name], printRecord!.floatAccuracy) then
                            if newVertex2Name <> vertex2[1] then
                                return [false, cleanEdges];
                            else
                                correspondenceMatrix[2][2] := 1;
                            fi;
                        fi;
                    fi;

                    # We now have constructed a correspondence matrix such that 
                    # in every row and every column there is at most one 1.
                    if Sum(Sum(correspondenceMatrix)) = 2 then
                        # We only have to compare the edge numbers
                        if edge <> newEdge[1] then
                            return [false, cleanEdges];
                        fi;
                    else
                        # Compute the intersection normally
                        if __SIMPLICIAL_IntersectingLineSegments( [vertex1Coord, vertex2Coord], [newVertex1Coord, newVertex2Coord], printRecord.floatAccuracy ) then
                            return [false, cleanEdges];
                        fi;
                    fi;
 
                od;
            od;
            Add( cleanEdges, [edge, edgePos] );
        od;

        return [true, Set(cleanEdges)];
    end
);


BindGlobal("__SIMPLICIAL_PrintRecordGeneralHeader",
    function(printRecord)
        local res;

        res := Concatenation(
            "\\documentclass{", printRecord.latexDocumentclass, "}\n\n" );

        if printRecord.latexDocumentclass <> "standalone" then
            res := Concatenation( res,
            "\\usepackage[inner=0.5cm,outer=0.5cm,top=1cm,bottom=0.5cm]{geometry}\n\n");
        fi;

        res := Concatenation( res, "\\pagestyle{empty}\n");

        return res;
    end
);

BindGlobal( "__SIMPLICIAL_ReadTemplateFromFile",
    function(relPath)
        local gapPath, path, input, content;

        gapPath := List( GAPInfo.RootPaths, p -> Concatenation(p, relPath) );
        gapPath := Filtered( gapPath, IsReadableFile );
        for path in gapPath do
            input := InputTextFile( path );
            content := ReadAll(input);
            CloseStream(input);
            return content;
        od;

        Error("Internal Error: ", relPath, " not found in GAP root directories.");
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordTikzHeader",
    function(printRecord)
        local relPath;
        relPath := "/pkg/simplicial-surfaces/doc/TikZHeader.tex";
				return __SIMPLICIAL_ReadTemplateFromFile(relPath);
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordDrawVertex",
    function( printRecord, surface, vertex, vertexTikzCoord, vertexCoord )
        local res;

        res := "\\vertexLabelR";
        if IsBound( printRecord!.vertexColours[vertex] ) then
            res := Concatenation(res, "[", printRecord!.vertexColours[vertex],"]");
        fi;

        res := Concatenation( res, "{", vertexTikzCoord, "}{left}{$");
        if IsBound(printRecord!.vertexLabels[vertex]) then
            Append(res, printRecord!.vertexLabels[vertex]);
        else
            #Append( res, "v_{" );
            Append( res, String(vertex) );
            #Append( res, "}" );
        fi;
        Append(res,"$}\n" );

        return res;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordDrawEdge",
    function( printRecord, surface, edge, vertexTikzCoord, vertexCoord )
        local res;

        res := "\\draw[edge";
        if IsBound( printRecord!.edgeColours[edge] ) then
            res := Concatenation(res, "=", printRecord!.edgeColours[edge]);
        fi;

        res := Concatenation(res, "] (", vertexTikzCoord[1], ") -- node[edgeLabel] {$");
        if IsBound(printRecord!.edgeLabels[edge]) then
            Append(res, printRecord!.edgeLabels[edge]);
        else
            #Append( res, "e_{" );
            Append( res, String(edge) );
            #Append( res, "}" );
        fi;
        res := Concatenation(res, "$} (", vertexTikzCoord[2], ");\n" );

        return res;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordDrawFace",
    function( printRecord, surface, face, vertexTikzCoord, vertexCoord )
        local res, i, coord;

        res := "";
        Append(res, "\\fill[");
    #TODO this does not make sense without mirror/rotation edges -> revisit this problem then
        # Determine if the swap colour is used
#        if IsOrientable(surface) and printRecord!.faceVertices[face][2][1]^OrientationByVerticesAsPerm(surface)[face] = printRecord!.faceVertices[face][1][1] then
#            Append(res, "faceSwap");
#        else
            Append(res, "face");
#        fi;

        if IsBound( printRecord!.faceColours[face] ) then
            Append( res, "=" );
            Append( res, printRecord!.faceColours[face] );
        fi;
        Append(res, "] ");

        for coord in vertexTikzCoord do
            Append(res, " (");
            Append(res, coord);
            Append(res, ") --");
        od;
        Append(res, " cycle;\n");
        Append(res, "\\node[faceLabel] at (barycentric cs:");
        for i in [1..Length(vertexTikzCoord)] do
            if i > 1 then
                Append(res, ",");
            fi;
            Append(res, vertexTikzCoord[i]);
            Append(res, "=1");
        od;
        Append(res, ") {$");
        if IsBound( printRecord!.faceLabels[face] ) then
            Append(res, printRecord!.faceLabels[face]);
        else
            #Append(res, "f_{");
            Append(res, String(face));
            #Append(res, "}");
        fi;
        Append(res, "$};\n" );

        return res;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordTikzOptions",
    function(printRecord, surface)
        local res;

        res := "";
        # Add the vertex style
        Append( res, "vertexBall" );
        if printRecord!.vertexLabelsActive = false then
            Append( res, "=nolabels" );
        fi;
        Append( res, ", " );

        # Add the edge style
        Append( res, "edgeDouble" );
        if printRecord!.edgeLabelsActive = false then
            Append( res, "=nolabels" );
        fi;
        Append( res, ", " );

        # Add the face style
        Append( res, "faceStyle" );
        if printRecord!.faceLabelsActive = false then
            Append( res, "=nolabels" );
        fi;
        Append( res, ", " );

        # Scale the picture
        Append( res, "scale=" );
        Append( res, String(printRecord!.scale) );

        return res;
    end
);


# general method
InstallMethod( DrawSurfaceToTikz, 
    "for a polygonal complex without edge ramifications, a filename and a record",
    [IsPolygonalComplex and IsNotEdgeRamified, IsString, IsRecord],
    function(surface, fileName, printRecord)
        local file, output, f, v, i, positions, comp, 
            allVertexCoords, TikzCoordFromVertexPosition, unplacedFaces,
            strongComponents, start, computedFace, nextFct, checkFct, k,
            nextEdge, firstEdge, rejected, repeatData, tries, proposedEdge,
            adFace, vertexData, edgeData, testResults, e, ends, facePath,
            vertexEdgeData, success, j, vertexCoords, vertexPositions, 
            lastOrder, nextFctIndex, oldFace, pos, strongComp, drawComp,
            drawIndex, ind, drawIndices, strongCompNumber;

        # Do something different for the manual
        if __SIMPLICIAL_MANUAL_MODE then
            printRecord!.onlyTikzpicture := true;
            printRecord!.compileLaTeX := false;
            printRecord!.noOutput := true;
            fileName := Concatenation( "doc/_TIKZ_", fileName );
        fi;

        # Make the file end with .tex
        if not EndsWith( fileName, ".tex" ) then
            fileName := Concatenation( fileName, ".tex" );
        fi;

        # Try to open the given file
        file := Filename( DirectoryCurrent(), fileName ); #TODO allow absolute paths
        output := OutputTextFile( file, false ); # override other files
        if output = fail then
            Error(Concatenation("File ", String(file), " can't be opened.") );
        fi;
        SetPrintFormattingStatus( output, false );


        __SIMPLICIAL_PrintRecordInit(printRecord, surface);
        __SIMPLICIAL_PrintRecordInitializePolygons(printRecord, surface);

        # Start the actual method
        unplacedFaces := Faces(surface);
        strongComponents := [];
        drawIndex := 0;
        while Length(unplacedFaces) > 0 do
            # Find the starting face
            start := __SIMPLICIAL_PrintRecordStartingFace( printRecord, surface, unplacedFaces );
            Add( printRecord!.startingFaces, start );
            Add( printRecord.edgeDrawOrder,  [] );

            comp := [[start]];
            drawIndex := drawIndex + 1;
            drawIndices := [drawIndex];
            #drawIndex := 1;
            computedFace := __SIMPLICIAL_PrintRecordComputeFirstFace( printRecord, surface, start, drawIndex );
            __SIMPLICIAL_PrintRecordAddFace(printRecord, surface, computedFace[1], computedFace[2], start, drawIndex);
            unplacedFaces := Difference( unplacedFaces, [start] );
            printRecord.openEdges := Filtered( EdgesOfFaces(surface)[start], e -> Length( Intersection(unplacedFaces, FacesOfEdges(surface)[e]) ) > 0 );

            nextFct := [ ["__SIMPLICIAL_PrintRecordNextEdgeByDrawOrder", infinity], ["__SIMPLICIAL_PrintRecordNextEdge", infinity] ];
            checkFct := [ "__SIMPLICIAL_PrintRecordNoIntersection" ];
            repeatData := [];
            # This is an infinite loop to extend all edges - bounded from above by the number of edges
            for k in [1..NumberOfEdges(surface)] do
                if Length(printRecord!.openEdges) = 0 then
                    break;
                fi;
                # Find the next edge
                nextEdge := fail;
                firstEdge := fail; # Fallback if all edges fail some test
                rejected := [];
                nextFctIndex := 1;
                tries := 1;
                for i in [1..Length(printRecord!.openEdges)+Length(nextFct)] do
                    if nextFctIndex > Length(nextFct) then
                        break;
                    fi;
                    if tries > nextFct[nextFctIndex][2] then
                        nextFctIndex := nextFctIndex + 1;
                        tries := 1;
                        continue;
                    fi;
                    proposedEdge := ValueGlobal( nextFct[nextFctIndex][1] )(printRecord, rejected);
                    tries := tries + 1;
                    if proposedEdge = fail then # TODO code duplication with lines above
                        nextFctIndex := nextFctIndex + 1;
                        tries := 1;
                        continue;
                    fi;
                    if firstEdge = fail then
                        firstEdge := proposedEdge;
                    fi;
                    # every edge is used at most once (if there could be ambiguity, the edge has more than 2 incident faces)
                    # for each edge we store
                    # 1) the adjacent face
                    # 2) the computed vertex data
                    # 3) the computed edge data
                    # 4) a list with the results of the checks
                    if IsBound( repeatData[proposedEdge] ) then
                        # Take data from storage
                        adFace := repeatData[proposedEdge][1];
                        vertexData := repeatData[proposedEdge][2];
                        edgeData := repeatData[proposedEdge][3];
                        testResults := repeatData[proposedEdge][4];
                    else
                        adFace := Intersection( FacesOfEdges(surface)[proposedEdge], unplacedFaces )[1];
                        vertexEdgeData := __SIMPLICIAL_PrintRecordComputeFace(printRecord, surface, adFace, proposedEdge, drawIndex);
                        vertexData := vertexEdgeData[1];
                        edgeData := vertexEdgeData[2];
                        testResults := [];
                    fi;

                    # do tests
                    # we rely on the fact that computed faces of a previous 
                    # drawing component will keep beeing false (otherwise
                    # the tried addition will produce an error).
                    success := true;
                    for j in [1..Length(checkFct)] do
                        if IsBound( testResults[j] ) then
                            # there was a test before
                            testResults[j] := ValueGlobal( checkFct[j] )(printRecord, surface, vertexData, edgeData, drawIndex, testResults[j]);
                        else
                            testResults[j] := ValueGlobal( checkFct[j] )(printRecord, surface, vertexData, edgeData, drawIndex, []);
                        fi;

                        if testResults[j][1] = false then
                            success := false;
                            break;
                        fi;
                    od;
                
                    # Store data since it is either needed to avoid recomputation or to continue
                    repeatData[proposedEdge] := [ adFace, vertexData, edgeData, testResults ];

                    if not success then
                        Add(rejected, proposedEdge);
                        proposedEdge := fail;
                        continue;
                    else
                        nextEdge := proposedEdge;
                        break;
                    fi;
                od;
                if proposedEdge = fail then
                    # take the first edge instead
                    proposedEdge := firstEdge;
                    drawIndex := drawIndex + 1;
                    Add(drawIndices, drawIndex);
                    Add( comp, [repeatData[proposedEdge][1]]  );
                    computedFace := __SIMPLICIAL_PrintRecordComputeFirstFace( printRecord, surface, repeatData[proposedEdge][1], drawIndex );
                    __SIMPLICIAL_PrintRecordAddFace(printRecord, surface, computedFace[1], computedFace[2], repeatData[proposedEdge][1], drawIndex);

                    Print("DrawSurfaceToTikz: Could not find intersection-free continuation. Draw face ", repeatData[proposedEdge][1], " via edge ", firstEdge, " instead.\n");
                else
                    __SIMPLICIAL_PrintRecordAddFace( printRecord, surface, repeatData[proposedEdge][2], repeatData[proposedEdge][3], repeatData[proposedEdge][1], drawIndex );
                    # We will be in this case until we can't continue any edge without failing some test.
                    # Therefore this case will always add in the component that was last modified
                    Add( comp[Length(comp)], repeatData[proposedEdge][1] );
                fi;

                # Add the new face and remove initial edge from openEdges
                unplacedFaces := Difference( unplacedFaces, [ repeatData[proposedEdge][1] ]);
                for e in EdgesOfFaces(surface)[repeatData[proposedEdge][1]] do
                    if Length( Intersection(unplacedFaces, FacesOfEdges(surface)[e]) ) = 0 then
                        printRecord.openEdges := Difference( printRecord.openEdges, [e] );
                    else
                        printRecord.openEdges := Union( printRecord.openEdges, [e] );
                    fi;
                od;

                # Modify the edge draw order
                lastOrder := printRecord.edgeDrawOrder[Length(printRecord.edgeDrawOrder)];
                Add(lastOrder, proposedEdge);
            od;
            Add( printRecord.drawComponents, comp );
            Add( printRecord.drawIndices, drawIndices );
        od;

        # Set the strongly connected components (if not already done)
        if not HasStronglyConnectedComponentsAttributeOfComplex( surface ) then
            SetStronglyConnectedComponentsAttributeOfComplex( surface, List( printRecord.drawComponents, c -> SubcomplexByFacesNC(surface, Union(c) ) ));
        fi;

        # Write this data into the file
        if not printRecord!.onlyTikzpicture then
            AppendTo( output, __SIMPLICIAL_PrintRecordGeneralHeader(printRecord) );
            AppendTo( output, __SIMPLICIAL_PrintRecordTikzHeader(printRecord) );
            AppendTo( output, "\n\n\\begin{document}\n\n" );
        
            if IsBound(printRecord!.caption) then
            AppendTo( output,
                "\\subsection*{", printRecord!.caption, "}\n \\bigskip\n");
            fi;
        fi;
        
        TikzCoordFromVertexPosition := function( vertPos )
            return Concatenation( "V", String(vertPos[1]), "_", String(vertPos[2]), "" );
        end;
        allVertexCoords := printRecord!.vertexCoordinates;
        for strongCompNumber in [1..Length(printRecord.drawComponents)] do
            strongComp := printRecord.drawComponents[strongCompNumber];
            for ind in [1..Length(strongComp)] do;
                drawComp := strongComp[ind];
                comp := SubcomplexByFacesNC(surface,drawComp);
                drawIndex := printRecord.drawIndices[strongCompNumber][ind];

                # Start the picture
                AppendTo( output, "\n\n\\begin{tikzpicture}[", __SIMPLICIAL_PrintRecordTikzOptions(printRecord, comp), "]\n\n" );
                # Activate alternative face colours
    #            if printRecord!.faceSwapColoursActive then
    #                AppendTo( output, "\\def\\swapColors{1}\n\n" );
    #            fi;

                # Define coordinates of vertices
                AppendTo( output, "% Define the coordinates of the vertices\n" );
                for v in VerticesAttributeOfComplex(comp) do
                    for i in [1..Length(allVertexCoords[v])] do
                        if allVertexCoords[v][i][3] = drawIndex then
                            AppendTo( output, "\\coordinate (", TikzCoordFromVertexPosition([v,i]), ") at (", allVertexCoords[v][i][1], ", ", allVertexCoords[v][i][2], ");\n" );
                        fi;
                    od;
                od;
                AppendTo(output, "\n\n");

                # Draw faces
                AppendTo( output, "% Fill in the faces\n" );
                for f in Faces(comp) do
                    vertexPositions := printRecord!.faceVertices[f][drawIndex];
                    AppendTo( output, __SIMPLICIAL_PrintRecordDrawFace(printRecord, surface, f, 
                        List(vertexPositions, TikzCoordFromVertexPosition), List(vertexPositions, p -> allVertexCoords[p[1]][p[2]])) );
                od;
                AppendTo( output, "\n\n" );

                # Draw edges
                AppendTo( output, "% Draw the edges\n" );
                for e in Edges(comp) do
                    ends := printRecord!.edgeEndpoints[e];
                    for i in [1..Length(ends)] do
                        if ends[i][3] = drawIndex then
                            AppendTo( output, __SIMPLICIAL_PrintRecordDrawEdge( printRecord, surface, e,
                                List( ends[i]{[1,2]}, TikzCoordFromVertexPosition ),
                                List( ends[i]{[1,2]}, p -> allVertexCoords[p[1]][p[2]] ) ) );
                        fi;
                    od;
                od;
                AppendTo( output, "\n\n" );
                
                # Draw vertices
                AppendTo( output, "% Draw the vertices\n" );
                for v in VerticesAttributeOfComplex(comp) do
                    positions := allVertexCoords[v];
                    for i in [1..Length(positions)] do
                        if allVertexCoords[v][i][3] = drawIndex then
                            AppendTo( output, __SIMPLICIAL_PrintRecordDrawVertex( printRecord, surface, v, TikzCoordFromVertexPosition([v,i]), allVertexCoords[v][i] ));
                        fi;
                    od;
                od;
                
                # End the picture
                AppendTo( output, "\n\\end{tikzpicture}" );
            od;
        od;
        if not printRecord!.onlyTikzpicture then
            AppendTo( output, "\n\\end{document}\n");
        fi;
        CloseStream(output);
        if not printRecord!.noOutput then
            Print( "Picture written in TikZ." );
        fi;


        if printRecord.compileLaTeX then
            if not printRecord!.noOutput then
                Print( "Start LaTeX-compilation (type 'x' and press ENTER to abort).\n" );
            fi;

            # Run pdfLaTeX on the file (without visible output)
            Exec( "pdflatex ", file, " > /dev/null" );
            if not printRecord!.noOutput then
                Print( "Picture rendered (with pdflatex).\n");
            fi;
        fi;


        # Clean up the record
        __SIMPLICIAL_PrintRecordCleanup(printRecord);

        return printRecord;
    end
);
RedispatchOnCondition( DrawSurfaceToTikz, true, [IsTwistedPolygonalComplex,IsString,IsRecord], [IsPolygonalComplex and IsNotEdgeRamified], 0  );

InstallOtherMethod( DrawSurfaceToTikz, 
    "for a polygonal complex without edge ramifications and a file name",
    [IsPolygonalComplex and IsNotEdgeRamified, IsString],
    function(surface, file)
        return DrawSurfaceToTikz(surface, file, rec());
    end
);
RedispatchOnCondition( DrawSurfaceToTikz, true, [IsTwistedPolygonalComplex,IsString], [IsPolygonalComplex and IsNotEdgeRamified], 0  );

