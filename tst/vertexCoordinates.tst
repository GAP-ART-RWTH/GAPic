# tests the two-argument versions of SetVertexCoordinates3D and SetVertexCoordinates3DNC

gap> oct := Octahedron();;
gap> coords := [[ 0, 0, 1 ], [ 1, 1, 0 ], [ 1, -1, 0 ], [ -1, -1, 0 ], [ -1, 1, 0 ], [ 0, 0, -1 ]];;
gap> printRecord := SetVertexCoordinates3DNC(oct, coords);;
gap> printRecord.vertexCoordinates3D = coords;
true
gap> GetVertexCoordinates3DNC(oct, 2, printRecord);
[ 1, 1, 0 ]
gap> SetVertexCoordinates3DNC(oct, coords) = SetVertexCoordinates3D(oct, coords);
true
