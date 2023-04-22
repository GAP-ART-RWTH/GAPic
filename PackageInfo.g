#
# GAPic: GAP image creator, for visualizing structures
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "GAPic",
Subtitle := "GAP image creator, for visualizing structures",
Version := "0.1",
Date := "22/04/2023", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
    FirstNames := "Alice",
    LastName := "Niemeyer",
    WWWHome := "http://www.math.rwth-aachen.de/~Alice.Niemeyer/",
    Email := "alice.niemeyer@art.rwth-aachen.de",
    IsAuthor := true,
    IsMaintainer := true,
    PostalAddress := Concatenation(
               "Alice Niemeyer\n",
               "Lehrstuhl für Algebra und Darstellungstheorie\n",
               "RWTH Aachen\n",
               "Pontdriesch 10/16\n",
               "52062 Aachen\n",
               "GERMANY" ),
    Place := "Aachen",
    Institution := "Chair of Algebra and Representation Theory",
  ),
  rec(
    FirstNames := "Lukas",
    LastName := "Schnelle",
    WWWHome := "lukasschnelle.de",
    Email := "lukas.schnelle1@rwth-aachen.de",
    IsAuthor := true,
    IsMaintainer := true,
    PostalAddress := "Lehrstuhl fuer Algebra und Darstellungstheorie, RWTH Aachen, Pontdriesch 10/16 52062 Aachen, GERMANY",
    Place := "Aachen",
    Institution := "Chair of Algebra and Representation Theory",
  ),
],

#SourceRepository := rec( Type := "TODO", URL := "URL" ),
#IssueTrackerURL := "TODO",
PackageWWWHome := "tbd/",
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL     := Concatenation( ~.PackageWWWHome, "README.md" ),
ArchiveURL     := Concatenation( ~.PackageWWWHome,
                                 "/", ~.PackageName, "-", ~.Version ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "GAPic",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "GAP image creator, for visualizing structures",
),

Dependencies := rec(
  GAP := ">= 4.11",
  NeededOtherPackages := [ ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

#Keywords := [ "TODO" ],

));


