BindGlobal("__GAPIC__EqualFloats",
    function(x,y, eps)
        return (x-y)^2 < eps;
    end
);
BindGlobal( "__GAPIC__EqualPoints",
    function( p, q, eps )
        return (p[1]-q[1])^2 + (p[2]-q[2])^2 < eps;
    end
);

BindGlobal( "__GAPIC__PrintRecordInitStringList",
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
BindGlobal( "__GAPIC__PrintRecordInitBool",
    function(printRecord, entry, default)
        if not IsBound(printRecord!.(entry)) or not IsBool(printRecord!.(entry)) then
            printRecord!.(entry) := default;
        fi;
    end
);

BindGlobal( "__GAPIC__PrintRecordInit",
    function(printRecord, graph)
        local givenStarts, v, e, givenEdgeDrawOrder, i, col, f;

        # # Starting faces
        # if not IsBound(printRecord.startingFaces) and IsBound(printRecord.startingFace) then
        #     # If someone spells startingFace instead of startingFaces, we are lenient..
        #     printRecord.startingFaces := printRecord.startingFace;
        #     Unbind(printRecord.startingFace);
        # fi;
        # if IsBound(printRecord!.startingFaces) then
        #     if IsPosInt(printRecord!.startingFaces) then
        #         givenStarts := [ printRecord!.startingFaces ];
        #     elif IsList( printRecord!.startingFaces ) and ForAll( printRecord!.startingFaces, IsPosInt ) then
        #         givenStarts := printRecord!.startingFaces;
        #     else
        #         Print("Given starting faces are neither a list of faces nor a single face.");
        #         givenStarts := [];
        #     fi;
        # else
        #     givenStarts := [];
        # fi;
        # printRecord!.givenStartingFaces := givenStarts;
        # printRecord!.startingFaces := [];
        
        # # Edge draw order
        # if IsBound(printRecord.edgeDrawOrder) then
        #     givenEdgeDrawOrder := printRecord.edgeDrawOrder;
        #     if not IsList(givenEdgeDrawOrder) then
        #         givenEdgeDrawOrder := [];
        #     elif ForAll( givenEdgeDrawOrder, IsPosInt ) then
        #         givenEdgeDrawOrder := [ givenEdgeDrawOrder ];
        #     fi;
        #     #TODO more checks and warnings?
        # else
        #     givenEdgeDrawOrder := [];
        # fi;
        # printRecord!.givenEdgeDrawOrder := givenEdgeDrawOrder;
        # printRecord!.edgeDrawOrder := [];

        # # Draw components and drawing indices
        # printRecord.drawComponents := [];
        # printRecord.drawIndices := [];

        # # edge lengths and angles
        # if not IsBound( printRecord!.edgeLengths ) then
        #     printRecord!.edgeLengths := [];
        # fi;
        # printRecord!.givenEdgeLengths := printRecord!.edgeLengths;

        # if not IsBound( printRecord!.angles ) then
        #     printRecord!.angles := [];
        # fi;
        # printRecord!.givenAngles := printRecord!.angles;

        # float accuracy
        if not IsBound( printRecord!.floatAccuracy ) then
            printRecord!.floatAccuracy := 0.001;
        fi;

        # # coordinates (always recomputed)
        # printRecord!.vertexCoordinates := [];
        # for v in VerticesAttributeOfComplex(surface) do
        #     printRecord!.vertexCoordinates[v] := [];
        # od;
        # printRecord!.edgeEndpoints := [];
        # for e in Edges(surface) do
        #     printRecord!.edgeEndpoints[e] := [];
        # od;
        # printRecord!.faceVertices := [];
        # for f in Faces(surface) do
        #     printRecord.faceVertices[f] := [];
        # od;

        # # openEdges
        # printRecord!.openEdges := [];


        # drawing options
        __GAPIC__PrintRecordInitBool(printRecord, "directedEdgesActive", true);

        __GAPIC__PrintRecordInitBool( printRecord, "nodeLabelsActive", true );
        __GAPIC__PrintRecordInitStringList( printRecord, "nodeLabels", 
            DigraphVertices(graph) );

        __GAPIC__PrintRecordInitBool( printRecord, "edgeLabelsActive", true );
        __GAPIC__PrintRecordInitStringList( printRecord, "edgeLabels", [1..Length(DigraphEdges(graph))] );

        # __GAPIC__PrintRecordInitBool( printRecord, "faceLabelsActive", true );
        # __GAPIC__PrintRecordInitStringList( printRecord, "faceLabels", [1..Length(printRecord!.nodesOfFaces)] );
        
        if not IsBound( printRecord!.scale ) then
            printRecord!.scale := 3;
        fi;
        # __GAPIC__PrintRecordInitBool(printRecord, "avoidIntersections", true);

        # colours
        __GAPIC__PrintRecordInitStringList(printRecord, "vertexColours", 
            DigraphVertices(graph));
        __GAPIC__PrintRecordInitStringList(printRecord, "edgeColours", [1..Length(DigraphEdges(graph))]);
        # __GAPIC__PrintRecordInitStringList(printRecord, "faceColours", Faces(surface));
        # if the faceColours are custom given, we check for errors
        # for i in [1..Length(printRecord!.faceColours)] do
        #     if IsBound( printRecord!.faceColours[i] ) then
        #         col := printRecord!.faceColours[i];
        #         if StartsWith( col, "\\faceColour" ) then
        #             Remove(col,10);
        #             printRecord!.faceColours[i] := col;
        #         fi;
        #     fi;
        # od;
#        if not IsBound( printRecord!.faceSwapColoursActive ) then
#            printRecord!.faceSwapColoursActive := false;
#        fi;


        # automatic compilation
        __GAPIC__PrintRecordInitBool( printRecord, "compileLaTeX", false );
        # only write the tikzpicture (this will not be able to compile on its own!)
        __GAPIC__PrintRecordInitBool( printRecord, "onlyTikzpicture", false );
        if printRecord!.compileLaTeX and printRecord!.onlyTikzpicture then
            Error("DrawSurfaceToTikz: The options 'compileLaTeX' and 'onlyTikzpicture' can't be true simultaneously.");
        fi;

        if not IsBound(printRecord.latexDocumentclass) then
            printRecord.latexDocumentclass := "article";
        fi;

        __GAPIC__PrintRecordInitBool(printRecord, "noOutput", false);
    end
);



BindGlobal( "__GAPIC__IsFloatZero",
    function( fl, accuracy )
        if AbsoluteValue(fl) < accuracy then
            return 0.;
        else
            return fl;
        fi;
    end
);


BindGlobal("__GAPIC__PrintRecordGeneralHeader",
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

BindGlobal( "__GAPIC__PrintRecordTikzHeader",
    function(printRecord)
        return __GAPIC__ReadTemplateFromFile("TikZHeader.tex");
    end
);


BindGlobal( "__GAPIC__PrintRecordDrawVertex",
    function( printRecord, vertex, vertexTikzCoord)
        local res;

        res := "\\vertexLabelR";
        if IsBound( printRecord!.vertexColours[vertex] ) and (not printRecord!.vertexColours[vertex]=[]) then
            res := Concatenation(res, "[", printRecord!.vertexColours[vertex],"]");
        fi;

        res := Concatenation( res, "{", vertexTikzCoord, "}{left}{$");
        if IsBound(printRecord!.nodeLabels[vertex]) then
            Append(res, printRecord!.nodeLabels[vertex]);
        else
            #Append( res, "v_{" );
            Append( res, String(vertex) );
            #Append( res, "}" );
        fi;
        Append(res,"$}\n" );
        # if vertex = 7 then Error(); fi;
        return res;
    end
);

BindGlobal( "__GAPIC__PrintRecordDrawEdge",
    function( printRecord, graph, edge, vertexTikzCoord) # Caution: The argument 'edge' is given as an integer from the numbering of the edges of 'graph'
        local res;
        if printRecord!.directedEdgesActive = true then
            if Length(Positions(List(DigraphEdges(graph), e -> Set(e)), Set(DigraphEdges(graph)[edge]))) = 2 then
                res := "\\draw[-latex, edge";

                if IsBound( printRecord!.edgeColours[edge] ) and (not printRecord!.edgeColours[edge]=[]) then
                    res := Concatenation(res, "=", printRecord!.edgeColours[edge]);
                fi;

                res := Concatenation(res, "] let \\p1=($(", vertexTikzCoord[2], ")-(", vertexTikzCoord[1], ")$), \\n1={atan2(\\y1,\\x1)+20},\\n2={atan2(\\y1,\\x1)+180-20} in (", vertexTikzCoord[1], " name.\\n1) -- node[auto, edgeLabel] {$");
                
                if IsBound(printRecord!.edgeLabels[edge]) then
                Append(res, printRecord!.edgeLabels[edge]);
                else
                    Append( res, String(edge) );
                fi;

                res := Concatenation(res, "$} (", vertexTikzCoord[2], " name.\\n2);\n" );
            else
                res := "\\draw[-latex, edge";
                if IsBound( printRecord!.edgeColours[edge] ) and (not printRecord!.edgeColours[edge]=[]) then
                    res := Concatenation(res, "=", printRecord!.edgeColours[edge]);
                fi;

                res := Concatenation(res, "] (", vertexTikzCoord[1], " name) -- node[edgeLabel] {$");
                if IsBound(printRecord!.edgeLabels[edge]) then
                    Append(res, printRecord!.edgeLabels[edge]);
                else
                    Append( res, String(edge) );
                fi;
                res := Concatenation(res, "$} (", vertexTikzCoord[2], " name);\n" );
            fi;
        else
            res := "\\draw[edge";
            if IsBound( printRecord!.edgeColours[edge] ) and (not printRecord!.edgeColours[edge]=[]) then
                res := Concatenation(res, "=", printRecord!.edgeColours[edge]);
            fi;

            res := Concatenation(res, "] (", vertexTikzCoord[1], " name) -- node[edgeLabel] {$");
            if IsBound(printRecord!.edgeLabels[edge]) then
                Append(res, printRecord!.edgeLabels[edge]);
            else
                Append( res, String(edge) );
            fi;
            res := Concatenation(res, "$} (", vertexTikzCoord[2], " name);\n" );
        fi;
        
        return res;
    end
);

BindGlobal( "__GAPIC__CycleEdgeRecordDrawEdge",
    function( printRecord, graph, edge, vertexTikzCoord) # Caution: The argument 'edge' is given as an integer from the numbering of the edges of 'graph'
        local res;

        res := "\\draw[edge";
        if IsBound( printRecord!.edgeColours[edge] ) and (not printRecord!.edgeColours[edge]=[]) then
            res := Concatenation(res, "=", printRecord!.edgeColours[edge]);
        fi;
        res := Concatenation(res, "] (", vertexTikzCoord[1], ") -- ");
        res := Concatenation(res, " (", vertexTikzCoord[2], ");\n" );
        
        return res;
    end
);


BindGlobal( "__GAPIC__PrintRecordTikzOptions",
    function(printRecord, graph)
        local res;
        res := "";
        # Add the vertex style
        Append( res, "vertexBall" );
        if printRecord!.nodeLabelsActive = false then
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


BindGlobal( "__GAPIC__IsCoordinates2D",
    function(surface, coordinates)
        local coord;
        if not IsList(coordinates) then
            return false;
        fi;
        if Filtered([1..Length(coordinates)],i->IsBound(coordinates[i])) <> Faces(surface) then
            return false;
	    fi;
        # Check whether all coordinates are 2D-coordinates
        for coord in coordinates do
            if not IsDenseList(coord) then
                return false;
            fi;
            if Length(coord) <> 2 then
                return false;
            fi;
        od;
        return true;
    end
);


#######################################


  
    ## this functions manipulates the printRecord

BindGlobal( "__GAPIC__InitializePrintRecord",
    function(graph ,printRecord)
	local g,colour,e,f,v, node;
	if not IsBound(printRecord.nodeLabelsActive) then
	    printRecord.nodeLabelsActive := true;
	fi;
	if not IsBound(printRecord.latexDocumentclass) then
	    printRecord.latexDocumentclass := "article";
	fi;
    __GAPIC__PrintRecordInitBool(printRecord, "directedEdgesActive", true);
	if not IsBound(printRecord.edgeLabelsActive) then
	    printRecord.edgeLabelsActive := true; 
	fi;
	if not IsBound(printRecord.faceLabelsActive) then
	    printRecord.faceLabelsActive := false;
	fi;
	if not IsBound(printRecord.scale) then
	    printRecord.scale :=3;
	fi;
	if IsBound(printRecord.edgeColours) then
	    if IsString(printRecord.edgeColours) then
		    colour:=printRecord.edgeColours; 
		    printRecord.edgeColours:=[];
		    for e in [1..Length(DigraphEdges(graph))] do
		       printRecord.edgeColours[e]:=colour;
		    od;
	    fi;
	else
		printRecord.edgeColours:=[];
	fi;	
	if not IsBound(printRecord.edgeLabels) then
	    printRecord.edgeLabels := [];
	fi;
        # if not IsBound(printRecord.faceLabels) then
        #     printRecord.faceLabels := [];
        # fi;
    if not IsBound(printRecord.nodeLabels) then
        printRecord.nodeLabels := [];
    fi;
	
	if printRecord.edgeLabelsActive and printRecord.edgeLabels=[] then
	    for e in [1..Length(DigraphEdges(graph))] do
		    printRecord.edgeLabels[e]:=String(e);
	    od;
	fi;
    #     if printRecord.faceLabelsActive and printRecord.faceLabels=[] then
    #         for f in Faces(surface) do
    #             printRecord.faceLabels[f]:=String(f);
    #         od;
    #     fi;
        if printRecord.nodeLabelsActive and printRecord.nodeLabels=[] then
            for node in DigraphVertices(graph) do
                printRecord.nodeLabels[node]:=String(node);
            od;
        fi;
    #     if IsBound(printRecord.faceColours) then
    #         if IsString(printRecord.faceColours) then
    #             colour:=printRecord.faceColours;
    #             printRecord.faceColours:=[];
    #             for f in Faces(surface) do
    #                 printRecord.faceColours[f]:=colour;
    #             od;
    #         fi;
    #     else
    #             printRecord.faceColours:=[];
    #     fi;

        if IsBound(printRecord.vertexColours) then
            if IsString(printRecord.vertexColours) then
                colour:=printRecord.vertexColours;
                printRecord.vertexColours:=[];
                for v in DigraphVertices(graph) do
                    printRecord.vertexColours[v]:=colour;
                od;
            fi;
        else
                printRecord.vertexColours:=[];
        fi;
        if not IsBound(printRecord.compileLaTeX) then
	        printRecord.compileLaTeX :=false;
	    fi;
        if not IsBound(printRecord.noOutput) then
            printRecord.noOutput :=false;
        fi;
        if not IsBound(printRecord.onlyTikzpicture) then
            printRecord.onlyTikzpicture:=false;
        fi;

	return printRecord;
    end
);


###
# From DrawFacegraphToTikz from SimplicialSurfaces package
###

InstallMethod(DrawDigraphToTikz,
    "for a digraph, a file name and a record",
    [IsDigraph, IsString, IsRecord],
    function(graph, file, printRecord)
        local e,e1,e2,f,f1,f2,f3,v,v1,v2,faceCoordTikZ,foe,output,umb,maxX,maxY,
        newCoor,minX,minY,mX,mY,geodesic,i,j,currUmb,coordinates,temp,
        color,tempRec, node;

        # Make the file end with .tex
        if not EndsWith( file, ".tex" ) then
            file := Concatenation( file, ".tex" );
        fi;

        f := Filename( DirectoryCurrent(), file );
        output := OutputTextFile( f, false );
        if output = fail then
            Error(Concatenation("File ", String(file), " can't be opened.") );
        fi;
        printRecord:=__GAPIC__InitializePrintRecord(graph ,printRecord);
        SetPrintFormattingStatus( output, false );

        # Add Header to .tex file 
        tempRec:=ShallowCopy(printRecord);

        # Write this data into the file
        if not printRecord!.onlyTikzpicture then
            AppendTo( output, __GAPIC__PrintRecordGeneralHeader(tempRec));
            AppendTo( output, __GAPIC__PrintRecordTikzHeader(tempRec));
            AppendTo( output, "\n\n\\begin{document}\n\n" );
            if IsBound(printRecord!.caption) then
                AppendTo( output,
                    "\\subsection*{", printRecord!.caption, "}\n \\bigskip\n");
                fi;
            fi;

        AppendTo( output, "\n\n\\begin{tikzpicture}[",
        __GAPIC__PrintRecordTikzOptions(tempRec, graph), "]\n\n" );

        faceCoordTikZ:=[];
        for node in DigraphVertices(graph) do
            faceCoordTikZ[node]:=Concatenation("V",String(node));
        od;
        ##define node coordinates
        for node in DigraphVertices(graph) do
        AppendTo(output	,"\\coordinate (",faceCoordTikZ[node],") at (",
            printRecord.nodeCoordinates[node][1]," , ",printRecord.nodeCoordinates[node][2],");\n");
        od;

        for v in DigraphVertices(graph) do
            AppendTo(output, __GAPIC__PrintRecordDrawVertex(printRecord, v, faceCoordTikZ[v]));
        od;

        ##draw edges
        for e in DigraphEdges(graph) do 
            AppendTo(output,__GAPIC__PrintRecordDrawEdge(printRecord,graph, Position(DigraphEdges(graph),e),
                    faceCoordTikZ{e}));
        od;

        AppendTo(output,"\\end{tikzpicture}\n");
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


        return printRecord;
    end
);

InstallMethod( DrawStraightPlanarDigraphToTikz,
    "for a planar digraph, a file name and a record",
    [IsDigraph, IsString, IsRecord],
    function(graph, file, printRecord)
        local RegularPolygon, Deabstract, Deabstract1, NeighboursOfVertex, SplitListPosition,
                TwoWeightedCentric, CorrectNodesOfFaceFilter, MultipleWeightedCentricParameters, MainHelp,
                DrawConvexPlaneGraph, embedding, max_nodes_face_pos, max_nodes_face, node, nodes_of_faces,
                IsThreeVertexConnected, undir_version_graph, NodesFromEdgesInFace, mat;

        if (not IsConnectedDigraph(graph)) or (not IsPlanarDigraph(graph)) or (not IsString(file)) or (not IsRecord(printRecord)) then
            return fail;
        fi;

        RegularPolygon := function(list) #returns vertices of a regular polygon as a list of [vert, [x,y]]
            local n, res, i;
            res := [];
            n := Length(list);
            for i in [1..n] do
                Add(res, [list[i], [Cos(2*3.14159265*((i-1)/n)), Sin(2*3.14159265*((i-1)/n))]]);
            od;
            return res;
        end;

        Deabstract := function(list, n)
            return List(list, x -> x[n]);
        end;

        Deabstract1 := function(list)
            return Deabstract(list, 1);
        end;

        NeighboursOfVertex := function(graph, vertex)
            return Union(InNeighboursOfVertex(graph, vertex), OutNeighboursOfVertex(graph, vertex));
        end;

        SplitListPosition := function(list, v) # help function
            local i, res1, res2;
            res1:=[];
            res2:=[];
            for i in [2..v] do
                Add(res1, list[i]);
            od;
            for i in [(v + 1)..Length(list)] do
                Add(res2, list[i]);
            od;
            Add(res1, list[1]);
            Add(res2, list[1]);
            Add(res2, list[v]);
            return [res1, res2];
        end;

        IsThreeVertexConnected := function(graph)
        local node;
            for node in DigraphVertices(graph) do
                if not IsBiconnectedDigraph(DigraphRemoveVertex(graph, node)) then
                    return false;
                fi;
            od;
            return true;
        end;
        
        NodesFromEdgesInFace := function(face_from_edges)
            local edge, face, remaining_edges, cur_edge_pos, cur_node;
            if face_from_edges = [] then
                return [];
            fi;
            remaining_edges := face_from_edges;
            face := [];
            cur_edge_pos := 1;
            cur_node := face_from_edges[1][2];
            while true do
                Add(face, cur_node);
                Unbind(remaining_edges[cur_edge_pos]);
                if remaining_edges = [] then
                    break;
                fi;
                if Length(Filtered(remaining_edges, e -> cur_node in e)) = 1 then # this edge should be unique
                    cur_edge_pos := Position(remaining_edges, Filtered(remaining_edges, e -> cur_node in e)[1]);
                else 
                    Error("this edge should be unique");
                fi;
                cur_node := Difference(remaining_edges[cur_edge_pos], [cur_node])[1];
            od;
            return face;
        end;

        CorrectNodesOfFaceFilter := function(pred, cur, succ, face) # help function
            if IsSubset(face, [pred, cur, succ]) then
                return true;
            else
                return false;
            fi;
        end;

        MultipleWeightedCentricParameters := function(nodes, main_anchor, start_anchor, end_anchor, p) # help function
            local res, n, i;
            res := [];
            n := Length(nodes) + 1;
            for i in [1..Length(nodes)] do
                Add(res, [nodes[i], p*main_anchor + (1-p)*(Float((n-i)/n)*start_anchor + Float(i/n)*end_anchor)]);
            od;
            return res;
        end;

        TwoWeightedCentric := function(nodes, start_anchor, end_anchor)
            return MultipleWeightedCentricParameters(nodes, [0,0], start_anchor, end_anchor, 0);
        end;

        MainHelp := function(graph, currents, embedding, spread, nodes_of_faces)
            local cur, res, i, main_help_i, cur_i, neighbours, nodes_of_embedding, case_deciding_neighbours, to_be_positioned_nodes,
                to_be_positioned_nodes_ordered, node, correct_nodes_of_face, next_node_in_order, to_split_vertex, to_split_vertex_pos,
                remaining_nodes_pos, seen_faces, neighbouring_faces_of_tbp_nodes, next_node_in_order_pos, neighbouring_faces_of_pred;
            if Length(currents) >= 2 then   # multiple convex areas
                # Error();
                res := [];
                for i in [1..Length(currents)] do
                    main_help_i := MainHelp(graph, [currents[i]], embedding, spread, nodes_of_faces);
                    cur_i := main_help_i[1];
                    res := Concatenation(res, cur_i);
                    embedding := Set(Concatenation(embedding, main_help_i[2]));
                od;
                return [res, embedding];
            else                            # only one convex area
                # Error();
                cur := currents[1];
                if Length(cur) < 2 then   # trivial convex area
                    # Error();
                    return [[[]], embedding];
                elif Length(cur) = 2 then # area is a line between the 2 nodes inside curv
                    neighbours := NeighboursOfVertex(graph, cur[1][1]);
                    nodes_of_embedding := Deabstract1(embedding);
                    to_be_positioned_nodes := Difference(neighbours, nodes_of_embedding);
                    if to_be_positioned_nodes = [] then # All neighbours have been positioned already
                       Remove(cur, 1);
                       return [[cur], embedding];
                    fi;
                    if not Length(to_be_positioned_nodes) = 1 then # Not sure if this case can occur. In case it does, one has to modify this here somehow.
                        Error(); 
                    fi;
                    next_node_in_order := to_be_positioned_nodes[1];
                    to_be_positioned_nodes_ordered := [next_node_in_order];
                    while true do
                        neighbours := NeighboursOfVertex(graph, next_node_in_order);
                        next_node_in_order := Difference(neighbours, Union(nodes_of_embedding, [next_node_in_order, cur[Length(cur)][1]]));
                        if IsEmpty(next_node_in_order) then
                            break;
                        fi;
                        if Length(next_node_in_order) = 1 then
                            next_node_in_order := next_node_in_order[1];
                        else # Not sure if this case can occur. In case it does, one has to modify this here somehow.
                            Error();
                        fi;
                        Add(to_be_positioned_nodes_ordered, next_node_in_order);
                    od;
                    embedding := Concatenation(embedding, TwoWeightedCentric(to_be_positioned_nodes_ordered, cur[1][2], cur[2][2]));
                    cur := Concatenation(cur, TwoWeightedCentric(to_be_positioned_nodes_ordered, cur[1][2], cur[2][2]));
                    Remove(cur, 1);
                    return [[cur], embedding];
                else                      # non-trivial convex area
                    neighbours := NeighboursOfVertex(graph, cur[1][1]);
                    nodes_of_embedding := Deabstract1(embedding);
                    case_deciding_neighbours := Difference(neighbours, [cur[2][1], cur[Length(cur)][1]]);
                    if Length(Intersection(Deabstract1(cur), case_deciding_neighbours)) = 0 then    # conquer case
                        to_be_positioned_nodes := Difference(neighbours, nodes_of_embedding);
                        # Error();
                        if to_be_positioned_nodes = [] then # All neighbours have been positioned already
                            Remove(cur, 1);
                            return [[cur], embedding];
                        fi;
                        neighbouring_faces_of_tbp_nodes := List(to_be_positioned_nodes, n -> Filtered(nodes_of_faces, f -> IsSubset(f, [cur[1][1], n]))); # "tbp" stands for "to be positoned"
                        to_be_positioned_nodes_ordered := [];
                        seen_faces := [];
                        remaining_nodes_pos := [1..Length(to_be_positioned_nodes)];
                        # Error();
                        neighbouring_faces_of_pred := Filtered(nodes_of_faces, f -> IsSubset(f, [cur[1][1], cur[Length(cur)][1]]));
                        if Length(to_be_positioned_nodes) = 1 then
                            next_node_in_order_pos := [1];
                        else
                            next_node_in_order_pos := Filtered([1..Length(to_be_positioned_nodes)], i -> Length(Intersection(neighbouring_faces_of_tbp_nodes[i], neighbouring_faces_of_pred)) = 1);
                        fi;
                        if Length(next_node_in_order_pos) = 1 then # ensures that the position is unique which should be
                            next_node_in_order_pos := next_node_in_order_pos[1];
                            next_node_in_order := to_be_positioned_nodes[next_node_in_order_pos];
                        else
                            Error();
                        fi;
                        Add(to_be_positioned_nodes_ordered, next_node_in_order);
                        Unbind(remaining_nodes_pos[next_node_in_order_pos]);
                        Add(seen_faces, Intersection(neighbouring_faces_of_tbp_nodes[next_node_in_order_pos], neighbouring_faces_of_pred)[1]);
                        # Error();
                        for i in [2..Length(to_be_positioned_nodes)] do
                            # Error();
                            correct_nodes_of_face := Filtered(nodes_of_faces, x -> CorrectNodesOfFaceFilter(cur[1][1], to_be_positioned_nodes[i], nodes_of_embedding, x));
                            neighbouring_faces_of_pred := Difference(neighbouring_faces_of_tbp_nodes[next_node_in_order_pos], seen_faces);
                            next_node_in_order_pos := Filtered(remaining_nodes_pos, j -> Length(Intersection(neighbouring_faces_of_tbp_nodes[j], neighbouring_faces_of_pred)) = 1);
                            if Length(next_node_in_order_pos) = 1 then # ensures that the position is unique which should be
                                next_node_in_order_pos := next_node_in_order_pos[1];
                                next_node_in_order := to_be_positioned_nodes[next_node_in_order_pos];
                            else
                                Error();
                            fi;
                            Add(to_be_positioned_nodes_ordered, next_node_in_order);
                            Unbind(remaining_nodes_pos[next_node_in_order_pos]);
                            Add(seen_faces, Intersection(neighbouring_faces_of_tbp_nodes[next_node_in_order_pos], neighbouring_faces_of_pred)[1]);
                        od;
                        # Error();
                        embedding := Concatenation(embedding, MultipleWeightedCentricParameters(to_be_positioned_nodes_ordered, cur[1][2], cur[Length(cur)][2], cur[2][2], spread));
                        cur := Concatenation(cur, MultipleWeightedCentricParameters(to_be_positioned_nodes_ordered, cur[1][2], cur[Length(cur)][2], cur[2][2], spread));
                        Remove(cur, 1);
                        # Error();
                        return [[cur], embedding];
                    else                                                                            # divide case
                        to_split_vertex := Intersection(Deabstract1(cur), case_deciding_neighbours)[1];
                        to_split_vertex_pos := Position(Deabstract1(cur), to_split_vertex);
                        # Error();
                        return [SplitListPosition(cur, to_split_vertex_pos), embedding];
                    fi;
                fi;
            fi;
        end;

        DrawConvexPlaneGraph := function(graph, start_face, spread, nodes_of_faces)
            local embedding, currents, main_help, i;
            nodes_of_faces := Difference(nodes_of_faces, [start_face]);
            embedding := RegularPolygon(start_face);
            currents := [embedding];

            while Length(embedding) < Length(DigraphVertices(graph)) do
                for i in Positions(currents, []) do
                    Remove(currents, i);
                od;
                main_help := MainHelp(graph, currents, embedding, spread, nodes_of_faces);
                currents := main_help[1];
                embedding := main_help[2];
            od;
            return embedding;
        end;
        
        if not "spread" in RecNames(printRecord) then
            printRecord.spread := Float(1/2);
        elif printRecord.spread >= Float(1) or printRecord.spread <= Float(0) then
            Error("The spread parameter has to be chosen in the interval (0, 1) !");
        fi;

        undir_version_graph := DigraphSymmetricClosure(graph);
        if (not "nodesOfFaces" in RecNames(printRecord)) and (not IsThreeVertexConnected(graph)) then
            Error("The graph is not polyhedral. You have to define all faces characterised by their surrounding nodes! For more information read the documentation."); # To be changed?
        elif IsThreeVertexConnected(graph) then
            nodes_of_faces := List(__SIMPLICIAL_AllChordlessCyclesOfGraph(undir_version_graph), c -> __SIMPLICIAL_AdjacencyMatrixFromList(c,DigraphNrVertices(undir_version_graph)));
            nodes_of_faces := Filtered(nodes_of_faces, c -> __SIMPLICIAL_IsNonSeparating(undir_version_graph, c));
            nodes_of_faces := List(nodes_of_faces, mat -> __SIMPLICIAL_EdgesFromAdjacencyMat(mat));
            nodes_of_faces := List(nodes_of_faces, face_from_edges -> NodesFromEdgesInFace(face_from_edges));
            printRecord.nodesOfFaces := nodes_of_faces;
        fi;

        if not "infiniteFace" in RecNames(printRecord) then
            max_nodes_face_pos := PositionMaximum(List(printRecord.nodesOfFaces, x -> Length(x)));
            max_nodes_face := printRecord.nodesOfFaces[max_nodes_face_pos];
            printRecord.infiniteFace := max_nodes_face;
        fi;

        embedding := DrawConvexPlaneGraph(graph, printRecord.infiniteFace, printRecord.spread, printRecord.nodesOfFaces);
        SortBy(embedding, x -> x[1]);
        printRecord.nodeCoordinates := List(embedding, x -> x[2]);

        return DrawDigraphToTikz(graph, file, printRecord);
    end
);


InstallMethod( DrawCycleDoubleCoverToTikz,
    "for a planar cubic digraph, a file name and a record",
    [IsDigraph, IsString, IsRecord],
    function(digraph, file, printRecord)
        local IsCubicGraph, graph, MyDistance, VectorDifference, NormalizeVector, AngleBisector,
                LineIntersection, IsPointInPolygon, IsPointOnSegment, VectorsToIntersections,
                HelpPoints, HelpPointsForAllPolygons, allHelpPoints, i, n, e, node, IsThreeVertexConnected,
                cycleEdgeRecord, cycleNodeRecord, output, faceCoordTikZ, cycleEdges, cycle,
                nodeCoordinate, tempRec, f, numberOfCycles, coverCoordinates, j, realCycleEdges,
                realEdge, optionInRecord, graphRecord, coverCoordinatesWithOutInfiniteFace,
                infiniteFaceHelpPoints, infiniteFaceCoordinates;
        IsCubicGraph := function(digraph)
            return ForAll(OutDegrees(digraph), d -> d=3);
        end;

        graph := DigraphSymmetricClosure(digraph);
        if (not IsPlanarDigraph(graph)) or (not IsCubicGraph(graph)) or (not IsString(file)) or (not IsRecord(printRecord)) then
            Error("Input is not correct. See the manual for details.");
        fi;
        if not "cycleDoubleCover" in RecNames(printRecord) then
            Error("For this function you have to input the cycle double cover yourself. For that put the cover in printRecord.cycleDoubleCover. See the manual for details.");
        fi;

        IsThreeVertexConnected := function(graph)
        local node;
            for node in DigraphVertices(graph) do
                if not IsBiconnectedDigraph(DigraphRemoveVertex(graph, node)) then
                    return false;
                fi;
            od;
            return true;
        end;

        MyDistance := function(p1, p2)
            return Sqrt((p2[1] - p1[1])^2 + (p2[2] - p1[2])^2);
        end;

        VectorDifference := function(p1, p2)
            return [p2[1] - p1[1], p2[2] - p1[2]];
        end;

        NormalizeVector := function(v)
            local length;
            length := Float(Sqrt(v[1]^2 + v[2]^2));
            if length < 1.e-6 then
                return [0., 0.];
            fi;
            return [v[1] / length, v[2] / length];
        end;

        AngleBisector := function(v1, v2)
            local n1, n2, bisector;
            n1 := NormalizeVector(v1);
            n2 := NormalizeVector(v2);
            bisector := [n1[1] + n2[1], n1[2] + n2[2]];
            return NormalizeVector(bisector);
        end;

        LineIntersection := function(p1, d1, p2, d2)
            local a1, b1, c1, a2, b2, c2, det, x, y;
            a1 := d1[2];
            b1 := -d1[1];
            c1 := a1 * p1[1] + b1 * p1[2];
            a2 := d2[2];
            b2 := -d2[1];
            c2 := a2 * p2[1] + b2 * p2[2];
            det := a1 * b2 - a2 * b1;
            if AbsoluteValue(det) < 1.e-10 then
                return fail; # Lines are parallel or nearly parallel
            fi;
            x := (b2 * c1 - b1 * c2) / det;
            y := (a1 * c2 - a2 * c1) / det;
            return [x, y];
        end;

        IsPointInPolygon := function(point, polygon)
            local n, i, j, wn;
            n := Length(polygon);
            wn := 0.;
            for i in [1..n] do
                j := (i mod n) + 1;
                if polygon[i][2] <= point[2] then
                    if polygon[j][2] > point[2] and ((polygon[j][1] - polygon[i][1]) * (point[2] - polygon[i][2]) - (polygon[j][2] - polygon[i][2]) * (point[1] - polygon[i][1])) > 0. then
                        wn := wn + 1.;
                    fi;
                else
                    if polygon[j][2] <= point[2] and ((polygon[j][1] - polygon[i][1]) * (point[2] - polygon[i][2]) - (polygon[j][2] - polygon[i][2]) * (point[1] - polygon[i][1])) < 0. then
                        wn := wn - 1.;
                    fi;
                fi;
            od;
            return wn <> 0.;
        end;

        IsPointOnSegment := function(point, p1, p2)
            return (point[1] >= Minimum(p1[1], p2[1]) and point[1] <= Maximum(p1[1], p2[1])
                and point[2] >= Minimum(p1[2], p2[2]) and point[2] <= Maximum(p1[2], p2[2])
                and AbsoluteValue(MyDistance(p1, point) + MyDistance(point, p2) - MyDistance(p1, p2)) < 1.e-10);
        end;

        VectorsToIntersections := function(vertices)
            local n, i, j, k, bisector, intersection, minVector, distance, minDistance, vectors, vPrev, vNext;
            n := Length(vertices);
            vectors := [];
            for i in [1..n] do
                vPrev := VectorDifference(vertices[(i-2) mod n + 1], vertices[i]);
                vNext := VectorDifference(vertices[(i mod n) + 1], vertices[i]);
                bisector := AngleBisector(vPrev, vNext);
                minDistance := 1.e18; # A large number representing infinity
                minVector := fail;
                for j in [1..n] do
                    k := (j mod n) + 1;
                    if i <> j and i <> k then
                        intersection := LineIntersection(vertices[i], bisector, vertices[j], VectorDifference(vertices[j], vertices[k]));
                        if intersection <> fail and IsPointOnSegment(intersection, vertices[j], vertices[k]) then
                            distance := MyDistance(vertices[i], intersection);
                            if distance < minDistance and distance > 0. then
                                minDistance := distance;
                                minVector := VectorDifference(vertices[i], intersection);
                            fi;
                        fi;
                    fi;
                od;
                Add(vectors, minVector);
            od;
            return vectors;
        end;

        # Calculates for one polygon the points for the cycle double cover to go through
        HelpPoints := function(vertices, closeness)
            local i,n, helpPoints, intersectionVectors;
            n := Length(vertices);
            intersectionVectors := VectorsToIntersections(vertices);
            helpPoints := [];
            for i in [1..n] do
                helpPoints[i] := vertices[i] + (closeness * intersectionVectors[i]);
            od;
            return helpPoints;
        end;

        HelpPointsForAllPolygons := function(cover, closeness)
            local i, n, res;
            n := Length(cover);
            res := [];
            for i in [1..n] do
                res[i] := HelpPoints(cover[i], closeness);
            od;
            return res;
        end;

        if not "closeness" in RecNames(printRecord) then
            printRecord.closeness := 0.2;
        fi;

        if not "nodeCoordinates" in RecNames(printRecord) then
            if (not "nodesOfFaces" in RecNames(printRecord)) and (not IsThreeVertexConnected(graph)) then
                Error("You have not put in the coordinates of the nodes of the graph. Hence, the function tried to draw the graph on its own. However, the input graph is not nice enough, i.e. is not polyhedral. In order to have it drawn anyways without explicitly giving the node coordinates, you have to put in the faces of the planar graph into the record, i.e. printRecord.nodesOfFaces would have to contain your faces.");
            fi;
            graphRecord := DrawStraightPlanarDigraphToTikz(digraph,file,printRecord);
            printRecord.nodeCoordinates := graphRecord.nodeCoordinates;
            printRecord.infiniteFace := graphRecord.infiniteFace;
        fi;
        
        coverCoordinates := List(printRecord.cycleDoubleCover, cycle -> List(cycle, node -> printRecord.nodeCoordinates[node]));
        coverCoordinatesWithOutInfiniteFace := coverCoordinates;
        if printRecord.infiniteFace in printRecord.cycleDoubleCover then
            Remove(coverCoordinatesWithOutInfiniteFace, Position(printRecord.cycleDoubleCover, printRecord.infiniteFace));
        fi;
        allHelpPoints := HelpPointsForAllPolygons(coverCoordinatesWithOutInfiniteFace, printRecord.closeness);
        infiniteFaceCoordinates := printRecord.nodeCoordinates{printRecord.infiniteFace};
        infiniteFaceHelpPoints := List(infiniteFaceCoordinates, v -> v+v*(printRecord.closeness));
        Add(allHelpPoints, infiniteFaceHelpPoints, Position(List(printRecord.cycleDoubleCover, cycle -> Set(cycle)), Set(printRecord.infiniteFace)));
        printRecord.cycleNodeCoordinates := allHelpPoints;
        numberOfCycles := Length(printRecord.cycleDoubleCover);
        if not "cycleDoubleCoverColours" in RecNames(printRecord) then
            printRecord.cycleDoubleCoverColours := [];
        fi;

        for i in [1..numberOfCycles] do
            if not IsBound(printRecord.cycleDoubleCoverColours[i]) then
                if (i mod 6) = 0 then
                    printRecord.cycleDoubleCoverColours[i] := "yellow";
                fi;
                if (i mod 6) = 1 then
                    printRecord.cycleDoubleCoverColours[i] := "red";
                fi;
                if (i mod 6) = 2 then
                    printRecord.cycleDoubleCoverColours[i] := "blue";
                fi;
                if (i mod 6) = 3 then
                    printRecord.cycleDoubleCoverColours[i] := "green";
                fi;
                if (i mod 6) = 4 then
                    printRecord.cycleDoubleCoverColours[i] := "orange";
                fi;
                if (i mod 6) = 5 then
                    printRecord.cycleDoubleCoverColours[i] := "cyan";
                fi;
            fi;
        od;

        if not "cycleNodesActive" in RecNames(printRecord) then
            printRecord.cycleNodesActive := false;
        fi;
        ###
        # Following is modified DrawDigraphToTikz
        ###

        # Make the file end with .tex
        if not EndsWith( file, ".tex" ) then
            file := Concatenation( file, ".tex" );
        fi;

        f := Filename( DirectoryCurrent(), file );
        output := OutputTextFile( f, false );
        if output = fail then
            Error(Concatenation("File ", String(file), " can't be opened.") );
        fi;
        printRecord:=__GAPIC__InitializePrintRecord(graph ,printRecord);
        SetPrintFormattingStatus( output, false );

        # Add Header to .tex file 
        tempRec:=ShallowCopy(printRecord);

        # Write this data into the file
        if not printRecord!.onlyTikzpicture then
            AppendTo( output, __GAPIC__PrintRecordGeneralHeader(tempRec));
            AppendTo( output, __GAPIC__PrintRecordTikzHeader(tempRec));
            AppendTo( output, "\n\n\\begin{document}\n\n" );
            if IsBound(printRecord!.caption) then
                AppendTo( output,
                    "\\subsection*{", printRecord!.caption, "}\n \\bigskip\n");
                fi;
            fi;

        AppendTo( output, "\n\n\\begin{tikzpicture}[",
        __GAPIC__PrintRecordTikzOptions(tempRec, graph), "]\n\n" );

        faceCoordTikZ:=[];
        for node in DigraphVertices(graph) do
            faceCoordTikZ[node]:=Concatenation("V",String(node));
        od;
        ##define node coordinates
        for node in DigraphVertices(graph) do
            AppendTo(output	,"\\coordinate (",faceCoordTikZ[node],") at (",
                printRecord.nodeCoordinates[node][1]," , ",printRecord.nodeCoordinates[node][2],");\n");
        od;

        ##draw the cycle double cover
        # Define the help points coordinates
        for i in [1..Length(printRecord.cycleDoubleCover)] do
            cycle := printRecord.cycleDoubleCover[i];
            for j in [1..Length(cycle)] do
                AppendTo(output	,"\\coordinate (", i, "_", cycle[j],") at (",
                    allHelpPoints[i][j][1]," , ",allHelpPoints[i][j][2],");\n");
            od;
        od;
        # Define the cycle edges
        for i in [1..Length(printRecord.cycleDoubleCover)] do
            cycle := printRecord.cycleDoubleCover[i];
            cycleEdges := [[cycle[Length(cycle)], cycle[1]]];
            for j in [1..(Length(cycle)-1)] do
                Add(cycleEdges, [cycle[j], cycle[j+1]]);
            od;
            realCycleEdges := [[Concatenation(String(i), "_", String(cycle[Length(cycle)])), Concatenation(String(i), "_", String(cycle[1]))]];
            for j in [1..(Length(cycle)-1)] do
                Add(realCycleEdges, [Concatenation(String(i), "_", String(cycle[j])), Concatenation(String(i), "_", String(cycle[j+1]))]);
            od;
            cycleEdgeRecord := rec();
            cycleEdgeRecord.directedEdgesActive := false;
            cycleEdgeRecord.edgeColours := [];
            cycleEdgeRecord.edgeLabels := [];
            for e in cycleEdges do
                cycleEdgeRecord.edgeColours[Position(DigraphEdges(graph),e)] := printRecord.cycleDoubleCoverColours[i];
                cycleEdgeRecord.edgeLabels[Position(DigraphEdges(graph),e)] := [];
            od;
            for e in cycleEdges do
                # Error();
                realEdge := realCycleEdges[Position(cycleEdges, e)];
                AppendTo(output,__GAPIC__CycleEdgeRecordDrawEdge(cycleEdgeRecord, graph, Position(DigraphEdges(graph),e),
                    [realEdge[1], realEdge[2]]));
            od;
        od;
        # Define the cycle nodes
        if printRecord.cycleNodesActive = true then
            for i in [1..Length(printRecord.cycleDoubleCover)] do 
                cycle := printRecord.cycleDoubleCover[i];
                cycleNodeRecord := rec();
                cycleNodeRecord.vertexColours := [];
                cycleNodeRecord.nodeLabels := [];
                for j in cycle do
                    cycleNodeRecord.vertexColours[j] := printRecord.cycleDoubleCoverColours[i];
                    cycleNodeRecord.nodeLabels[j] := [];
                od;
                # Error();
                for j in [1..Length(cycle)] do
                    AppendTo(output, __GAPIC__PrintRecordDrawVertex(cycleNodeRecord, cycle[j], Concatenation(String(i), "_", String(cycle[j]))));
                od;
            od;
        fi;

        #draw nodes
        for node in DigraphVertices(graph) do
            AppendTo(output, __GAPIC__PrintRecordDrawVertex(printRecord, node, faceCoordTikZ[node]));
        od;      
    
        ##draw edges
        for e in DigraphEdges(digraph) do 
            AppendTo(output,__GAPIC__PrintRecordDrawEdge(printRecord,digraph, Position(DigraphEdges(digraph),e),
                    faceCoordTikZ{e}));
        od;

        AppendTo(output,"\\end{tikzpicture}\n");
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
        
        for optionInRecord in RecNames(graphRecord) do
            if not optionInRecord in RecNames(printRecord) then
                printRecord.(optionInRecord) := graphRecord.(optionInRecord);
            fi; 
        od;
        return printRecord;
    end
);