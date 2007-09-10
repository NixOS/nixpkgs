# Utility functions.

let

  inherit (builtins)
    head tail isList stringLength substring lessThan sub listToAttrs;

in

rec {

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
  # comment: I'd rename this to getAttrRec or something like that .. (has the same name as builtin.getAttr) - Marc Weber
  getAttr = attrPath: default: e:
    let {
      attr = head attrPath;
      body =
        if attrPath == [] then e
        else if builtins ? hasAttr && builtins.hasAttr attr e
        then getAttr (tail attrPath) default (builtins.getAttr attr e)
        else default;
    };


  # Filter a list using a predicate; that is, return a list containing
  # every element from `list' for which `pred' returns true.
  filter = pred: list:
    fold (x: y: if pred x then [x] ++ y else y) [] list;


  # Return true if `list' has an element `x':
  elem = x: list: fold (a: bs: x == a || bs) false list;


  # Find the sole element in the list matching the specified
  # predicate, or returns the default value.
  findSingle = pred: default: list:
    let found = filter pred list;
    in if found == [] then default
       else if tail found != [] then
         abort "Multiple elements match predicate in findSingle."
       else head found;


  # Return true if each element of a list is equal, false otherwise.
  eqLists = xs: ys:
    if xs == [] && ys == [] then true
    else if xs == [] || ys == [] then false
    else head xs == head ys && eqLists (tail xs) (tail ys);


  # Determine whether a filename ends in the given suffix.
  hasSuffix = ext: fileName:
    let lenFileName = stringLength fileName;
        lenExt = stringLength ext;
    in !(lessThan lenFileName lenExt) &&
       substring (sub lenFileName lenExt) lenFileName fileName == ext;

       
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

  # calls a function (f attr value ) for each record item. returns a list
  mapRecordFlatten = f : r : map (attr: f attr (__getAttr attr r) ) (__attrNames r);

  # to be used with listToAttrs (_a_ttribute _v_alue)
  av = attr : value : { inherit attr value; };
  # attribute set containing one attribute
  avs = attr : value : listToAttrs [ (av attr value) ];
  # adds / replaces an attribute of an attribute set
  setAttr = set : attr : v : set // (avs attr v);

  id = x : x;
  # true if all/ at least one element(s) satisfy f
  all = f : l : fold logicalAND true (map f l);
  any = f : l : fold logicalOR false (map f l);

  # iterates over a list of attributes collecting the attribute attr if it exists
  catAttrs = attr : l : fold ( s : l : if (__hasAttr attr s) then [(__getAttr attr s)] ++ l else l) [] l;

  mergeAttrs = fold ( x : y : x // y) {};

  flattenAttrs = set : map ( attr : __getAttr attr set) (__attrNames set);
  mapIf = cond : f :  fold ( x : l : if (cond x) then [(f x)] ++ l else l) [];

# Marc 2nd proposal: (not everything has been tested in detail yet..)
           
  # calls chooseOptionsByFlags2 with some preprocessing
  # chooseOptionsByFlags2 returns an attribute set meant to be used to create new derivaitons.
  # see mkDerivationByConfigruation in all-packages.nix and the examples given below.
  # You can just copy paste them into all-packages.nix to test them..

  chooseOptionsByFlags = { flagConfig, args, optionals ? [], defaults ? [],
                           collectExtraPhaseActions ? [] } :
    let passedOptionals = filter ( x : __hasAttr x args ) optionals; # these are in optionals and in args
        # we simply merge in <optional_name> = { buildInputs = <arg.<optional_name>; pass = <arg.optional_name>; }
        flagConfigWithOptionals = flagConfig // ( listToAttrs
          (map ( o : av o ( { buildInputs = o; pass = avs o (__getAttr o args); }
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
                     if (__hasAttr flag s.result) then s # this state has already been visited
                     else if (! __hasAttr flag flagConfig) then throw "unkown flag `${flag}' specified"
                           else let fDesc = (__getAttr flag flagConfig);
                                    implied = flatten ( getAttr ["implies"] [] fDesc );
                                    blocked = flatten ( getAttr ["blocks"] [] fDesc ); 
                                    # add this flag
                                    s2 =  s // { result = ( setAttr s.result flag (__getAttr flag flagConfig) );
                                                 blockedFlagsBy = s.blockedFlagsBy 
                                                   // listToAttrs (map (b: av b flag ) blocked); };
                                    # add implied flags
                                in collectFlags s2 implied
                   ));

        # chosen contains flagConfig but only having those attributes elected by flags 
        # (or by implies attributes of elected attributes)
        options = let stateOpts = collectFlags { blockedFlagsBy = {}; result = {}; } 
                                               (flags ++ ( if (__hasAttr "mandatory" flagConfig) then ["mandatory"] else [] ));
                      # these options have not been chosen (neither by flags nor by implies)
                      unsetOptions = filter ( x : (! __hasAttr x stateOpts.result) && (__hasAttr ("no_"+x) flagConfig)) 
                                            ( __attrNames flagConfig );
                      # no add the corresponding no_ attributes as well ..
                      state = collectFlags stateOpts (map ( x : "no_" + x ) unsetOptions);
                  in # check for blockings:
                     assert ( all id ( map ( b: if (__hasAttr b state.result) 
                                             then throw "flag ${b} is blocked by flag ${__getAttr b state.blockedFlagsBy}"
                                             else true ) 
                                           (__attrNames state.blockedFlagsBy) ) ); 
                    state.result;
        flatOptions = flattenAttrs options;

        # helper functions :
        collectAttrs = attr : catAttrs attr flatOptions;
        optsConcatStrs = delimiter : attrs : concatStrings 
                ( intersperse delimiter (flatten ( collectAttrs attrs ) ) );
          
    in assert ( all id ( mapRecordFlatten ( attr : r : if ( all id ( flatten (getAttr ["assertion"] [] r ) ) ) 
                                              then true else throw "assertion failed flag ${attr}" )
                                         options) );
      ( rec {

          #foldOptions = attr: f : start: fold f start (catAttrs attr flatOptions);

          # compared to flags flagsSet does also contain the implied flags.. This makes it easy to write assertions. ( assert args.
          inherit options flatOptions collectAttrs optsConcatStrs;

          buildInputs = map ( attr: if (! __hasAttr attr args) then throw "argument ${attr} is missing!" else (__getAttr attr args) )
                        (flatten  (catAttrs "buildInputs" flatOptions));

          configureFlags = optsConcatStrs " " "cfgOption";

          #flags = listToAttrs (map ( flag: av flag (__hasAttr flag options) ) (__attrNames flagConfig) );
          flags_prefixed = listToAttrs (map ( flag: av ("flag_set_"+flag) (__hasAttr flag options) ) (__attrNames flagConfig) );

          pass = mergeAttrs (flatten (collectAttrs "pass") );
      } #  now add additional phase actions (see examples)
      // listToAttrs ( map ( x : av x (optsConcatStrs "\n" x) ) collectExtraPhaseActions ) );
}

/* 

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
  # * they can be passed by additional name as well using pass =
  # * an attribute named the same way as the flag is added indicating 
  #   true/ false (flag has been set/ not set)
  # * extra phase dependend commands can be added
  #   Its easy to add your own stuff using co.collectAttrs or co.optsConcatStrs 
  #   ( perhaps this name will change?)
  simpleFlagYesNoF = namePrefix : extraFlagAttrs : mkDerivationByConfigruation ( {
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
