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
        __GAPIC__PrintRecordInitBool( printRecord, "vertexLabelsActive", true );
        __GAPIC__PrintRecordInitStringList( printRecord, "vertexLabels", 
            VerticesAttributeOfComplex(surface) );

        __GAPIC__PrintRecordInitBool( printRecord, "edgeLabelsActive", true );
        __GAPIC__PrintRecordInitStringList( printRecord, "edgeLabels", Edges(surface) );

        __GAPIC__PrintRecordInitBool( printRecord, "faceLabelsActive", true );
        __GAPIC__PrintRecordInitStringList( printRecord, "faceLabels", Faces(surface) );
        
        if not IsBound( printRecord!.scale ) then
            printRecord!.scale := 2;
        fi;
        __GAPIC__PrintRecordInitBool(printRecord, "avoidIntersections", true);

        # colours
        __GAPIC__PrintRecordInitStringList(printRecord, "vertexColours", 
            VerticesAttributeOfComplex(surface));
        __GAPIC__PrintRecordInitStringList(printRecord, "edgeColours", Edges(surface));
        __GAPIC__PrintRecordInitStringList(printRecord, "faceColours", Faces(surface));
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

BindGlobal( "__GAPIC__PrintRecordDrawEdge",
    function( printRecord, graph, edge, vertexTikzCoord, vertexCoord )
        local res;

        res := "\\draw[edge";
        # if IsBound( printRecord!.edgeColours[edge] ) then
        #     res := Concatenation(res, "=", printRecord!.edgeColours[edge]);
        # fi;

        res := Concatenation(res, "] (", vertexTikzCoord[1], ") -- node[edgeLabel] {$");
        # if IsBound(printRecord!.edgeLabels[edge]) then
        #     Append(res, printRecord!.edgeLabels[edge]);
        # else
            #Append( res, "e_{" );
            Append( res, String(edge) );
            #Append( res, "}" );
        # fi;
        res := Concatenation(res, "$} (", vertexTikzCoord[2], ");\n" );

        return res;
    end
);

BindGlobal( "__GAPIC__PrintRecordDrawFace",
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

BindGlobal( "__GAPIC__PrintRecordTikzOptions",
    function(printRecord, graph)
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




############################################################

BindGlobal( "__GAPIC__PrintRecordDrawFaceFG",
    function( printRecord, graph, face, faceTikzCoord)
        local res;

        res := "\\vertexLabelR";
        # if IsBound( printRecord!.faceColours[face] ) then
        #     res := Concatenation(res, "[", printRecord!.faceColours[face],"]");
        # fi;

        res := Concatenation( res, "{", faceTikzCoord, "}{left}{$");
        # if IsBound(printRecord!.faceLabels[face]) then
        #     Append(res, printRecord!.faceLabels[face]);
        # else
            Append( res, String(face) );
        # fi;
        Append(res,"$}\n" );

        return res;
    end
);

BindGlobal( "__GAPIC__PrintRecordDrawVertexFG",
    function( printRecord, surface, vertex,vertexCoord )
        local res, i, coord;

        res := "";
        Append(res, "\\node[faceLabel] at (");
	Append(res,String(vertexCoord[1]));
	Append(res,",");
	Append(res,String(vertexCoord[2]));
        Append(res, ") {$");
        if IsBound( printRecord!.vertexLabels[vertex] ) then
            Append(res, printRecord!.vertexLabels[vertex]);
        else
            Append(res, String(vertex));
        fi;
        Append(res, "$};\n" );

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


  
    ## this functions manipulates the printRecord so that functionalities of 
    ## DrawSurfaceToTikZ can be used 

BindGlobal( "__GAPIC__InitializePrintRecord",
    function(graph ,printRecord)
	local g,colour,e,f,v;
	if not IsBound(printRecord.vertexLabelsActive) then
	    printRecord.vertexLabelsActive := false;
	fi;
	if not IsBound(printRecord.latexDocumentclass) then
	    printRecord.latexDocumentclass := "article";
	fi;
	if not IsBound(printRecord.edgeLabelsActive) then
	    printRecord.edgeLabelsActive := false; 
	fi;
	if not IsBound(printRecord.faceLabelsActive) then
	    printRecord.faceLabelsActive := true;
	fi;
	if not IsBound(printRecord.scale) then
	    printRecord.scale :=2;
	fi;
	# if IsBound(printRecord.edgeColours) then
	#     if IsString(printRecord.edgeColours) then
	# 	colour:=printRecord.edgeColours; 
	# 	printRecord.edgeColours:=[];
	# 	for e in Edges(surface) do
	# 	    printRecord.edgeColours[e]:=colour;
	# 	od;
	#     fi;
	# else
	# 	printRecord.edgeColours:=[];
	# fi;	
	if not IsBound(printRecord.edgeLabels) then
	    printRecord.edgeLabels := [];
	fi;
        # if not IsBound(printRecord.faceLabels) then
        #     printRecord.faceLabels := [];
        # fi;
    if not IsBound(printRecord.vertexLabels) then
        printRecord.vertexLabels := [];
    fi;
	# if not IsBound(printRecord.geodesicActive) then
	#     printRecord.geodesicActive:= false;
	# fi;	
	# if not IsBound(printRecord.faceCoordinates2D) then
	#     if IsClosedSurface(surface) and IsVertexFaithful(surface) and EulerCharacteristic(surface)=2 then
	# 	printRecord.faceCoordinates2D:= __GAPIC__SetFaceCoordinates(surface);
	#     else 
	# 	Error("face coordinates have to be specified");
	#    fi;
	# else 
    # if not __GAPIC__IsCoordinates2D(graph,printRecord.faceCoordinates2D) then
    #     Error("face coordinates have to be in the correct format");
    # fi;
	# fi;	
	# if printRecord.edgeLabelsActive and printRecord.edgeLabels=[] then
	#     for e in Edges(surface) do
	# 	printRecord.edgeLabels[e]:=String(e);
	#     od;
	# fi;
    #     if printRecord.faceLabelsActive and printRecord.faceLabels=[] then
    #         for f in Faces(surface) do
    #             printRecord.faceLabels[f]:=String(f);
    #         od;
    #     fi;
    #     if printRecord.vertexLabelsActive and printRecord.vertexLabels=[] then
    #         for v in Vertices(surface) do
    #             printRecord.vertexLabels[v]:=String(v);
    #         od;
    #     fi;
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

    #     if IsBound(printRecord.vertexColours) then
    #         if IsString(printRecord.vertexColours) then
    #             colour:=printRecord.vertexColours;
    #             printRecord.vertexColours:=[];
    #             for v in Vertices(surface) do
    #                 printRecord.vertexColours[v]:=colour;
    #             od;
    #         fi;
    #     else
    #             printRecord.vertexColours:=[];
    #     fi;
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
        sum,newCoor,minX,minY,mX,mY,geodesic,i,j,currUmb,coordinates,temp,
        umbrellas,color,tempRec, node;

        sum:=function(L)
        local g,s,n;
        s:=[0.,0.];
        n:=Length(L);
        for g in L do
            s:=1./n*g+s;
        od;
        return s;
        end;

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
        # tempRec.faceLabelsActive:= printRecord.vertexLabelsActive;
        # tempRec.vertexLabelsActive:= printRecord.faceLabelsActive;
        # tempRec.vertexLabels:=printRecord.faceLabels;
        # tempRec.faceLabels:=printRecord.vertexLabels;
        # tempRec.vertexColours:=printRecord.faceColours;
        # tempRec.faceColours:=printRecord.vertexColours;

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

    #    AppendTo( output,__GAPIC__PrintRecordGeneralHeader(tempRec));
    #    AppendTo( output,__GAPIC__PrintRecordTikzHeader(tempRec));
    #    AppendTo( output, "\n\n\\begin{document}\n");
        AppendTo( output, "\n\n\\begin{tikzpicture}[",
        __GAPIC__PrintRecordTikzOptions(tempRec, graph), "]\n\n" );

        faceCoordTikZ:=[];
        for node in DigraphVertices(graph) do
            faceCoordTikZ[node]:=Concatenation("V",String(node));
        od;
        ##define face coordinates
        for node in DigraphVertices(graph) do
        AppendTo(output	,"\\coordinate (",faceCoordTikZ[node],") at (",
            printRecord.faceCoordinates2D[node][1]," , ",printRecord.faceCoordinates2D[node][2],");\n");
            #AppendTo(output,__GAPIC__PrintRecordDrawFaceFG(printRecord, surface, face, faceTikzCoord));
        od;

        ##draw edges
        for e in DigraphEdges(graph) do 
            AppendTo(output,__GAPIC__PrintRecordDrawEdge(printRecord,graph,e,
                    faceCoordTikZ{e},printRecord.faceCoordinates2D{e}));
        od;
        ##draw faces as nodes
    #    for f in Faces(surface) do
    #	AppendTo(output,"\\vertexLabelR{",faceCoordTikZ[f],"}{left}{$",f,"$}\n");
    #   od;

        AppendTo( output, "% Draw the faces\n" );
        for node in DigraphVertices(graph) do
            AppendTo( output, __GAPIC__PrintRecordDrawFaceFG( printRecord, graph, node, faceCoordTikZ[node]));
        od;

    #     umbrellas:=printRecord.nodesOfFaces;
    #     currUmb:=Filtered(umbrellas,umb->Length(umb)=Maximum(List(umbrellas, umb -> Length(umb))))[1];

    #     ## draw vertex labels
    #     if IsBound(printRecord.vertexLabelsActive) then 
    #     if printRecord.vertexLabelsActive then
    #     # at first draw vertex label of the outer umbrella
    #         v:=Filtered(Vertices(surface),v->Set(FacesOfVertex(surface,v))=Set(currUmb))[1];
    #         umbrellas:=Difference(umbrellas,[currUmb]);
    #         coordinates:=List(currUmb,f->printRecord.faceCoordinates2D[f]);
    #         maxX:=Maximum(List(coordinates,g->g[1]));
    #         maxY:=Maximum(List(coordinates,g->g[2]));
    #         minY:=Minimum(List(coordinates,g->g[2]));
    # #	    AppendTo(output,"\\node[faceLabel,scale=1.5] at (",maxX+1.,",",minY+1/2*(maxY-minY),") {$",v,"$};\n");
    #         AppendTo(output,__GAPIC__PrintRecordDrawVertexFG(printRecord, surface, v,[maxX+1.,minY+1/2*(maxY-minY)]) ); 
    #         ## now the other labels 
    #         for umb in umbrellas do
    #         v:=Filtered(Vertices(surface),v->Set(FacesOfVertex(surface,v))=Set(umb))[1];
    #         coordinates:=List(umb,f->printRecord.faceCoordinates2D[f]);
    #         temp:=sum(coordinates);
    #         AppendTo(output,__GAPIC__PrintRecordDrawVertexFG(printRecord,surface,v,temp));
    #         od; 
    #     fi;
    #     fi;

        # # draw geodesics 
        # if IsBound(printRecord.geodesicActive) then 
        # if printRecord.geodesicActive and EulerCharacteristic(surface)=2 then
        #     coordinates:=[]; 
        #     coordinates:=List(Vertices(surface),v->[]);
        #     for umb in umbrellas do
        #     v:=Filtered(Vertices(surface),v->Set(FacesOfVertex(surface,v))=Set(umb))[1];
        #     temp:=List(umb,f->printRecord.faceCoordinates2D[f]);
        #     for f in umb do 
        #         coordinates[v][f]:=printRecord.faceCoordinates2D[f]+0.1*(sum(temp)-printRecord.faceCoordinates2D[f]);
        #     od;
        #     od;
        #     v:=Filtered(Vertices(surface),v->Set(FacesOfVertex(surface,v))=Set(currUmb))[1];
        #     temp:=sum(List(currUmb,f->printRecord.faceCoordinates2D[f]));
        #     maxX:=Maximum(List(currUmb,f->printRecord.faceCoordinates2D[f][1]));
        #     maxY:=Maximum(List(currUmb,f->printRecord.faceCoordinates2D[f][2]));
        #     minX:=Minimum(List(currUmb,f->printRecord.faceCoordinates2D[f][1]));
        #     minY:=Minimum(List(currUmb,f->printRecord.faceCoordinates2D[f][2]));
        #     mX:=maxX-minX;
        #     mY:=maxY-minY;
        #     for f in currUmb do 
        #     coordinates[v][f]:=printRecord.faceCoordinates2D[f];
        #     if printRecord.faceCoordinates2D[f][1]=minX then 
        #         coordinates[v][f]:=coordinates[v][f]-[0.05*mX,0.];
        #     fi;
        #     if printRecord.faceCoordinates2D[f][2]=minY then 
        #         coordinates[v][f]:=coordinates[v][f]-[0.,0.05*mY];
        #     fi;
        #     if printRecord.faceCoordinates2D[f][1]=maxX then 
        #         coordinates[v][f]:=coordinates[v][f]+[0.05*mX,0.];
        #     fi;
        #     if printRecord.faceCoordinates2D[f][2]=maxY then 
        #         coordinates[v][f]:=coordinates[v][f]+[0.,0.05*mY];
        #     fi;
        #     od;
        #     color:=["red","blue","green","yellow","brown","gray","pink"];
        #     geodesic:=MaximalGeodesicPaths(surface);
        #     geodesic:=List(geodesic,g->ShallowCopy(FacesAsList(g)));
        #     for i in [1..Length(geodesic)] do 
        #     Add(geodesic[i],geodesic[i][1]);
        #     Add(geodesic[i],geodesic[i][2]);
        #     for j in [1..Length(geodesic[i])-2] do 
        #         f1:=geodesic[i][j];
        #         f2:=geodesic[i][j+1];
        #         f3:=geodesic[i][j+2];
        #         e1:=Filtered(Edges(surface),e->FacesOfEdge(surface,e)=Set([f1,f2]))[1];
        #         e2:=Filtered(Edges(surface),e->FacesOfEdge(surface,e)=Set([f2,f3]))[1];	
        #         v:=VerticesOfEdge(surface,e1);
        #         v1:=Filtered(v,g-> not g in VerticesOfEdge(surface,e2))[1];
        #         v2:=Difference(v,[v1])[1];
        #         AppendTo(output,"\\draw[edge=",color[i],"] (",
        #             coordinates[v1][f1][1],",",coordinates[v1][f1][2],") -- (",
        #             coordinates[v2][f2][1],",",coordinates[v2][f2][2],");\n");
        #     od;
        #     od;
        # fi;
        # fi;

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

InstallMethod( DrawConvexPlaneGraphToTikz,
    "for a planar digraph, a file name and a record",
    [IsDigraph, IsString, IsRecord],
    function(graph, file, printRecord)
        local RegularPolygon, Deabstract, Deabstract1, NeighboursOfVertex, SplitListPosition, InFilterFunc,
                IntersectionFilterFunc, CorrectNodesOfFaceFilter, MultipleWeightedCentricParameters, MainHelp,
                DrawConvexPlaneGraph, embedding;

        if (not IsPlanarDigraph(graph)) or (not IsString(file)) or (not IsRecord(printRecord)) then
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
            return Concatenation(InNeighboursOfVertex(graph, vertex), OutNeighboursOfVertex(graph, vertex));
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

        InFilterFunc := function(cur1, cur2, list) # help function
            if cur1 in list and cur2 in list then
                return true;
            else
                return false;
            fi;
        end;

        IntersectionFilterFunc := function(faceGraph, list) # help function
            if not IsEmpty(Intersection(faceGraph, list)) then
                return true;
            else 
                return false;
            fi;
        end;

        CorrectNodesOfFaceFilter := function(cur1, cur2, faceGraph, list) # help function
            return InFilterFunc(cur1, cur2, list) and IntersectionFilterFunc(faceGraph, list);
        end;

        MultipleWeightedCentricParameters := function(list, main_anchor, start_anchor, end_anchor, p) # help function
            local res, n, i;
            res := [];
            n := Length(list) + 1;
            for i in [1..Length(list)] do
                Add(res, [list[i], p*main_anchor + (1-p)*(Float((n-i)/n)*start_anchor + Float(i/n)*end_anchor)]);
            od;
            return res;
        end;

        MainHelp := function(graph, currents, embedding, spread, nodes_of_faces)
            local cur, res, i, main_help_i, cur_i, neighbours, nodes_of_embedding, case_deciding_neighbours, to_be_positioned_nodes,
                to_be_positioned_nodes_ordered, node, correct_nodes_of_face, next_node_in_order, to_split_vertex, to_split_vertex_pos,
                seen_nodes;
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
                if Length(cur) < 2 then  # trivial convex area
                    # Error();
                    return [[[]], embedding];
                else                    # non-trivial convex area
                    neighbours := NeighboursOfVertex(graph, cur[1][1]);
                    nodes_of_embedding := Deabstract1(embedding);
                    case_deciding_neighbours := Difference(neighbours, [cur[2][1], cur[Length(cur)][1]]);
                    if Length(Intersection(Deabstract1(cur), case_deciding_neighbours)) = 0 then    # conquer case
                        to_be_positioned_nodes := Difference(neighbours, nodes_of_embedding);
                        to_be_positioned_nodes_ordered := [];
                        seen_nodes := [];
                        correct_nodes_of_face := Filtered(nodes_of_faces, x -> CorrectNodesOfFaceFilter(cur[1][1], cur[Length(cur)][1], nodes_of_embedding, x));
                        next_node_in_order := Intersection(to_be_positioned_nodes, correct_nodes_of_face[1])[1];
                        Add(to_be_positioned_nodes_ordered, next_node_in_order);
                        Add(seen_nodes, next_node_in_order);
                        # Error();
                        for i in [2..Length(to_be_positioned_nodes)] do
                            # Error(); # TODO
                            correct_nodes_of_face := Filtered(nodes_of_faces, x -> CorrectNodesOfFaceFilter(cur[1][1], to_be_positioned_nodes[i], nodes_of_embedding, x));
                            next_node_in_order := Difference(Intersection(to_be_positioned_nodes, correct_nodes_of_face[1]), seen_nodes)[1];
                            Add(to_be_positioned_nodes_ordered, next_node_in_order);
                            Add(seen_nodes, next_node_in_order);
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
            local embedding, currents, main_help;
            nodes_of_faces := Difference(nodes_of_faces, [start_face]);
            embedding := RegularPolygon(start_face);
            currents := [embedding];

            while Length(embedding) < Length(DigraphVertices(graph)) do
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

        if not "startFace" in RecNames(printRecord) then
            Error("Select a start face!"); # To be changed?
        # else
        #     printRecord.startFace := start_face;
        fi;

        if not "nodesOfFaces" in RecNames(printRecord) then
            Error("Select all faces characterised by their surrounding nodes!"); # To be changed?
        # else
        #     printRecord.nodesOfFaces := nodes_of_faces;
        fi;

        embedding := DrawConvexPlaneGraph(graph, printRecord.startFace, printRecord.spread, printRecord.nodesOfFaces);
        SortBy(embedding, x -> x[1]);
        printRecord.faceCoordinates2D := List(embedding, x -> x[2]);

        return DrawDigraphToTikz(graph, file, printRecord);
        # if "scale" in RecNames(record) and "faceCoordinates2D" in RecNames(record) then
        #     return DrawFacegraphToTikz(surf, name, record);
        # elif (not "scale" in RecNames(record)) and "faceCoordinates2D" in RecNames(record) then
        #     record.scale := 4;
        # elif "scale" in RecNames(record) and (not "faceCoordinates2D" in RecNames(record)) then
        #     record.faceCoordinates2D := List(graph, x -> x[2]);
        # else
        #     record.faceCoordinates2D := List(graph, x -> x[2]);
        #     record.scale := 4;
        # fi;
        
    end
);