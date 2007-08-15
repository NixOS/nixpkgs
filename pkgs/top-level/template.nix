args:
let 
	defList = [
(assert false) - correct it; List element is of form ["name" default]
	];
	#stdenv and fetchurl are added automatically
	getVal = (args.lib.getValue args defList);
	check = args.lib.checkFlag args;
	reqsList = [
(assert false) - correct it; List element is of form ["name" "requirement-name" ... ]
		["true"]
		["false"]
	];
	buildInputsNames = args.lib.filter (x: (null!=getVal x)) 
		(args.lib.uniqList {inputList = 
		(args.lib.concatLists (map 
		(x:(if (x==[]) then [] else builtins.tail x)) 
		reqsList));});
	configFlags = [
		"true" ""
(assert false) - fill it; list consists of pairs "condition" "flags". "True" means always.
	];
	nameSuffixes = [
(assert false) - fill it if needed, or blank it.
	];
in
	assert args.lib.checkReqs args defList reqsList;
with args; 
args.stdenv.mkDerivation {
  name = args.lib.condConcat "
#Fill the name //
" nameSuffixes check;
 
  src = args.
#Put fetcher here 
 
  buildInputs = args.lib.filter (x: x!=null) (map getVal buildInputsNames);
  configureFlags = args.lib.condConcat "" configFlags check;

  meta = {
    description = "
#Fill description here
";
  };
}
