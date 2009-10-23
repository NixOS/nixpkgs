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

}
