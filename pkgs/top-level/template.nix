args:
let 
	defList = [
(assert false) - correct it; List element is of form ["name" default]
	];
	#stdenv and fetchurl are added automatically
	notForBuildInputs = [
(assert false) - correct it; List of names of non-buildInput arguments
	]; 
	getVal = (args.lib.getValue args defList);
	check = args.lib.checkFlag args;
	reqsList = [
(assert false) - correct it; List element is of form ["name" "requirement-name" ... ]
	];
	buildInputsNames = args.lib.filter (x: (null!=getVal x)&&
		(! args.lib.isInList (notForBuildInputs ++ 
		["stdenv" "fetchurl" "lib"] ++ 
		(map builtins.head reqsList)) x)) 
		/*["libX11" "glib" "gtk" "pkgconfig" "libXpm" "libXext" 
			"libXau" "libXt" "libXaw" "ncurses"];*/
		(builtins.attrNames args);
in
	assert args.lib.checkReqs args defList reqsList;
with args; 
args.stdenv.mkDerivation {
  name = "
#!!! Fill me //
" ;
 
  src = args.
#Put fetcher here 
 
  buildInputs = args.lib.filter (x: x!=null) (map getVal buildInputsNames);

  meta = {
    description = "
#Fill description here
";
  };
}
