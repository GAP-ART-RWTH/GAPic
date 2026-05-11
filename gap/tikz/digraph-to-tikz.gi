
# Set the default backend
BindGlobal("DefaultDrawBackend", "tikz");

InstallMethod(SetDrawBackend, 
    [IsString],
    function(backend)
        if not backend in ["tikz", "dot"] then
            Error("Backend must be 'tikz' or 'dot'.\n");
        fi;
        MakeReadWriteGlobal("DefaultDrawBackend");
        DefaultDrawBackend := backend;
        MakeReadOnlyGlobal("DefaultDrawBackend");
    end
);


InstallMethod( SetNodeCoordinates,
    "for a digraph and a list of 2D coordinates",
    [IsDigraph, IsList],
    function( graph, coordinates )
        local printRecord, coord;
        
        # Ensure coordinates match the number of vertices
        if Length(coordinates) <> DigraphNrVertices(graph) then
            Error("The number of coordinates must match the number of vertices.");
        fi;

        for coord in coordinates do
            if Length(coord) <> 2 then
                Error("Coordinate is not of length 2, namely coordinate ", coord, " at position ", Position(coordinates, coord), "\n");
            fi;
        od;
        
        printRecord := rec(
            nodeCoordinates := coordinates,
        );
        
        return printRecord;
    end
);

InstallMethod( DrawDigraph,
    "Unified interface for drawing a digraph",
    [IsDigraph, IsString, IsRecord],
    function( graph, fileName, printRecord )
        if DefaultDrawBackend = "tikz" then
            return DrawDigraphToTikz(graph, fileName, printRecord);
        else
            return DrawDigraphToDot(graph, fileName, printRecord);
        fi;
    end
);

InstallOtherMethod( DrawDigraph, "without record", [IsDigraph, IsString], 
    function(graph, fileName) return DrawDigraph(graph, fileName, rec()); end
);

InstallMethod( DrawDigraphToTikz,
    "for a digraph, a string and a record",
    [IsDigraph, IsString, IsRecord],
    function( graph, fileName, printRecord )
        local file, output, v, coordX, coordY, adj, verts, i, j, u, uvCount, vuCount, isFirst, hasCoords, numCoords, labelStr, e;

        hasCoords := false;
        if IsBound(printRecord.nodeCoordinates) and IsList(printRecord.nodeCoordinates) then
            numCoords := Length(Compacted(printRecord.nodeCoordinates));
            if numCoords > 0 then
                hasCoords := true;
                if numCoords <> DigraphNrVertices(graph) then
                    Error("The number of provided coordinates (", numCoords, ") must exactly match the number of vertices (", DigraphNrVertices(graph), ").\n");
                fi;
            fi;
        fi;

        if not EndsWith( fileName, ".tex" ) then fileName := Concatenation( fileName, ".tex" ); fi;
        file := Filename( DirectoryCurrent(), fileName ); 
        output := OutputTextFile( file, false );
        if output = fail then Error(Concatenation("File ", String(file), " can't be opened.") ); fi;
        SetPrintFormattingStatus( output, false );

        AppendTo( output, __GAPIC__ReadTemplateFromFile("tikz_start.template") );
        AppendTo(output, "\n\t% --- start of generated output --- %\n\n");

        if hasCoords then
            # --- PATH A: Explicit Coordinates Given ---
            for v in DigraphVertices(graph) do
                labelStr := String(v);
                if IsBound(printRecord.nodeLabels) and IsBound(printRecord.nodeLabels[v]) then labelStr := printRecord.nodeLabels[v]; fi;
                
                coordX := String( printRecord.nodeCoordinates[v][1] );
                coordY := String( printRecord.nodeCoordinates[v][2] );
                AppendTo( output, "\t\\node[vertex] (v", String(v), ") at (", coordX, ", ", coordY, ") {$", labelStr, "$};\n" );
            od;
            AppendTo( output, "\n" );
        else
            # --- PATH B: Automatic Layout ---
            AppendTo(output, "\t\\graph [layered layout, grow=down, nodes={vertex}, edges={draw=none}] {\n");
            AppendTo(output, "\t\t% Nodes\n");
            for v in DigraphVertices(graph) do
                labelStr := String(v);
                if IsBound(printRecord.nodeLabels) and IsBound(printRecord.nodeLabels[v]) then labelStr := printRecord.nodeLabels[v]; fi;
                
                # FIXED: Double curly braces protect commas from the pgfkeys parser
                AppendTo(output, "\t\tv", String(v), " [as={{$", labelStr, "$}}];\n");
            od;
            
            AppendTo(output, "\n\t\t% Invisible edges for hierarchical sorting\n");
            for e in DigraphEdges(graph) do
                if e[1] <> e[2] then AppendTo(output, "\t\tv", String(e[1]), " -> v", String(e[2]), ";\n"); fi;
            od;
            AppendTo(output, "\t};\n\n");
        fi;

        adj := AdjacencyMatrix(graph);
        verts := DigraphVertices(graph);
        AppendTo(output, "\t\\foreach \\u/\\v/\\uvCount/\\vuCount in {\n");
        isFirst := true;
        for i in [1..Length(verts)] do
            for j in [i..Length(verts)] do
                u := verts[i]; v := verts[j];
                uvCount := adj[i][j]; vuCount := adj[j][i];
                if uvCount > 0 or vuCount > 0 then
                    if not isFirst then AppendTo(output, ",\n"); fi;
                    isFirst := false;
                    AppendTo(output, "\t\t", String(u), "/", String(v), "/", String(uvCount), "/", String(vuCount));
                fi;
            od;
        od;
        AppendTo(output, "\n\t} {\n\t\t\\drawEdges{\\u}{\\v}{\\uvCount}{\\vuCount}\n\t}\n");
        AppendTo(output, "\n\t% --- end of generated output --- %\n\n");
        AppendTo( output, __GAPIC__ReadTemplateFromFile("tikz_end.template") );
        CloseStream(output);
        
        return printRecord;
    end
);


# binary relation drawing
# with thanks to Manuel Delgado and Pedro Garcia-Sanchez we reuse some of their code to implement here
InstallMethod( DrawBinaryRelation,
    "Unified interface for drawing a binary relation",
    [IsBinaryRelation, IsString, IsRecord],
    function( br, fileName, printRecord )
        local src, labelList, adj, i, j, element, im, graph;
        
        src := AsList(Source(br));
        labelList := [];
        
        for i in [1..Length(src)] do
            labelList[i] := String(src[i]); 
        od;
        
        adj := List([1..Length(src)], x -> []);
        
        # We use the exact flow of the legacy code, but replace the 
        # crashing Dictionary with GAP's native Position() lookup.
        for element in src do
            i := Position(src, element);
            
            for im in Image(br, [element]) do
                j := Position(src, im);
                
                # Position returns 'fail' if the element is not found
                if j <> fail then
                    Add(adj[i], j);
                fi;
            od;
        od;
        
        graph := Digraph(adj);
        
        if not IsBound(printRecord.nodeLabels) then
            printRecord.nodeLabels := labelList;
        fi;
        
        return DrawDigraph(graph, fileName, printRecord);
    end
);

InstallOtherMethod( DrawBinaryRelation, "without record", [IsBinaryRelation, IsString], 
    function(br, fileName) return DrawBinaryRelation(br, fileName, rec()); end
);