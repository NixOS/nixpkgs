/* String manipulation functions. */

let lib = import ./default.nix;

inherit (builtins) add sub lessThan;

in

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
    else map (p: substring p 1 s) (lib.range 0 (sub l 1));

    
  # Manipulate a string charcater by character and replace them by strings
  # before concatenating the results.
  stringAsChars = f: s:
    concatStrings (
      map f (stringToCharacters s)
    );

  # same as vim escape function.
  # Each character contained in list is prefixed by "\"
  escape = list : string :
    stringAsChars (c: if lib.elem c list then "\\${c}" else c) string;

  # still ugly slow. But more correct now
  # [] for zsh
  escapeShellArg = lib.escape (stringToCharacters "\\ ';$`()|<>\t*[]");

  # replace characters by their substitutes.  This function is equivalent to
  # the `tr' command except that one character can be replace by multiple
  # ones.  e.g.,
  # replaceChars ["<" ">"] ["&lt;" "&gt;"] "<foo>" returns "&lt;foo&gt;".
  replaceChars = del: new: s:
    let
      subst = c:
        (lib.fold
          (sub: res: if sub.fst == c then sub else res)
          {fst = c; snd = c;} (lib.zipLists del new)
        ).snd;
    in
      stringAsChars subst s;

  # Compares strings not requiring context equality
  # Obviously, a workaround but works on all Nix versions
  eqStrings = a: b: (a+(substring 0 0 b)) == ((substring 0 0 a)+b);

  # Cut a string with a separator and produces a list of strings which were
  # separated by this separator. e.g.,
  # `splitString "." "foo.bar.baz"' returns ["foo" "bar" "baz"].
  splitString = sep: s:
    let
      sepLen = stringLength sep;
      sLen = stringLength s;
      lastSearch = sub sLen sepLen;
      startWithSep = startAt:
        substring startAt sepLen s == sep;

      recurse = index: startAt:
        let cutUntil = i: [(substring startAt (sub i startAt) s)]; in
        if lessThan index lastSearch then
          if startWithSep index then
            let restartAt = add index sepLen; in
            cutUntil index ++ recurse restartAt restartAt
          else
            recurse (add index 1) startAt
        else
          cutUntil sLen;
    in
      recurse 0 0;

  # return the suffix of the second argument if the first argument match its
  # prefix. e.g.,
  # `removePrefix "foo." "foo.bar.baz"' returns "bar.baz".
  removePrefix = pre: s:
    let
      preLen = stringLength pre;
      sLen = stringLength s;
    in
      if pre == substring 0 preLen s then
        substring preLen (sub sLen preLen) s
      else
        s;

  basename = s: lib.last (splitString "/" s);

}
