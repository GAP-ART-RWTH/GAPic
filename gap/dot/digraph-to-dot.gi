InstallMethod( DrawDigraphToDot,
    "for a digraph, a string and a record",
    [IsDigraph, IsString, IsRecord],
    function( graph, fileName, printRecord )
        local file, output, v, e, coordX, coordY, hasCoords, numCoords, labelStr;

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

        if not EndsWith( fileName, ".dot" ) then fileName := Concatenation( fileName, ".dot" ); fi;
        file := Filename( DirectoryCurrent(), fileName ); 
        output := OutputTextFile( file, false );
        if output = fail then Error(Concatenation("File ", String(file), " can't be opened.") ); fi;
        SetPrintFormattingStatus( output, false );

        AppendTo( output, "digraph G {\n" );
        
        if not hasCoords then
            # rankdir=TB forces the graph to draw top-to-bottom natively
            AppendTo( output, "\toverlap=false;\n\tsplines=true;\n\trankdir=TB;\n" );
        fi;

        AppendTo( output, "\n\t// Nodes\n" );
        for v in DigraphVertices(graph) do
            labelStr := String(v);
            if IsBound(printRecord.nodeLabels) and IsBound(printRecord.nodeLabels[v]) then labelStr := printRecord.nodeLabels[v]; fi;

            if hasCoords then
                coordX := String( Float(printRecord.nodeCoordinates[v][1]) );
                coordY := String( Float(printRecord.nodeCoordinates[v][2]) );
                AppendTo( output, "\t\"", String(v), "\" [pos=\"", coordX, ",", coordY, "!\", label=\"", labelStr, "\"];\n" );
            else
                AppendTo( output, "\t\"", String(v), "\" [label=\"", labelStr, "\"];\n" );
            fi;
        od;

        AppendTo( output, "\n\t// Edges\n" );
        for e in DigraphEdges(graph) do
            AppendTo( output, "\t\"", String(e[1]), "\" -> \"", String(e[2]), "\";\n" );
        od;
        AppendTo( output, "}\n" );
        CloseStream(output);
            
        return printRecord;
    end
);

# Fallback wrapper to catch calls missing the printRecord argument
InstallOtherMethod( DrawDigraphToDot, 
    "for a digraph and a file name",
    [IsDigraph, IsString],
    function(graph, fileName)
        return DrawDigraphToDot(graph, fileName, rec());
    end
);