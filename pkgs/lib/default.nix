# Utility functions.

let

  inherit (builtins)
    head tail isList stringLength substring lessThan sub
    listToAttrs attrNames hasAttr;

in

rec {
  listOfListsToAttrs = ll : builtins.listToAttrs (map (l : { name = (head l); value = (head (tail l)); }) ll);


  # Identity function.
  id = x: x;


  # accumulates / merges all attr sets until null is fed.
  # example: sumArgs id { a = 'a'; x = 'x'; } { y = 'y'; x = 'X'; } null
  # result : { a = 'a'; x = 'X'; y = 'Y'; }
  innerSumArgs = f : x : y : (if y == null then (f x)
	else (innerSumArgs f (x // y)));
  sumArgs = f : innerSumArgs f {};

  # Advanced sumArgs version. Hm, twice as slow, I'm afraid.
  # composedArgs id (x:x//{a="b";}) (x:x//{b=x.a + "c";}) null;
  # {a="b" ; b="bc";};
  innerComposedArgs = f : x : y : (if y==null then (f x)
  	else (if (builtins.isAttrs y) then 
		(innerComposedArgs f (x//y))
	else (innerComposedArgs f (y x))));
  composedArgs = f: innerComposedArgs f {};

  defaultMergeArg = x : y: if builtins.isAttrs y then
    y
  else 
    (y x);
  defaultMerge = x: y: x // (defaultMergeArg x y);
  sumTwoArgs = f: x: y: 
    f (defaultMerge x y);
  foldArgs = merger: f: init: x: 
    let arg=(merger init (defaultMergeArg init x)); in  
      # now add the function with composed args already applied to the final attrs
    setAttrMerge "passthru" {} (f arg) ( x : x // { function = foldArgs merger f arg; } );

  # returns f x // { passthru.fun = y : f (merge x y); } while preserving other passthru names.
  # example: let ex = applyAndFun (x : removeAttrs x ["fixed"])  (mergeOrApply mergeAttr) {name = 6;};
  #              usage1 = ex.passthru.fun { name = 7; };    # result: { name = 7;}
  #              usage2 = ex.passthru.fun (a: a // {name = __add a.name 1; }); # result: { a = 7; }
  # fix usage:
  #              usage3a = ex.passthru.fun (a: a // {name2 = a.fixed.toBePassed; }); # usage3a will fail because toBePassed is not yet given
  #              usage3b usage3a.passthru.fun { toBePassed = "foo";}; # result { name = 7; name2 = "foo"; toBePassed = "foo"; fixed = <this attrs>; }
  applyAndFun = f : merge : x : assert (__isAttrs x || __isFunction x);
    let takeFix = if (__isFunction x) then x else (attr: merge attr x); in
    setAttrMerge "passthru" {} (fix (fixed : f (takeFix {inherit fixed;})))
      ( y : y //
        {
          fun = z : applyAndFun f merge (fixed: merge (takeFix fixed) z);
          funMerge = z : applyAndFun f merge (fixed: let e = takeFix fixed; in merge e (merge e z));
        } );
  mergeOrApply = merge : x : y : if (__isFunction y) then  y x else merge x y;

  # rec { # an example of how composedArgsAndFun can be used
  #  a  = composedArgsAndFun (x : x) { a = ["2"]; meta = { d = "bar";}; };
  #  # meta.d will be lost ! It's your task to preserve it (eg using a merge function)
  #  b  = a.passthru.function { a = [ "3" ]; meta = { d2 = "bar2";}; };
  #  # instead of passing/ overriding values you can use a merge function:
  #  c  = b.passthru.function ( x: { a = x.a  ++ ["4"]; }); # consider using (maybeAttr "a" [] x)
  # }
  # result:
  # {
  #   a = { a = ["2"];     meta = { d = "bar"; }; passthru = { function = .. }; };
  #   b = { a = ["3"];     meta = { d2 = "bar2"; }; passthru = { function = .. }; };
  #   c = { a = ["3" "4"]; meta = { d2 = "bar2"; }; passthru = { function = .. }; };
  #   # c2 is equal to c
  # }
  composedArgsAndFun = f: foldArgs defaultMerge f {};

  # example a = pairMap (x : y : x + y) ["a" "b" "c" "d"];
  # result: ["ab" "cd"]
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

  # Haskell's fold
  foldl = op: nul: list:
    if list == []
    then nul
    else fold op (op nul (head list)) (tail list);

    
  # Concatenate a list of lists.
  concatList = x : y : x ++ y;
  concatLists = fold concatList [];


  # Concatenate a list of strings.
  concatStrings =
    fold (x: y: x + y) "";


  # Map and concatenate the result.
  concatMap = f: list: concatLists (map f list);

  concatMapStrings = f: list: concatStrings (map f list);
  

  # Place an element between each element of a list, e.g.,
  # `intersperse "," ["a" "b" "c"]' returns ["a" "," "b" "," "c"].
  intersperse = separator: list:
    if list == [] || tail list == []
    then list
    else [(head list) separator]
         ++ (intersperse separator (tail list));

  toList = x : if (__isList x) then x else [x];

  concatStringsSep = separator: list:
    concatStrings (intersperse separator list);

  makeLibraryPath = paths: concatStringsSep ":" (map (path: path + "/lib") paths);


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
  # comment: there is also builtins.getAttr ? (is there a better name for this function?)
  getAttr = attrPath: default: e:
    let attr = head attrPath;
    in
      if attrPath == [] then e
      else if builtins ? hasAttr && builtins.hasAttr attr e
      then getAttr (tail attrPath) default (builtins.getAttr attr e)
      else default;

  # shortcut for getAttr ["name"] default attrs
  maybeAttr = name: default: attrs:
    if (__hasAttr name attrs) then (__getAttr name attrs) else default;


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

  # much shorter implementations using map and fold (are lazy as well)
  # which ones are better?
  # true if all/ at least one element(s) satisfy f
  # all = f : l : fold logicalAND true (map f l);
  # any = f : l : fold logicalOR false (map f l);


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
      (type == "directory" && (baseName == ".svn" || baseName == "CVS")) ||
      # Filter out backup files.
      (hasSuffix "~" baseName)
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


  # Return a list or an empty list, dependening on a boolean value.
  optionals = cond: elems: if cond then elems else [];

  optionalString = cond: string: if cond then string else "";

  # Return the second argument if the first one is true or the empty version
  # of the second argument.
  ifEnable = cond: val:
    if cond then val
    else if builtins.isList val then []
    else if builtins.isAttrs val then {}
    # else if builtins.isString val then ""
    else if (val == true || val == false) then false
    else null;

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

  uniqListExt = {inputList, outputList ? [],
    getter ? (x : x), compare ? (x: y: x==y)}:
	if (inputList == []) then outputList else
	let x=head inputList; 
	isX = y: (compare (getter y) (getter x));
	newOutputList = outputList ++
	 (if any isX outputList then [] else [x]);
	in uniqListExt {outputList=newOutputList; 
		inputList = (tail inputList);
		inherit getter compare;
		};


                
  condConcat = name: list: checker:
	if list == [] then name else
	if checker (head list) then 
		condConcat 
			(name + (head (tail list))) 
			(tail (tail list)) 
			checker
	else condConcat
		name (tail (tail list)) checker;

  # Merge sets of attributes and use the function f to merge
  # attributes values.
  zip = f: sets:
    builtins.listToAttrs (map (name: {
      inherit name;
      value =
        f name
          (map (__getAttr name)
            (filter (__hasAttr name) sets));
    }) (concatMap builtins.attrNames sets));

  # divide a list in two depending on the evaluation of a predicate.
  partition = pred:
    fold (h: t:
      if pred h
      then { right = [h] ++ t.right; wrong = t.wrong; }
      else { right = t.right; wrong = [h] ++ t.wrong; }
    ) { right = []; wrong = []; };

  # Take a function and evaluate it with its own returned value.
  fix = f:
    (rec { result = f result; }).result;

  # flatten a list of elements by following the properties of the elements.
  # next   : return the list of following elements.
  # seen   : lists of elements already visited.
  # default: result if 'x' is empty.
  # x      : list of values that have to be processed.
  uniqFlatten = next: seen: default: x:
    if x == []
    then default
    else
      let h = head x; t = tail x; n = next h; in
      if elem h seen
      then uniqFlatten next seen default t
      else uniqFlatten next (seen ++ [h]) (default ++ [h]) (n ++ t)
    ;

  /* If. ThenElse. Always. */

  # create "if" statement that can be dealyed on sets until a "then-else" or
  # "always" set is reached.  When an always set is reached the condition
  # is ignore.

  isIf = attrs: (typeOf attrs) == "if";
  mkIf = condition: thenelse:
    if isIf thenelse then
      mkIf (condition && thenelse.condition) thenelse.thenelse
    else {
      _type = "if";
      inherit condition thenelse;
    };


  isThenElse = attrs: (typeOf attrs) == "then-else";
  mkThenElse = attrs:
    assert attrs ? thenPart && attrs ? elsePart;
    attrs // { _type = "then-else"; };


  isAlways = attrs: (typeOf attrs) == "always";
  mkAlways = value: { inherit value; _type = "always"; };

  pushIf = f: attrs:
    if isIf attrs then pushIf f (
      let val = attrs.thenelse; in
      # evaluate the condition.
      if isThenElse val then
        if attrs.condition then
          val.thenPart
        else
          val.elsePart
      # ignore the condition.
      else if isAlways val then
        val.value
      # otherwise
      else
        f attrs.condition val)
    else
      attrs;

  # take care otherwise you will have to handle this by hand.
  rmIf = pushIf (condition: val: val);

  evalIf = pushIf (condition: val:
    # guess: empty else part.
    ifEnable condition val
  );

  delayIf = pushIf (condition: val:
    # rewrite the condition on sub-attributes.
    mapAttrs (name: mkIf condition) val
  );

  /* Options. */

  mkOption = attrs: attrs // {_type = "option";};

  typeOf = x: if (__isAttrs x && x ? _type) then x._type else "";

  isOption = attrs: (typeOf attrs) == "option";

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

  mergeDefaultOption = name: list:
    if list != [] && tail list == [] then head list
    else if all __isFunction list then x: mergeDefaultOption (map (f: f x) list)
    else if all __isList list then concatLists list
    else if all __isAttrs list then mergeAttrs list
    else if all (x: true == x || false == x) list then fold logicalOR false list
    else if all (x: x == toString x) list then concatStrings list
    else throw "Cannot merge values.";

  mergeTypedOption = typeName: predicate: merge: name: list:
    if all predicate list then merge list
    else throw "Expect a ${typeName}.";

  mergeEnableOption = mergeTypedOption "boolean"
    (x: true == x || false == x) (fold logicalOR false);

  mergeListOption = mergeTypedOption "list"
    __isList concatLists;

  mergeStringOption = mergeTypedOption "string"
    (x: if builtins ? isString then builtins.isString x else x + "")
    concatStrings;


  # Handle the traversal of option sets.  All sets inside 'opts' are zipped
  # and options declaration and definition are separated.  If no option are
  # declared at a specific depth, then the function recurse into the values.
  # Other cases are handled by the optionHandler which contains two
  # functions that are used to defined your goal.
  # - export is a function which takes two arguments which are the option
  # and the list of values.
  # - notHandle is a function which takes the list of values are not handle
  # by this function.
  handleOptionSets = optionHandler@{export, notHandle, ...}: path: opts:
    if all __isAttrs opts then
      zip (attr: opts:
        let
          name = if path == "" then attr else path + "." + attr;
          test = partition isOption opts;
          opt = {
            inherit name;
            merge = mergeDefaultOption;
            apply = id;
          } // (head test.right);
        in
          if test.right == [] then handleOptionSets optionHandler name (map delayIf test.wrong)
          else addLocation "while evaluating the option ${name}:" (
            if tail test.right != [] then throw "Multiple options."
            else export opt (map evalIf test.wrong)
          )
      ) opts
   else addLocation "while evaluating ${path}:" (notHandle opts);

  # Merge option sets and produce a set of values which is the merging of
  # all options declare and defined.  If no values are defined for an
  # option, then the default value is used otherwise it use the merge
  # function of each option to get the result.
  mergeOptionSets = noOption: newMergeOptionSets; # ignore argument
  newMergeOptionSets =
    handleOptionSets {
      export = opt: values:
        opt.apply (
          if values == [] then
            if opt ? default then opt.default
            else throw "Not defined."
          else opt.merge (opt.name) values
        );
      notHandle = throw "Used without option declaration.";
    };

  # Keep all option declarations.
  filterOptionSets =
    handleOptionSets {
      export = opt: values: opt;
      notHandle = {};
    };

  # Evaluate a list of option sets that would be merged with the
  # function "merge" which expects two arguments.  The attribute named
  # "require" is used to imports option declarations and bindings.
  #
  # * cfg[0-9]: configuration
  # * cfgSet[0-9]: configuration set
  #
  # merge: the function used to merge options sets.
  # pkgs: is the set of packages available. (nixpkgs)
  # opts: list of option sets or option set functions.
  # config: result of this evaluation.
  fixOptionSetsFun = merge: pkgs: opts: config:
    let
      # remove possible mkIf to access the require attribute.
      noImportConditions = cfgSet0:
        let cfgSet1 = delayIf cfgSet0; in
        if cfgSet1 ? require then
          cfgSet1 // { require = rmIf cfgSet1.require; }
        else
          cfgSet1;

      # call configuration "files" with one of the existing convention.
      argumentHandler = cfg:
        let
          # {..}
          cfg0 = cfg;
          # {pkgs, config, ...}: {..}
          cfg1 = cfg { inherit pkgs config merge; };
          # pkgs: config: {..}
          cfg2 = cfg {} {};
        in
        if __isFunction cfg0 then
          if builtins.isAttrs cfg1 then cfg1
          else builtins.trace "Use '{pkgs, config, ...}:'." cfg2
        else cfg0;

      preprocess = cfg0:
        let cfg1 = argumentHandler cfg0;
            cfg2 = noImportConditions cfg1;
        in cfg2;

      getRequire = x: toList (getAttr ["require"] [] (preprocess x));
      rmRequire = x: removeAttrs (preprocess x) ["require"];
    in
      merge "" (
        map rmRequire (
          uniqFlatten getRequire [] [] (toList opts)
        )
      );

  fixOptionSets = merge: pkgs: opts:
    fix (fixOptionSetsFun merge pkgs opts);

  optionAttrSetToDocList = (l: attrs:
    (if (getAttr ["_type"] "" attrs) == "option" then
      [({
	#inherit (attrs) description;
        description = if attrs ? description then attrs.description else 
          throw ("No description ${toString l} : ${whatis attrs}");
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

  addLocation = if builtins ? addLocation then builtins.addLocation else msg: val: val;

  debugVal = if builtins ? trace then x: (builtins.trace x x) else x: x;
  debugXMLVal = if builtins ? trace then x: (builtins.trace (builtins.toXML x) x) else x: x;

  # this can help debug your code as well - designed to not produce thousands of lines
  traceWhatis = x : __trace (whatis x) x;
  traceMarked = str: x: __trace (str + (whatis x)) x;
  attrNamesToStr = a : concatStringsSep "; " (map (x : "${x}=") (__attrNames a));
  whatis = x :
      if (__isAttrs x) then
          if (x ? outPath) then "x is a derivation, name ${if x ? name then x.name else "<no name>"}, { ${attrNamesToStr x} }"
          else "x is attr set { ${attrNamesToStr x} }"
      else if (__isFunction x) then "x is a function"
      else if (x == []) then "x is an empty list"
      else if (__isList x) then "x is a list, first item is : ${whatis (__head x)}"
      else if (x == true) then "x is boolean true"
      else if (x == false) then "x is boolean false"
      else if (x == null) then "x is null"
      else "x is probably a string starting, starting characters: ${__substring 0 50 x}..";
  # trace the arguments passed to function and its result 
  traceCall  = n : f : a : let t = n2 : x : traceMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a));
  traceCall2 = n : f : a : b : let t = n2 : x : traceMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a) (t "arg 2" b));
  traceCall3 = n : f : a : b : c : let t = n2 : x : traceMarked "${n} ${n2}:" x; in t "result" (f (t "arg 1" a) (t "arg 2" b) (t "arg 3" c));



  innerClosePropagation = ready: list: if list == [] then ready else
    if (head list) ? propagatedBuildInputs then 
      innerClosePropagation (ready ++ [(head list)]) 
        ((head list).propagatedBuildInputs ++ (tail list)) else
      innerClosePropagation (ready ++ [(head list)]) (tail list);

  closePropagation = list: (uniqList {inputList = (innerClosePropagation [] list);});

  stringToCharacters = s : let l = __stringLength s; in
    if (__lessThan l 1) then [""] else  [(__substring 0 1 s)] ++ stringToCharacters (__substring 1 (__sub l 1) s);

  # should this be implemented as primop ? Yes it should..
  escapeShellArg = s :
    let escapeChar = x : if ( x == "'" ) then "'\"'\"'" else x;
    in "'" + concatStrings (map escapeChar (stringToCharacters s) ) +"'";

  defineShList = name : list : "\n${name}=(${concatStringsSep " " (map escapeShellArg list)})\n";

  # this as well :-) arg: http://foo/bar/bz.ext returns bz.ext
  dropPath = s : 
      if s == "" then "" else
      let takeTillSlash = left : c : s :
          if left == 0 then s
          else if (__substring left 1 s == "/") then
                  (__substring (__add left 1) (__sub c 1) s)
          else takeTillSlash (__sub left 1) (__add c 1) s; in
      takeTillSlash (__sub (__stringLength s) 1) 1 s;

  # calls a function (f attr value ) for each record item. returns a list
  # should be renamed to mapAttrsFlatten
  mapRecordFlatten = f : r : map (attr: f attr (builtins.getAttr attr r) ) (attrNames r);

  # maps a function on each attr value
  # f = attr : value : ..
  mapAttrs = f : r : listToAttrs ( mapRecordFlatten (a : v : nv a ( f a v ) )  r);

  # to be used with listToAttrs (_a_ttribute _v_alue)
  nv = name : value : { inherit name value; };
  # attribute set containing one attribute
  nvs = name : value : listToAttrs [ (nv name value) ];
  # adds / replaces an attribute of an attribute set
  setAttr = set : name : v : set // (nvs name v);

  # setAttrMerge (similar to mergeAttrsWithFunc but only merges the values of a particular name)
  # setAttrMerge "a" [] { a = [2];} (x : x ++ [3]) -> { a = [2 3]; } 
  # setAttrMerge "a" [] {         } (x : x ++ [3]) -> { a = [  3]; }
  setAttrMerge = name : default : attrs : f :
    setAttr attrs name (f (maybeAttr name default attrs));

  # iterates over a list of attributes collecting the attribute attr if it exists
  catAttrs = attr : l : fold ( s : l : if (hasAttr attr s) then [(builtins.getAttr attr s)] ++ l else l) [] l;

  mergeAttr = x : y : x // y;
  mergeAttrs = fold mergeAttr {};

  attrVals = nameList : attrSet :
    map (x: builtins.getAttr x attrSet) nameList;

  # Using f = a : b = b the result is similar to //
  # merge attributes with custom function handling the case that the attribute
  # exists in both sets
  mergeAttrsWithFunc = f : set1 : set2 :
    fold (n: set : if (__hasAttr n set) 
                        then setAttr set n (f (__getAttr n set) (__getAttr n set2))
                        else set )
           set1 (__attrNames set2);

  # merging two attribute set concatenating the values of same attribute names
  # eg { a = 7; } {  a = [ 2 3 ]; } becomes { a = [ 7 2 3 ]; }
  mergeAttrsConcatenateValues = mergeAttrsWithFunc ( a : b : (toList a) ++ (toList b) );

  # merges attributes using //, if a name exisits in both attributes
  # an error will be triggered unless its listed in mergeLists
  # so you can mergeAttrsNoOverride { buildInputs = [a]; } { buildInputs = [a]; } {} to get
  # { buildInputs = [a b]; }
  # merging buildPhase does'nt really make sense. The cases will be rare where appending /prefixing will fit your needs?
  # in these cases the first buildPhase will override the second one
  # ! depreceated, use mergeAttrByFunc instead
  mergeAttrsNoOverride = { mergeLists ? ["buildInputs" "propagatedBuildInputs"],
                           overrideSnd ? [ "buildPhase" ]
                         } : attrs1 : attrs2 :
    fold (n: set : 
        setAttr set n ( if (__hasAttr n set) 
            then # merge 
              if elem n mergeLists # attribute contains list, merge them by concatenating
                then (__getAttr n attrs2) ++ (__getAttr n attrs1)
              else if elem n overrideSnd
                then __getAttr n attrs1
              else throw "error mergeAttrsNoOverride, attribute ${n} given in both attributes - no merge func defined"
            else __getAttr n attrs2 # add attribute not existing in attr1
           )) attrs1 (__attrNames attrs2);


  # example usage:
  # mergeAttrByFunc  {
  #   inherit mergeAttrBy; # defined below
  #   buildInputs = [ a b ];
  # } {
  #  buildInputs = [ c d ];
  # };
  # will result in
  # { mergeAttrsBy = [...]; buildInputs = [ a b c d ]; }
  # is used by prepareDerivationArgs and can be used when composing using
  # foldArgs, composedArgsAndFun or applyAndFun. Example: composableDerivation in all-packages.nix
  mergeAttrByFunc = x : y :
    let
          mergeAttrBy2 = { mergeAttrBy=mergeAttr; }
                      // (maybeAttr "mergeAttrBy" {} x)
                      // (maybeAttr "mergeAttrBy" {} y); in
    mergeAttrs [
      x y
      (mapAttrs ( a : v : # merge special names using given functions
          if (__hasAttr a x)
             then if (__hasAttr a y)
               then v (__getAttr a x) (__getAttr a y) # both have attr, use merge func
               else (__getAttr a x) # only x has attr
             else (__getAttr a y) # only y has attr)
          ) (removeAttrs mergeAttrBy2
                         # don't merge attrs which are neither in x nor y
                         (filter (a : (! __hasAttr a x) && (! __hasAttr a y) )
                                 (__attrNames mergeAttrBy2))
            )
      )
    ];
  mergeAttrsByFuncDefaults = foldl mergeAttrByFunc { inherit mergeAttrBy; };
  # sane defaults (same name as attr name so that inherit can be used)
  mergeAttrBy = # { buildInputs = concatList; [...]; passthru = mergeAttr; [..]; }
    listToAttrs (map (n : nv n concatList) [ "buildInputs" "propagatedBuildInputs" "configureFlags" "prePhases" "postAll" ])
    // listToAttrs (map (n : nv n mergeAttr) [ "passthru" "meta" "cfg" "flags" ]);

  # returns atribute values as a list 
  flattenAttrs = set : map ( attr : builtins.getAttr attr set) (attrNames set);
  mapIf = cond : f :  fold ( x : l : if (cond x) then [(f x)] ++ l else l) [];

  # pick attrs subset_attr_names and apply f 
  subsetmap = f : attrs : subset_attr_names : 
    listToAttrs (fold ( attr : r : if __hasAttr attr attrs
          then r ++ [ (  nv attr ( f (__getAttr attr attrs) ) ) ] else r ) []
      subset_attr_names );

  # prepareDerivationArgs tries to make writing configurable derivations easier
  # example:
  #  prepareDerivationArgs {
  #    mergeAttrBy = {
  #       myScript = x : y : x ++ "\n" ++ y;
  #    };
  #    cfg = {
  #      readlineSupport = true;
  #    };
  #    flags = {
  #      readline = {
  #        set = {
  #           configureFlags = [ "--with-compiler=${compiler}" ];
  #           buildInputs = [ compiler ];
  #           pass = { inherit compiler; READLINE=1; };
  #           assertion = compiler.dllSupport;
  #           myScript = "foo";
  #        };
  #        unset = { configureFlags = ["--without-compiler"]; };
  #      };
  #    };
  #    src = ...
  #    buildPhase = '' ... '';
  #    name = ...
  #    myScript = "bar";
  #  };
  # if you don't have need for unset you can omit the surrounding set = { .. } attr
  # all attrs except flags cfg and mergeAttrBy will be merged with the
  # additional data from flags depending on config settings
  # It's used in composableDerivation in all-packages.nix. It's also used
  # heavily in the new python and libs implementation
  #
  # should we check for misspelled cfg options?
  prepareDerivationArgs = args:
    let args2 = { cfg = {}; flags = {}; } // args;
        flagName = name : "${name}Support";
        cfgWithDefaults = (listToAttrs (map (n : nv (flagName n) false) (attrNames args2.flags)))
                          // args2.cfg;
        opts = flattenAttrs (mapAttrs (a : v :
                let v2 = if (v ? set || v ? unset) then v else { set = v; };
                    n = if (__getAttr (flagName a) cfgWithDefaults) then "set" else "unset";
                    attr = maybeAttr n {} v2; in
                if (maybeAttr "assertion" true attr)
                  then attr
                  else throw "assertion of flag ${a} of derivation ${args.name} failed"
               ) args2.flags );
    in removeAttrs
      (mergeAttrsByFuncDefaults ([args] ++ opts ++ [{ passthru = cfgWithDefaults; }]))
      ["flags" "cfg" "mergeAttrBy" "fixed" ]; # fixed may be passed as fix argument or such

}
