# The package

GAP image creator, GAPic for short, is a package to visualize mathematical structures which can be generated using the GAP language. It does not function alone, but rather extends other packages functionalities as to be independent of them.

## History
While developing the [SimplicialSurfaces](https://github.com/gap-packages/SimplicialSurfaces) package we wrote a functionality that visualizes simplicial surfaces. As the function grew and was improved we also managed to visualize more general triagonal complexes. To give all these functions a home, this package was then developed. 

## Stage of the project
The package is currently under development and will as a first step gain the functionality of the ```DrawSurfaceToJavascript``` function from the before mentioned package. There are plans to incorporate other functionalities, when that happens we will update this readme.

### ToDos
- [x] Prototype for checking if necessary packages are installed
    Will be done with the new function from GAP 4.13 which checks if a Package is Loaded, see https://github.com/GAP-ART-RWTH/GAPic/issues/15
    First version done with [6154816](https://github.com/GAP-ART-RWTH/GAPic/commit/615481673a4307907de49704bb99eb3c69ebf0c7)
- [x] Add DrawSurfaceToJavascript functionality (now called DrawComplexToJavascript)

## Contact

Feel free to contact us via the given contacts in the ```PackageInfo.g``` or write an Issue in that tab

## License

TODO: Provide information on the license of your package. A license is
important as it determines who has a right to distribute your package. The
"default" license to consider is GNU General Public License v2 or later, as
that is the license of GAP itself.
