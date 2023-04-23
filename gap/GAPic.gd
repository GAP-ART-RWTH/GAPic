#
# GAPic: GAP image creator, for visualizing structures
#
#! @Chapter Introduction
#!
#! GAPic is a package which soon will visualize objects from &GAP;
#!
#! @Chapter Functionality


#! @Section Package checking
#! @SectionLabel PackageChecking
#! @Description
#! The folloing function does check if the required packages for the functionality given as a string 
#! are available, can be loaded and loads them if possible. If not it returns false.
#! @Returns boolean
#! @Arguments a string
DeclareGlobalFunction("RequiredPackagesAvailable");

#! This function is just a quick check for the above function with the parameter "simplicial" already applied.
#! It prints the result to the terminal.
#! @Returns nothing
DeclareGlobalFunction("TestRequiredSimplicial");