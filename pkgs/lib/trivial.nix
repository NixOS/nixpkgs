with {
  inherit (import ./lists.nix) deepSeqList;
  inherit (import ./attrsets.nix) deepSeqAttrs;
};

rec {

  # Identity function.
  id = x: x;

  # Constant function.
  const = x: y: x;

  # Named versions corresponding to some builtin operators.
  concat = x: y: x ++ y;
  or = x: y: x || y;
  and = x: y: x && y;
  mergeAttrs = x: y: x // y;
  
  # Take a function and evaluate it with its own returned value.
  fix = f: let result = f result; in result;

  # Flip the order of the arguments of a binary function.
  flip = f: a: b: f b a;

  # `seq x y' evaluates x, then returns y.  That is, it forces strict
  # evaluation of its first argument.
  seq = x: y: if x == null then y else y;
  
  # Like `seq', but recurses into lists and attribute sets to force evaluation
  # of all list elements/attributes.
  deepSeq = x: y:
    if builtins.isList x
      then deepSeqList x y
    else if builtins.isAttrs x
      then deepSeqAttrs x y
      else seq x y;
}
