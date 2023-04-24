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

##  <#GAPDoc Label="TestRequiredSimplicial">
##  <ManSection>
##  <Func Name="TestRequiredSimplicial" Arg="none"/>
##
##  <Description>
##  This function is just a quick check for the above function with the parameter "simplicial" already applied.
##  It prints the result to the terminal.

##  <Alt Only="HTML">&lt;img src="../images/ico.png">&lt;/img></Alt>
##  <Alt Only="LaTeX">\includegraphics{../images/ico.png}</Alt>
##  <Alt Only="Text">[Image omitted in text manual. Check doc/images/ico.png]</Alt>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction("TestRequiredSimplicial");