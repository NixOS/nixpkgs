/* String manipulation functions. */

let lib = import ./default.nix; in

rec {
  inherit (builtins) stringLength substring head tail lessThan sub;


  # Concatenate a list of strings.
  concatStrings = lib.fold (x: y: x + y) "";


  # Map a function over a list and concatenate the resulting strings.
  concatMapStrings = f: list: concatStrings (map f list);
  

  # Place an element between each element of a list, e.g.,
  # `intersperse "," ["a" "b" "c"]' returns ["a" "," "b" "," "c"].
  intersperse = separator: list:
    if list == [] || tail list == []
    then list
    else [(head list) separator]
         ++ (intersperse separator (tail list));


  # Concatenate a list of strings with a separator between each element, e.g.
  # concatStringsSep " " ["foo" "bar" "xyzzy"] == "foo bar xyzzy"
  concatStringsSep = separator: list:
    concatStrings (intersperse separator list);


  # Construct a Unix-style search path consisting of each `subDir"
  # directory of the given list of packages.  For example,
  # `makeSearchPath "bin" ["x" "y" "z"]' returns "x/bin:y/bin:z/bin".
  makeSearchPath = subDir: packages: 
    concatStringsSep ":" (map (path: path + "/" + subDir) packages);


  # Construct a library search path (such as RPATH) containing the
  # libraries for a set of packages, e.g. "${pkg1}/lib:${pkg2}/lib:...".
  makeLibraryPath = makeSearchPath "lib";


  # Dependening on the boolean `cond', return either the given string
  # or the empty string.
  optionalString = cond: string: if cond then string else "";

  
  # Determine whether a filename ends in the given suffix.
  hasSuffix = ext: fileName:
    let lenFileName = stringLength fileName;
        lenExt = stringLength ext;
    in !(lessThan lenFileName lenExt) &&
       substring (sub lenFileName lenExt) lenFileName fileName == ext;


  # Convert a string to a list of characters (i.e. singleton strings).
  # For instance, "abc" becomes ["a" "b" "c"].  This allows you to,
  # e.g., map a function over each character.  However, note that this
  # will likely be horribly inefficient; Nix is not a general purpose
  # programming language.  Complex string manipulations should, if
  # appropriate, be done in a derivation.
  stringToCharacters = s: let l = stringLength s; in
    if l == 0
    then []
    else [(substring 0 1 s)] ++ stringToCharacters (substring 1 (builtins.sub l 1) s);

    
  # same as vim escape function.
  # Each character contained in list is prefixed by "\"
  escape = list : string :
    lib.concatStrings (map (c: if lib.elem c list then "\\${c}" else c) (stringToCharacters string));

  # still ugly slow. But more correct now
  # [] for zsh
  escapeShellArg = lib.escape (stringToCharacters "\\ ';$`()|<>\t*[]");

    
  # !!! what is this for?
  defineShList = name: list: "\n${name}=(${concatStringsSep " " (map escapeShellArg list)})\n";


  # arg: http://foo/bar/bz.ext returns bz.ext
  # !!! isn't this what the `baseNameOf' primop does?
  dropPath = s : 
      if s == "" then "" else
      let takeTillSlash = left : c : s :
          if left == 0 then s
          else if (__substring left 1 s == "/") then
                  (__substring (__add left 1) (__sub c 1) s)
          else takeTillSlash (__sub left 1) (__add c 1) s; in
      takeTillSlash (__sub (__stringLength s) 1) 1 s;

  # Compares strings not requiring context equality
  # Obviously, a workaround but works on all Nix versions
  eqStrings = a: b: (a+(substring 0 0 b)) == ((substring 0 0 a)+b);
}
