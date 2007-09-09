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
# One example showing how to use mandatory dependencies [1], default flags [2], settings if a flag is not set [3] ..
# 
# note that you should be able to use either ["value1"] or just "value" .. (if I haven't forgotten a flatten)
# linuxthreads

#    args: with args.lib; with args;
#    let
#      co = chooseOptionsByFlags {
#        inherit args;
#        flagDescr = {
#          defaults = { implies   = [ "addOns" "addOns2"]; }; # [2] defaults and mandatory should be the first listed ? Would you like it different?
#          mandatory ={ cfgOption = [ "--with-headers=${args.kernelHeaders}/include" # [1]
#                                      "--with-tls" "--without-__thread" "--disable-sanity-checks" ];
#                       assertion = [ args.glibc.nptl ];
#                     };
#          defaultFeature    = {};
#          no_defaultFeature = { cfgOption = "--disable-defaultFeature"; }; [3]
#          addOns            = { cfgOption = "--enable-add-ons"; };
#          addOns2           = { cfgOption = "--enable-add-ons2"; implies = "addOns"; };
#          alternativeAddOn  = { cfgOption = "--enable-add-ons-alt"; blocks = ["addOns", "addOns2"]; };
#          justAOption =  { };
#        };
#        optionals = ["option1" "option2"]; # are equal to a given flag description like option1 = { buildInputs = "option1"; };
#        defaultFlags = [ "demos" "doc" ]; # are used if flags is not set by args
#      };
#
#    in args.stdenv.mkDerivation ( {
#
#      # passing the flags in case a library using this want's to check them (*) .. 
#      inherit (co) flags buildInputs configureFlags;
#      inherit (co.flags) justAOption;
#
#      extraSrc = (if co.flags.justAOption then null else src = .. );
#
#      src = fetchurl {
#        url = http://ftp.gnu.org/gnu/glibc/glibc-2.5.tar.bz2;
#        md5 = "1fb29764a6a650a4d5b409dda227ac9f";
#      };
#    } // co.pass)

    # (*) does'nt work because nix is seeing this set as derivation and complains about missing outpath.. :-(
    # using mkDerivation { ...  } // oc.flags would work but would also force evaluation.. ( would be slower )



  # resolves chosen flags based on flagDescr passed dependencies in args
  # flagDescr : { name = { cfgOption = "..."; buildInputs = "..."; blocks = "..."; implies = "..."; 
  #                        assert = "bool"; pass = { inherit (args) name }
  #                        any other options you need which you can get by catAttrs  };
  #              ...
  # args = { inherit lib stdenv;
  #        , inherit < all deps >;
  #        }
  # flags = list of chosen options..
  #
  # returns: chosen ( like flagDescr but only containing the attributes elected by flags or by implies
  #          chosenFlat ( chosen flattened to list)
  #          buildInputs
  #          configureFlags (both to be passed to mkDerivation)
  #          flags = { flagName = true/ false for each attribute in flagDescr
  #                     ... }
           
  # optionals is a list of dependency names. If passed as attribute in args they'll be automatically added
  # to flags and flagDescr ( optionalName = { buildInputs = optionalName } )
  chooseOptionsByFlags = { flagDescr, args, optionals ? [], defaultFlags ? [],
                           collectExtraPhaseActions ? [] } :
    let givenOptionals = listToAttrs 
        (mapIf ( a : (__hasAttr a args) ) 
               ( x: av x { buildInputs = x; } ) 
               optionals );
        fd = flagDescr // givenOptionals;
    in chooseOptionsByFlags2 fd collectExtraPhaseActions args ( getAttr ["flags"] defaultFlags args ++ (__attrNames givenOptionals ) );

  chooseOptionsByFlags2 = flagDescr : collectExtraPhaseActions : args : flags :
    let   
        # helper function
        collectFlags = # state : flags :
              fold ( flag : s : (
                     if (__hasAttr flag s.result) then s # this state has already been visited
                     else if (! __hasAttr flag flagDescr) then throw "unkown flag `${flag}' specified"
                           else let fDesc = (__getAttr flag flagDescr);
                                    implied = flatten ( getAttr ["implies"] [] fDesc );
                                    blocked = flatten ( getAttr ["blocks"] [] fDesc ); 
                                    # add this flag
                                    s2 = setAttr s "result" ( setAttr s.result flag (__getAttr flag flagDescr) ) ;
                                    # add implied flags
                                in collectFlags s2 implied
                   ));

        # chosen contains flagDescr but only having those attributes elected by flags 
        # (or by implies attributes of elected attributes)
        options = let stateOpts = collectFlags { blockedFlagsBy = {}; result = {}; } (flags ++ ["mandatory"]);
                      # these options have not been chosen (neither by flags nor by implies)
                      unsetOptions = filter ( x : __hasAttr x stateOpts ) ( __attrNames flagDescr );
                      # no add the corresponding no_ attributes as well ..
                      state = collectFlags stateOpts (map ( x : "no_" + x ) unsetOptions);
                  in # check for blockings:
                     assert ( mapIf ( b: __hasAttr b state.result )
                                    ( b: throw "flag ${b} is blocked by ${__getAttr b state.blockedFlagsBy}" )
                                    (__attrNames state.blockedFlagsBy) == [] ); 
                    state.result;
        flatOptions = flattenAttrs options;

        # helper functions :
        collectAttrs = attr : catAttrs attr flatOptions;
        optsConcatStrs = delimiter : attrs : concatStrings 
                ( intersperse delimiter (collectAttrs attrs) );
          
    in assert ( all id ( mapRecordFlatten ( attr : r : if ( all id ( flatten (getAttr ["assertion"] [] r ) ) ) 
                                              then true else throw "assertion failed flag ${attr}" )
                                         options) );
      rec {

          #foldOptions = attr: f : start: fold f start (catAttrs attr flatOptions);

          # compared to flags flagsSet does also contain the implied flags.. This makes it easy to write assertions. ( assert args.
          inherit options flatOptions;

          buildInputs = map ( attr: if (! __hasAttr attr args) then throw "argument ${attr} is missing!" else (__getAttr attr args) )
                        (flatten  (catAttrs "buildInputs" flatOptions));

          configureFlags = optsConcatStrs " " "cfgOption";

          flags = listToAttrs (map ( flag: av flag (__hasAttr flag options) ) (__attrNames flagDescr) );

          pass = mergeAttrs (flatten (collectAttrs "pass") );
      } #  now add additional phase actions (see examples)
        // listToAttrs ( map ( x : av x (optsConcatStrs "\n" x) ) collectExtraPhaseActions );
}
