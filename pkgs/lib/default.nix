# Utility functions.

rec {

  # "Fold" a binary function `op' between successive elements of
  # `list' with `nul' as the starting value, i.e., `fold op nul [x_1
  # x_2 ... x_n] == op x_1 (op x_2 ... (op x_n nul))'.  (This is
  # Haskell's foldr).
  fold = op: nul: list:
    if list == []
    then nul
    else op (builtins.head list) (fold op nul (builtins.tail list));

    
  # Concatenate a list of strings.
  concatStrings =
    fold (x: y: x + y) "";


  # Place an element between each element of a list, e.g.,
  # `intersperse "," ["a" "b" "c"]' returns ["a" "," "b" "," "c"].
  intersperse = separator: list:
    if list == [] || builtins.tail list == []
    then list
    else [(builtins.head list) separator]
         ++ (intersperse separator (builtins.tail list));


  # Flatten the argument into a single list; that is, nested lists are
  # spliced into the top-level lists.  E.g., `flatten [1 [2 [3] 4] 5]
  # == [1 2 3 4 5]' and `flatten 1 == [1]'.
  flatten = x:
    if builtins.isList x
    then fold (x: y: (flatten x) ++ y) [] x
    else [x];


  # Return an attribute from nested attribute sets.  For instance ["x"
  # "y"] applied to some set e returns e.x.y, if it exists.  The
  # default value is returned otherwise.
  getAttr = attrPath: default: e:
    let {
      attr = builtins.head attrPath;
      body =
        if attrPath == [] then e
        else if builtins ? hasAttr && builtins.hasAttr attr e
        then getAttr (builtins.tail attrPath) default (builtins.getAttr attr e)
        else default;
    };
  
}