# Utility functions.

let

  inherit (builtins)
    head tail isList stringLength substring lessThan sub;

in

rec {


  # Identity function.
  id = x: x;


  # !!! need documentation...
  innerSumArgs = f : x : y : (if y == null then (f x)
	else (innerSumArgs f (x // y)));
  sumArgs = f : innerSumArgs f {};

  innerPairMap = acc: f: l: 
  	if l == [] then acc else
	innerPairMap (acc ++ [(f (head l)(head (tail l)))])
		f (tail (tail l));
  pairMap = innerPairMap [];

  
  # "Fold" a binary function `op' between successive elements of
  # `list' with `nul' as the starting value, i.e., `fold op nul [x_1
  # x_2 ... x_n] == op x_1 (op x_2 ... (op x_n nul))'.  (This is
  # Haskell's foldr).
  fold = op: nul: list:
    if list == []
    then nul
    else op (head list) (fold op nul (tail list));

    
  # Concatenate a list of lists.
  concatLists =
    fold (x: y: x ++ y) [];


  # Concatenate a list of strings.
  concatStrings =
    fold (x: y: x + y) "";


  # Place an element between each element of a list, e.g.,
  # `intersperse "," ["a" "b" "c"]' returns ["a" "," "b" "," "c"].
  intersperse = separator: list:
    if list == [] || tail list == []
    then list
    else [(head list) separator]
         ++ (intersperse separator (tail list));


  concatStringsSep = separator: list:
    concatStrings (intersperse separator list);


  # Flatten the argument into a single list; that is, nested lists are
  # spliced into the top-level lists.  E.g., `flatten [1 [2 [3] 4] 5]
  # == [1 2 3 4 5]' and `flatten 1 == [1]'.
  flatten = x:
    if isList x
    then fold (x: y: (flatten x) ++ y) [] x
    else [x];


  # Return an attribute from nested attribute sets.  For instance ["x"
  # "y"] applied to some set e returns e.x.y, if it exists.  The
  # default value is returned otherwise.
  getAttr = attrPath: default: e:
    let attr = head attrPath;
    in
      if attrPath == [] then e
      else if builtins ? hasAttr && builtins.hasAttr attr e
      then getAttr (tail attrPath) default (builtins.getAttr attr e)
      else default;


  # Filter a list using a predicate; that is, return a list containing
  # every element from `list' for which `pred' returns true.
  filter = pred: list:
    fold (x: y: if pred x then [x] ++ y else y) [] list;


  # Return true if `list' has an element `x':
  elem = x: list: fold (a: bs: x == a || bs) false list;


  # Find the sole element in the list matching the specified
  # predicate, returns `default' if no such element exists, or
  # `multiple' if there are multiple matching elements.
  findSingle = pred: default: multiple: list:
    let found = filter pred list;
    in if found == [] then default
       else if tail found != [] then multiple
       else head found;


  # Return true iff function `pred' returns true for at least element
  # of `list'.
  any = pred: list:
    if list == [] then false
    else if pred (head list) then true
    else any pred (tail list);


  # Return true iff function `pred' returns true for all elements of
  # `list'.
  all = pred: list:
    if list == [] then true
    else if pred (head list) then all pred (tail list)
    else false;


  # Return true if each element of a list is equal, false otherwise.
  eqLists = xs: ys:
    if xs == [] && ys == [] then true
    else if xs == [] || ys == [] then false
    else head xs == head ys && eqLists (tail xs) (tail ys);

    
  # Workaround, but works in stable Nix now.
  eqStrings = a: b: (a+(substring 0 0 b)) == ((substring 0 0 a)+b);

  
  # Determine whether a filename ends in the given suffix.
  hasSuffix = ext: fileName:
    let lenFileName = stringLength fileName;
        lenExt = stringLength ext;
    in !(lessThan lenFileName lenExt) &&
       substring (sub lenFileName lenExt) lenFileName fileName == ext;

  hasSuffixHack = a: b: hasSuffix (a+(substring 0 0 b)) ((substring 0 0 a)+b);
       
  # Bring in a path as a source, filtering out all Subversion and CVS
  # directories, as well as backup files (*~).
  cleanSource =
    let filter = name: type: let baseName = baseNameOf (toString name); in ! (
      # Filter out Subversion and CVS directories.
      (type == "directory" && (name == ".svn" || name == "CVS")) ||
      # Filter out backup files.
      (hasSuffix "~" name)
    );
    in src: builtins.filterSource filter src;


  # Get all files ending with the specified suffices from the given
  # directory.  E.g. `sourceFilesBySuffices ./dir [".xml" ".c"]'.
  sourceFilesBySuffices = path: exts:
    let filter = name: type: 
      let base = baseNameOf (toString name);
      in type != "directory" && any (ext: hasSuffix ext base) exts;
    in builtins.filterSource filter path;


  # Return a singleton list or an empty list, depending on a boolean
  # value.  Useful when building lists with optional elements
  # (e.g. `++ optional (system == "i686-linux") flashplayer').
  optional = cond: elem: if cond then [elem] else [];


  # Return a list of integers from `first' up to and including `last'.
  range = first: last:
    if builtins.lessThan last first
    then []
    else [first] ++ range (builtins.add first 1) last;

    
  # Return true only if there is an attribute and it is true.
  checkFlag = attrSet: name:
	if (name == "true") then true else
	if (name == "false") then false else
	if (isInList (getAttr ["flags"] [] attrSet) name) then true else
	getAttr [name] false attrSet ;

        
  logicalOR = x: y: x || y;
  logicalAND = x: y: x && y;

  
  # Input : attrSet, [ [name default] ... ], name
  # Output : its value or default.
  getValue = attrSet: argList: name:
  ( getAttr [name] (if checkFlag attrSet name then true else
	if argList == [] then null else
	let x = builtins.head argList; in
		if (head x) == name then 
			(head (tail x))
		else (getValue attrSet 
			(tail argList) name)) attrSet );

                        
  # Input : attrSet, [[name default] ...], [ [flagname reqs..] ... ]
  # Output : are reqs satisfied? It's asserted.
  checkReqs = attrSet : argList : condList :
  (
    fold logicalAND true 
      (map (x: let name = (head x) ; in
	
	((checkFlag attrSet name) -> 
	(fold logicalAND true
	(map (y: let val=(getValue attrSet argList y); in
		(val!=null) && (val!=false)) 
	(tail x))))) condList)) ;
	
   
  isInList = list: x:
	if (list == []) then false else
	if (x == (head list)) then true else
	isInList (tail list) x;

          
  uniqList = {inputList, outputList ? []}:
	if (inputList == []) then outputList else
	let x=head inputList; 
	newOutputList = outputList ++
	 (if (isInList outputList x) then [] else [x]);
	in uniqList {outputList=newOutputList; 
		inputList = (tail inputList);};

                
  condConcat = name: list: checker:
	if list == [] then name else
	if checker (head list) then 
		condConcat 
			(name + (head (tail list))) 
			(tail (tail list)) 
			checker
	else condConcat
		name (tail (tail list)) checker;


  /* Options. */
  
  mkOption = attrs: attrs // {_type = "option";};

  typeOf = x: if x ? _type then x._type else "";

  addDefaultOptionValues = defs: opts: opts //
    builtins.listToAttrs (map (defName:
      { name = defName;
        value = 
          let
            defValue = builtins.getAttr defName defs;
            optValue = builtins.getAttr defName opts;
          in
          if typeOf defValue == "option"
          then
            # `defValue' is an option.
            if builtins.hasAttr defName opts
            then builtins.getAttr defName opts
            else defValue.default
          else
            # `defValue' is an attribute set containing options.
            # So recurse.
            if builtins.hasAttr defName opts && builtins.isAttrs optValue 
            then addDefaultOptionValues defValue optValue
            else addDefaultOptionValues defValue {};
      }
    ) (builtins.attrNames defs));
  
  optionAttrSetToDocList = (l: attrs:
    (if (getAttr ["_type"] "" attrs) == "option" then
      [({
	inherit (attrs) description;
      }
      //(if attrs ? example then {inherit(attrs) example;} else {} )
      //(if attrs ? default then {inherit(attrs) default;} else {} )
      //{name = l;}
      )]
      else (concatLists (map (s: (optionAttrSetToDocList 
        (l + (if l=="" then "" else ".") + s) (builtins.getAttr s attrs)))
        (builtins.attrNames attrs)))));

  innerModifySumArgs = f: x: a: b: if b == null then (f a b) // x else 
	innerModifySumArgs f x (a // b);
  modifySumArgs = f: x: innerModifySumArgs f x {};

  debugVal = if builtins ? trace then x: (builtins.trace x x) else x: x;
  debugXMLVal = if builtins ? trace then x: (builtins.trace (builtins.toXML x) x) else x: x;

  innerClosePropagation = ready: list: if list == [] then ready else
    if (head list) ? propagatedBuildInputs then 
      innerClosePropagation (ready ++ [(head list)]) 
        ((head list).propagatedBuildInputs ++ (tail list)) else
      innerClosePropagation (ready ++ [(head list)]) (tail list);

  closePropagation = list: (uniqList {inputList = (innerClosePropagation [] list);});

}
