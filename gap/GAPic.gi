#
# GAPic: GAP image creator, for visualizing structures
#

# checks wether the required packages for func are available and loads them if so. 
# Otherwise gives an error for what package is missing/failing to load
InstallGlobalFunction( RequiredPackagesAvailable,
function(func)
	local functionalities, packages, requiredPackages, package, load, failString;

	# declare available functionalities and packages
	functionalities := [];
	packages := [];

	# to add a functionality, add the name to the functionalities list and the required packages to the packages list
	# they have to be at the same index in the list, so just add both with the Add() command
	Add(functionalities, "simplicial");
	Add(packages, ["SimplicialSurfaces", "AttributeScheduler", "NautyTracesInterface", "errortest"]); 

	if not Position(functionalities, func) = fail then
		requiredPackages := packages[Position(functionalities, func)];
		for package in requiredPackages do
			if TestPackageAvailability(package) = fail then
				Print("The loading of ",package," failed. This can be due to it not being installed, or not loading correctly.");
				Print("\n The required packages for this function are: \n",requiredPackages);
				Print("\n The error given by the package loader is the following: \n");
				LoadPackage(package);
				return false;
			fi;
		od;
		#if we get here, we have loaded all required packages and return true
		return true;
	else
		Print("The functionality ",func," is not available. Please select one of the following\n");
		Print(functionalities,"\n");
		return false;
	fi;
end );

InstallGlobalFunction( TestRequiredSimplicial,
function()
	Print("checking if simplicial packages are available, result is: \n");
	Print(RequiredPackagesAvailable("simplicial"));

end );