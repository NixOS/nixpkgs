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

    
  # Concatenate a list of lists.
  concatLists =
    fold (x: y: x ++ y) [];


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

  # this can help debug your code as well - designed to not produce thousands of lines
  traceWhatis = x : __trace (whatis x) x;
  whatis = x : 
      if (__isAttrs x) then
          if (x ? outPath) then "x is a derivation with name ${x.name}"
          else "x is an attr set with attributes ${builtins.toString (__attrNames x)}"
      else if (__isFunction x) then "x is a function"
      else if (__isList x) then "x is a list, first item is : ${whatis (__head x)}"
      else if (x == true || x == false) then builtins.toString x
      else "x is propably a string starting, starting characters: ${__substring 0 50 x}..";


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

  # calls a function (f attr value ) for each record item. returns a list
  mapRecordFlatten = f : r : map (attr: f attr (builtins.getAttr attr r) ) (attrNames r);

  # to be used with listToAttrs (_a_ttribute _v_alue)
  nv = name : value : { inherit name value; };
  # attribute set containing one attribute
  nvs = name : value : listToAttrs [ (nv name value) ];
  # adds / replaces an attribute of an attribute set
  setAttr = set : name : v : set // (nvs name v);

  # iterates over a list of attributes collecting the attribute attr if it exists
  catAttrs = attr : l : fold ( s : l : if (hasAttr attr s) then [(builtins.getAttr attr s)] ++ l else l) [] l;

  mergeAttrs = fold ( x : y : x // y) {};

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

  # returns atribute values as a list 
  flattenAttrs = set : map ( attr : builtins.getAttr attr set) (attrNames set);
  mapIf = cond : f :  fold ( x : l : if (cond x) then [(f x)] ++ l else l) [];

  # pick attrs subset_attr_names and apply f 
  subsetmap = f : attrs : subset_attr_names : 
    listToAttrs (fold ( attr : r : if __hasAttr attr attrs
          then r ++ [ (  nv attr ( f (__getAttr attr attrs) ) ) ] else r ) []
      subset_attr_names );

# Marc 2nd proposal: (not everything has been tested in detail yet..)

  # usage / example
  # flagConfig = {
  # } // (enableDisableFeature "flagName" "configure_feature" extraAttrs;)
  #
  # is equal to
  # flagConfig = {
  #   flagName = { cfgOption = "--enable-configure_feature"; } // extraAttrs;
  #   no_flagName = { cfgOption = "--disable-configure_feature"; };
  enableDisableFeature = flagName : configure_feature : extraAttrs :
    listToAttrs [ ( nv flagName ({ cfgOption = "--enable-${configure_feature}"; } // extraAttrs ) )
                  ( nv "no_${flagName}" ({ cfgOption = "--disable-${configure_feature}"; } ) )];

  # calls chooseOptionsByFlags2 with some preprocessing
  # chooseOptionsByFlags2 returns an attribute set meant to be used to create new derivaitons.
  # see mkDerivationByConfiguration in all-packages.nix and the examples given below.
  # You can just copy paste them into all-packages.nix to test them..

  chooseOptionsByFlags = { flagConfig, args, optionals ? [], defaults ? [],
                           collectExtraPhaseActions ? [] } :
    let passedOptionals = filter ( x : hasAttr x args ) optionals; # these are in optionals and in args
        # we simply merge in <optional_name> = { buildInputs = <arg.<optional_name>; pass = <arg.optional_name>; }
        flagConfigWithOptionals = flagConfig // ( listToAttrs
          (map ( o : nv o ( { buildInputs = o; pass = nvs o (builtins.getAttr o args); }
                            // getAttr [o] {} flagConfig )
               )
               passedOptionals ) );

    in chooseOptionsByFlags2 flagConfigWithOptionals collectExtraPhaseActions args 
       ( (getAttr ["flags"] defaults args) ++ passedOptionals);

  chooseOptionsByFlags2 = flagConfig : collectExtraPhaseActions : args : flags :
    let   
        # helper function
        collectFlags = # state : flags :
              fold ( flag : s : (
                     if (hasAttr flag s.result) then s # this state has already been visited
                     else if (! hasAttr flag flagConfig) then throw "unkown flag `${flag}' specified"
                           else let fDesc = (builtins.getAttr flag flagConfig);
                                    implied = flatten ( getAttr ["implies"] [] fDesc );
                                    blocked = flatten ( getAttr ["blocks"] [] fDesc ); 
                                    # add this flag
                                    s2 =  s // { result = ( setAttr s.result flag (builtins.getAttr flag flagConfig) );
                                                 blockedFlagsBy = s.blockedFlagsBy 
                                                   // listToAttrs (map (b: nv b flag ) blocked); };
                                    # add implied flags
                                in collectFlags s2 implied
                   ));

        # chosen contains flagConfig but only having those attributes elected by flags 
        # (or by implies attributes of elected attributes)
        options = let stateOpts = collectFlags { blockedFlagsBy = {}; result = {}; } 
                                               (flags ++ ( if (hasAttr "mandatory" flagConfig) then ["mandatory"] else [] ));
                      # these options have not been chosen (neither by flags nor by implies)
                      unsetOptions = filter ( x : (! hasAttr x stateOpts.result) && (hasAttr ("no_"+x) flagConfig)) 
                                            ( attrNames flagConfig );
                      # no add the corresponding no_ attributes as well ..
                      state = collectFlags stateOpts (map ( x : "no_" + x ) unsetOptions);
                  in # check for blockings:
                     assert ( all id ( map ( b: if (hasAttr b state.result) 
                                             then throw "flag ${b} is blocked by flag ${__getAttr b state.blockedFlagsBy}"
                                             else true ) 
                                           (attrNames state.blockedFlagsBy) ) ); 
                    state.result;
        flatOptions = flattenAttrs options;

        # helper functions :
        collectAttrs = attr : catAttrs attr flatOptions;
        optsConcatStrs = delimiter : attrs : concatStrings 
                ( intersperse delimiter (flatten ( collectAttrs attrs ) ) );

        ifStringGetArg = x : if (__isAttrs x) then x # ( TODO implement __isString ?)
                             else nvs x (__getAttr x args);
          
    in assert ( all id ( mapRecordFlatten ( attr : r : if ( all id ( flatten (getAttr ["assertion"] [] r ) ) ) 
                                              then true else throw "assertion failed flag ${attr}" )
                                         options) );
      ( rec {

          #foldOptions = attr: f : start: fold f start (catAttrs attr flatOptions);

          # compared to flags flagsSet does also contain the implied flags.. This makes it easy to write assertions. ( assert args.
          inherit options flatOptions collectAttrs optsConcatStrs;

          buildInputs = map ( attr: if (! hasAttr attr args) then throw "argument ${attr} is missing!" else (builtins.getAttr attr args) )
                        (flatten  (catAttrs "buildInputs" flatOptions));
          propagatedBuildInputs = map ( attr: if (! hasAttr attr args) then throw "argument ${attr} is missing!" else (builtins.getAttr attr args) )
                        (flatten  (catAttrs "propagatedBuildInputs" flatOptions));

          configureFlags = optsConcatStrs " " "cfgOption";

          #flags = listToAttrs (map ( flag: nv flag (hasAttr flag options) ) (attrNames flagConfig) );
          flags_prefixed = listToAttrs (map ( flag: nv ("flag_set_"+flag) (hasAttr flag options) ) (attrNames flagConfig) );

          pass = mergeAttrs ( map ifStringGetArg ( flatten (collectAttrs "pass") ) );
      } #  now add additional phase actions (see examples)
      // listToAttrs ( map ( x : nv x (optsConcatStrs "\n" x) ) collectExtraPhaseActions ) );
}

/* 
  TODO: Perhaps it's better to move this documentation / these tests into some extra packages ..

  # ###########################################################################
  #  configuration tutorial .. examples and tests.. 
  #  Copy this into all-packages.nix and  try

  # The following derviations will all fail.. 
  # But they will print the passed options so that you can get to know
  # how these configurations ought to work.
  # TODO: There is no nice way to pass an otpion yet.
  #       I could imagine something like
  #       flags = [ "flagA" "flagB" { flagC = 4; } ];

  # They are named:
  # simpleYes, simpleNo, 
  # defaultsimpleYes, defaultsimpleNo
  # optionalssimpleYes, optionalssimpleNo
  # bitingsimpleYes can only be ran with -iA  blockingBiteMonster
  # assertionsimpleNo
  # of course you can use -iA and the attribute name as well to select these examples

  # dummy build input
  whoGetsTheFlagFirst = gnused;
  whoGetsTheFlagLast = gnumake;

  # simple example demonstrating containing one flag.
  # features:
  # * configure options are passed automatically
  # * buildInputs are collected (they are special, see the setup script)
  # * they can be passed by additional name as well using pass = { inherit (args) python } 
  #                                       ( or short (value not attrs) : pass = "python" )
  # * an attribute named the same way as the flag is added indicating 
  #   true/ false (flag has been set/ not set)
  # * extra phase dependend commands can be added
  #   Its easy to add your own stuff using co.collectAttrs or co.optsConcatStrs 
  #   ( perhaps this name will change?)
  simpleFlagYesNoF = namePrefix : extraFlagAttrs : mkDerivationByConfiguration ( {
    flagConfig = {
      flag    = { name = namePrefix + "simpleYes"; 
                  cfgOption = [ "--Yes" "--you-dont-need-a-list" ]; 
                  buildInputs = [ "whoGetsTheFlagFirst" ]; 
                  pass = { inherit gnumake; };
                  extraConfigureCmd = "echo Hello, it worked! ";
                  blocks = "bitingMonster";
                };
      no_flag = { name = namePrefix + "simpleNo"; 
                  cfgOption = "--no"; 
                  implies = ["bitingMonster"];
                };
      bitingMonster = {
                  extraConfigureCmd = "echo Ill bite you";
                };
      gnutar = { cfgOption="--with-gnutar";
                  # buildInputs and pass will be added automatically if gnutar is added to optionals
               };
      # can be used to check configure options of dependencies
      # eg testFlag = { assertion = [ arg.desktop.flag_set_wmii (! arg.desktop.flag_set_gnome) (! arg.desktops.flag_set_kde ]; }
      assertionFlag = { assertion = false; }; # assert is nix language keyword
                                        
    }; 

    collectExtraPhaseActions = [ "extraConfigureCmd" ];

    extraAttrs = co : {
      name = ( __head (co.collectAttrs "name") );

      unpackPhase = "
       echo my name is 
       echo \$name
       echo
       echo flag given \\(should be 1 or empty string\\) ? 
       echo \$flag_set_flag
       echo
       echo my build inputs are 
       echo \$buildInputs
       echo
       echo my configuration flags are 
       echo \$configureFlags
       echo
       echo what about gnumake? Did it pass?
       echo \$gnumake
       echo 
       echo configurePhase command is
       echo $\configurePhase
       echo 
       echo gnutar passed? \\(optional test\\)
       echo \$gnutar
       echo
       echo dying now
       echo die_Hopefully_Soon
      ";
    configurePhase = co.extraConfigureCmd;
    };
  } // extraFlagAttrs ); 


  simpleYes = simpleFlagYesNoF "" {} {
    inherit whoGetsTheFlagFirst lib stdenv;
    flags = ["flag"];
  };
  # note the "I'll bite you" because of the implies attribute
  simpleNo = simpleFlagYesNoF "" {} {
    inherit whoGetsTheFlagFirst lib stdenv;
    flags = [];
  };

  # specifying defaults by adding a default attribute
  
  yesAgainDefault = simpleFlagYesNoF "default" { defaults = [ "flag" ];} {
    inherit whoGetsTheFlagFirst lib stdenv;
  };
  noAgainOverridingDefault = simpleFlagYesNoF "default" { defaults = [ "flag" ];} {
    inherit whoGetsTheFlagFirst lib stdenv;
    flags = [];
  };

  # requested by Michael Raskin: activate flag automatically if dependency is passed:
  withGnutarOptional = simpleFlagYesNoF "optionals" { optionals = [ "gnutar" ];} {
    flags = [ "flag" ]; # I only need to pass this to trigger name optionalssimpleYes
    inherit whoGetsTheFlagFirst lib stdenv;
    inherit gnutar;
  };
  withoutGnutarOptional = simpleFlagYesNoF "optionals" { optionals = [ "gnutar" ];} {
    inherit whoGetsTheFlagFirst lib stdenv;
  };

  # blocking example, this shouldn't even start building:
  blockingBiteMonster = simpleFlagYesNoF "biting" {} {
    inherit whoGetsTheFlagFirst lib stdenv;
    flags = [ "flag" "bitingMonster" ];
  };

  # assertion example this shouldn't even start building:
  assertion = simpleFlagYesNoF "assertion" {} {
    inherit whoGetsTheFlagFirst lib stdenv;
    flags = [ "assertionFlag" ];
  };
*/
