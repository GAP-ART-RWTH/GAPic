
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

InstallMethod( DrawDigraphToTikz,
    "for a digraph, a string and a record",
    [IsDigraph, IsString, IsRecord],
    function( graph, fileName, printRecord )
        local file, output, v, e, coordX, coordY;

        if not IsBound(printRecord.nodeCoordinates) then
            Error("printRecord must contain nodeCoordinates. Please run SetNodeCoordinates first.\n");
        fi;

        if not EndsWith( fileName, ".tex" ) then
            fileName := Concatenation( fileName, ".tex" );
        fi;

        file := Filename( DirectoryCurrent(), fileName ); #TODO allow absolute paths
        output := OutputTextFile( file, false );
        if output = fail then
            Error(Concatenation("File ", String(file), " can't be opened.") );
        fi;
        SetPrintFormattingStatus( output, false );

        AppendTo( output, __GAPIC__ReadTemplateFromFile("tikz_start.template") );

        AppendTo(output, "\n\t% --- start of generated output --- %\n\n");

        # --- Generate Standard TikZ Nodes ---
        for v in DigraphVertices(graph) do
            coordX := String( printRecord.nodeCoordinates[v][1] );
            coordY := String( printRecord.nodeCoordinates[v][2] );
            
            # Format: \node[vertex] (v1) at (X, Y) {1};
            AppendTo( output, "\t\\node[vertex] (v", String(v), ") at (", coordX, ", ", coordY, ") {$", String(v), "$};\n" );
        od;

        AppendTo( output, "\n" );

        adj := AdjacencyMatrix(graph);
        verts := DigraphVertices(graph);

        AppendTo(output, "\t% Format: source / target / count_src_to_tgt / count_tgt_to_src\n");
        AppendTo(output, "\t\\foreach \\u/\\v/\\uvCount/\\vuCount in {\n");
        
        isFirst := true;
        
        # Iterate over the upper triangle of the adjacency matrix (including diagonal)
        for i in [1..Length(verts)] do
            for j in [i..Length(verts)] do
                u := verts[i];
                v := verts[j];
                uvCount := adj[i][j];
                vuCount := adj[j][i];
                
                # If there are any edges between these two nodes (or a self loop)
                if uvCount > 0 or vuCount > 0 then
                    if not isFirst then AppendTo(output, ",\n"); fi;
                    isFirst := false;
                    AppendTo(output, "\t\t", String(u), "/", String(v), "/", String(uvCount), "/", String(vuCount));
                fi;
            od;
        od;

        AppendTo(output, "\n\t} {\n");
        AppendTo(output, "\t\t\\drawEdges{\\u}{\\v}{\\uvCount}{\\vuCount}\n");
        AppendTo(output, "\t}\n");

        AppendTo(output, "\n\t% --- end of generated output --- %\n\n");

        AppendTo( output, __GAPIC__ReadTemplateFromFile("tikz_end.template") );


        CloseStream(output);
            
        return printRecord;
    end
);