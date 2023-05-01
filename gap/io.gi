BindGlobal( "__GAPIC__ReadTemplateFromFile",
    function(relPath)
        local path, input, content;

        path := Filename(DirectoriesPackageLibrary("GAPic", "templates"), relPath);
        if path <> fail then
            input := InputTextFile( path );
            content := ReadAll(input);
            CloseStream(input);
            return content;
        fi;

        Error("Internal Error: ", relPath, " not found in GAP root directories.");
    end
);